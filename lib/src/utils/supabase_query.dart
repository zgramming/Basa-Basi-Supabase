import 'dart:io';

import 'package:global_template/global_template.dart';
import 'package:path/path.dart' as path;
import 'package:supabase/supabase.dart';

import './utils.dart';
import '../network/model/network.dart';

class SupabaseQuery {
  SupabaseQuery._();

  static final SupabaseQuery instance = SupabaseQuery._();
  static final _supabase = Constant.supabase;

  Future<ProfileModel> signUp({
    required String email,
    required String password,
    required String tokenFirebase,
  }) async {
    try {
      /// Check if exists email in database
      final emailIsExists =
          await _supabase.from(Constant.tableProfile).select('id').eq('email', email).execute();

      if (emailIsExists.error?.message != null) {
        throw Exception(emailIsExists.error?.message);
      }

      final emailMap = List.from(emailIsExists.data as List);
      if (emailMap.isNotEmpty) {
        throw Exception('Email dengan nama $email sudah digunakan');
      }

      /// Insert Profile
      final result = await _insertProfile(
        email: email,
        password: password,
      );

      if (result.error?.message != null) {
        throw Exception(result.error?.message);
      }

      final data = List.from(result.data as List).first;
      final user = ProfileModel.fromJson(Map<String, dynamic>.from(data as Map));

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileModel> signIn({
    required String email,
    required String password,
    required String tokenFirebase,
  }) async {
    try {
      final result = await Constant.supabase
          .from(Constant.tableProfile)
          .select()
          .eq('email', email)
          .eq('password', password)
          .execute();

      if (result.error?.message != null) {
        throw Exception(result.error?.message);
      }

      final users = List.from(result.data as List);

      if (users.isEmpty) {
        throw Exception('Username / Password tidak valid');
      }

      final updateTokenFirebase = await _supabase
          .from(Constant.tableProfile)
          .update({
            'token_firebase': tokenFirebase,
          })
          .eq('email', email)
          .eq('password', password)
          .single()
          .execute();

      if (updateTokenFirebase.error?.code != null) {
        throw Exception(result.error?.message);
      }

      final user =
          ProfileModel.fromJson(Map<String, dynamic>.from(updateTokenFirebase.data as Map));
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signOut() async {
    final result = await _supabase.auth.signOut();
    final error = result.error?.message;
    if (error != null) {
      throw Exception(error);
    }

    return true;
  }

  ///* START Profile Section
  Future<PostgrestResponse> _insertProfile({
    required String email,
    required String password,
  }) async {
    final randomUsername = GlobalFunction.generateRandomString(
      10,
      rules: GenerateRandomStringRules.combineNumberAlphabetLowercase,
    );

    final result = await _supabase.from(Constant.tableProfile).insert({
      'email': email,
      'password': password,
      'username': randomUsername,
      'fullname': email,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }).execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    return result;
  }

  Future<ProfileModel> updateProfile(
    int idUser, {
    required String oldUsername,
    required String profileUrl,
    String? newUsername,
    String? fullname,
    String? description,
    File? file,
  }) async {
    String? pictureProfileUrl;
    DateTime? updatedUsernameAt;

    if (newUsername != oldUsername) {
      /// Check apakah kuota untuk mengganti username masih ada / belum
      final quotaChangeUsernameStillExists = await _supabase
          .from(Constant.tableProfile)
          .select('updated_username_at')
          .eq('id', idUser)
          .single()
          .execute();

      if (quotaChangeUsernameStillExists.error?.message != null) {
        throw Exception(quotaChangeUsernameStillExists.error?.message);
      }

      final mapQuotaChangeUsernameStillExists = quotaChangeUsernameStillExists.data as Map;

      if (mapQuotaChangeUsernameStillExists['updated_username_at'] != null) {
        throw Exception('Tidak bisa mengubah username kembali, karena sudah melebihi kuota');
      }

      updatedUsernameAt = DateTime.now();
    }

    /// Cari username apakah sudah ada/belum
    final usernameIsExists = await _supabase
        .from(Constant.tableProfile)
        .select('id')
        .eq('username', newUsername)
        .not('id', 'eq', idUser)
        .execute();

    if (usernameIsExists.error?.message != null) {
      throw Exception(usernameIsExists.error?.message);
    }

    final mapUsername = usernameIsExists.data as List;

    if (mapUsername.isNotEmpty) {
      throw Exception('Username dengan nama $newUsername sudah digunakan oleh orang lain.');
    }

    if (file != null) {
      final generateRandomString = GlobalFunction.generateRandomString(20);
      final storage = _supabase.storage.from(Constant.avatarsBucket);
      final filename = "$generateRandomString${path.extension(file.path)}";
      await storage.upload(filename, file);
      final getUrl = storage.getPublicUrl(filename);
      pictureProfileUrl = getUrl.data;

      if (profileUrl.isNotEmpty) {
        await _supabase.storage.from('avatars').remove([(profileUrl.split('/').last)]);
      }
    }

    final result = await _supabase
        .from('profile')
        .update({
          'username': newUsername,
          if (pictureProfileUrl != null) 'picture_profile': pictureProfileUrl,
          'fullname': fullname,
          'description': description,
          'is_new_user': false,
          if (updatedUsernameAt != null)
            'updated_username_at': updatedUsernameAt.millisecondsSinceEpoch,
        })
        .eq('id', idUser)
        .execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    final data = List.from(result.data as List).first;
    final user = ProfileModel.fromJson(Map<String, dynamic>.from(data as Map));
    return user;
  }

  Future<List<ProfileModel>> searchUserByEmailOrUsername({
    required int idUser,
    required String query,
  }) async {
    final result = await _supabase
        .from('profile')
        .select()
        .neq('id', '$idUser')
        .or('email.ilike.%$query%, username.ilike.%$query%')
        .execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    final data = result.data as List;

    final users =
        data.map((e) => ProfileModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();

    return users;
  }

  Future<ProfileModel> getUserById(int id) async {
    final result =
        await _supabase.from(Constant.tableProfile).select().eq('id', id).single().execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    return ProfileModel.fromJson(Map<String, dynamic>.from(result.data as Map));
  }

  Future<ProfileModel> updateFromNewToOldUser(int idUser) async {
    final result = await _supabase
        .from(Constant.tableProfile)
        .update({'is_new_user': false})
        .eq('id', idUser)
        .single()
        .execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    return ProfileModel.fromJson(Map<String, dynamic>.from(result.data as Map));
  }

  ///* END Profile Section

  ///* START Inbox Section

  ///? Get All inbox by idUser
  Future<List<InboxModel>> getAllInboxByIdUser(int me) async {
    /**
     * SELECT * FROM inbox as inbox 
     * JOIN profile as user ON (inbox.id_user = user.id)
     * JOIN profile as sender ON (inbox.id_sender = sender.id)
     * WHERE inbox.id_user = $idUser
     * 
     */
    final result = await _supabase
        .from("inbox")
        .select("*, user:id_user(*), pairing:id_pairing(*)")
        .eq('id_user', me)
        .execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    final data = List.from(result.data as List);
    final inboxes =
        data.map((e) => InboxModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    return inboxes;
  }

  Future<PostgrestResponse> insertOrUpdateInbox({
    // required int id,
    required int idUser,
    required int idSender,
    required int idPairing,
    required String inboxChannel,
    String? inboxLastMessage,
    int? inboxLastMessageDate,
    String? inboxLastMessageStatus,
    String? inboxLastMessageType,
    int? totalUnreadMessage,
  }) async {
    final query = await _supabase
        .from(Constant.tableInbox)
        .select('id')
        // .eq('id_user', idUser)
        .eq('inbox_channel', inboxChannel)
        .execute(count: CountOption.exact);

    final data = <String, dynamic>{
      'inbox_channel': inboxChannel,
      'id_sender': idSender,
      'inbox_last_message': inboxLastMessage,
      'inbox_last_message_date': inboxLastMessageDate,
      'inbox_last_message_status': inboxLastMessageStatus,
      'inbox_last_message_type': inboxLastMessageType,
    };

    final isEmpty = List.from(query.data as List).isEmpty;
    // log('query data ${query.error}');
    PostgrestResponse response;
    if (isEmpty) {
      /// Insert
      data['id_user'] = idUser;
      data['id_pairing'] = idPairing;
      data['created_at'] = DateTime.now().millisecondsSinceEpoch;

      /// Insert first for [my] inbox
      response = await _supabase.from('inbox').insert(data).execute();

      data['id_user'] = idPairing;
      data['id_pairing'] = idUser;

      /// Insert second for [pairing] inbox
      await _supabase.from('inbox').insert(data).execute();
    } else {
      /// Update
      data['updated_at'] = DateTime.now().millisecondsSinceEpoch;

      response = await _supabase
          .from('inbox')
          .update(data)
          // .eq('id_user', idUser)
          .eq('inbox_channel', inboxChannel)
          .execute();
    }

    if (response.error?.code != null) {
      throw Exception(response.error?.message);
    }

    return response;
  }

  Future<PostgrestResponse> increaseTotalUnreadMessage({
    required int idUser,
    required String inboxChannel,
  }) async {
    /// Equal To :
    /// UPDATE [inbox] SET total_unread_message = total_unread_message + 1 WHERE id_user = $idUser AND inbox_channel = $inboxChannel
    final result = await _supabase.rpc(
      'increment_total_unread_message',
      params: {
        'id_userr': idUser,
        'inbox_channell': inboxChannel,
      },
    ).execute();

    if (result.error?.code != null) {
      throw Exception(result.error?.message);
    }

    return result;
  }

  Future<PostgrestResponse> upsertArchiveInbox(List<InboxModel> values) async {
    if (values.isEmpty) {
      throw Exception('Data tidak boleh kosong');
    }
    final data = <Map<String, dynamic>>[];
    for (final value in values) {
      data.add({
        'id': value.id,
        'is_archived': value.isArchived,
      });
    }

    // final result = await _supabase.from(Constant.tableInbox).upsert(data).execute();
    final result = await _supabase
        .from(Constant.tableInbox)
        .update({'is_archived': values.first.isArchived})
        .in_('id', values.map((e) => e.id).toList())
        .execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    return result;
  }

  Future<PostgrestResponse> updateTypingInbox({
    required int you,
    required int idPairing,
  }) async {
    final inboxChannel = Shared.instance.getConversationID(you: you, pairing: idPairing);
    final result = await _supabase
        .from(Constant.tableInbox)
        .update({'last_typing_date': DateTime.now().millisecondsSinceEpoch})
        .eq('id_user', you)
        .eq('inbox_channel', inboxChannel)
        .execute();

    if (result.error?.code != null) {
      throw Exception(result.error?.message);
    }

    return result;
  }

  Future<void> updateLastMessageStatusInbox({
    required int idUser,
    required String inboxChannel,
  }) async {
    final result = await _supabase
        .from(Constant.tableInbox)
        .update({
          'inbox_last_message_status': messageStatusValues[MessageStatus.read],
        })
        .eq('id_user', idUser)
        .eq('inbox_channel', inboxChannel)
        .execute();

    if (result.error?.code != null) {
      throw Exception(result.error?.message);
    }
  }

  ///* END Inbox Section

  ///* START Message Section
  Future<List<MessageModel>> getAllMessageByInboxChannel(String inboxChannel) async {
    final result = await _supabase
        .from(Constant.tableMessage)
        .select()
        .eq('inbox_channel', inboxChannel)
        .order('message_date')
        .execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    final data = List.from(result.data as List);

    if (data.isEmpty) {
      return [];
    }

    final messages =
        data.map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();

    return messages;
  }

  Future<MessageModel> sendMessage({
    required MessagePost post,
  }) async {
    final result = await _supabase.from(Constant.tableMessage).insert(post.toJson()).execute();
    if (result.error?.code != null) {
      throw Exception(result.error?.message);
    }

    final data = List.from(result.data as List).first;
    final message = MessageModel.fromJson(Map<String, dynamic>.from(data as Map));
    return message;
  }

  Future<PostgrestResponse> updateIsReadMessage({
    required MessageStatus messageStatus,
    required String inboxChannel,
    required int idUser,
  }) async {
    final result = await _supabase
        .from(Constant.tableMessage)
        .update({
          'message_status': messageStatusValues[messageStatus],
        })
        .eq('inbox_channel', inboxChannel)
        .eq('id_sender', idUser)
        .execute();

    if (result.error?.code != null) {
      throw Exception(result.error?.message);
    }

    return result;
  }

  Future<PostgrestResponse> resetUnreadMessageToZero({
    required String inboxChannel,
    required int idUser,
  }) async {
    final result = await _supabase
        .from(Constant.tableInbox)
        .update({'total_unread_message': 0})
        .eq('inbox_channel', inboxChannel)
        .eq('id_user', idUser)
        .execute();

    if (result.error?.code != null) {
      throw Exception(result.error?.message);
    }

    return result;
  }

  Future<int> totalUnreadMessage({
    required int idUser,
    required String inboxChannel,
  }) async {
    final result = await _supabase
        .from(Constant.tableMessage)
        .select('id')
        .eq('inbox_channel', inboxChannel)
        .eq('id_sender', idUser)
        .not('message_status', 'eq', messageStatusValues[MessageStatus.read])
        .execute(count: CountOption.exact);

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    final total = List.from(result.data as List).length;

    return total;
  }

  ///* END Message Section

  ///* START UTILS
  Future<String> uploadFileToSupabase({
    required File file,
    required String storageName,
  }) async {
    final generateRandomString = GlobalFunction.generateRandomString(20);
    final storage = _supabase.storage.from(storageName);
    final filename = "$generateRandomString${path.extension(file.path)}";
    await storage.upload(filename, file);
    final getUrl = storage.getPublicUrl(filename);
    final result = getUrl.data;
    return result ?? '';
  }

  ///* END UTILS
}
