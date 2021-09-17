import 'dart:developer';
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
  }) async {
    try {
      final auth = await _supabase.auth.signUp(email, password);
      if (auth.error?.message != null) {
        throw Exception(auth.error!.message);
      }

      /// Insert Profile
      final result = await _insertProfile(
        email: email,
        password: password,
        idUser: auth.user?.id ?? '',
      );

      log('insertProfile 1. ${result.count}');
      log('insertProfile 2. ${result.data} this return List instead of single object');
      log('insertProfile 3. ${result.error?.toJson()}');
      log('insertProfile 4. ${result.status}');

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
  }) async {
    try {
      final result = await _supabase.auth.signIn(
        email: email,
        password: password,
      );

      if (result.error?.message != null) {
        throw Exception(result.error!.message);
      }

      final getUser = await Constant.supabase
          .from(Constant.tableProfile)
          .select()
          .eq('id_user', result.user!.id)
          .single()
          .execute();

      if (getUser.error?.message != null) {
        throw Exception(result.error?.message);
      }

      final user = ProfileModel.fromJson(Map<String, dynamic>.from(getUser.data as Map));

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
    required String idUser,
  }) async {
    final randomUsername = GlobalFunction.generateRandomString(
      10,
      rules: GenerateRandomStringRules.combineNumberAlphabetLowercase,
    );

    final result = await _supabase.from(Constant.tableProfile).insert({
      'email': email,
      'password': password,
      'id_user': idUser,
      'username': randomUsername,
      'fullname': email,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }).execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    return result;
  }

  Future<ProfileModel> setupProfile(
    String idUser, {
    String? username,
    String? fullname,
    String? description,
    File? file,
  }) async {
    String? pictureProfileUrl;
    if (file != null) {
      final generateRandomString = GlobalFunction.generateRandomString(20);
      final storage = _supabase.storage.from('avatars');
      final filename = "$generateRandomString${path.extension(file.path)}";
      await storage.upload(filename, file);
      final getUrl = storage.getPublicUrl(filename);
      pictureProfileUrl = getUrl.data;
    }
    log('picture profile $pictureProfileUrl || iduser $idUser');
    final result = await _supabase
        .from('profile')
        .update({
          'username': username,
          if (pictureProfileUrl != null) 'picture_profile': pictureProfileUrl,
          'fullname': fullname,
          'description': description,
        })
        .eq('id_user', idUser)
        .execute();

    log('SetupProfileQuery Data: ${result.data} || IdUser $idUser');
    log('SetupProfileQuery Error: ${result.error}');

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
        .eq('id_pairing', me)
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
    required int idUser,
    required int idSender,
    required int idPairing,
    required String inboxChannel,
    required String inboxLastMessage,
    required int inboxLastMessageDate,
    required String inboxLastMessageStatus,
    required String inboxLastMessageType,
    required int totalUnreadMessage,
  }) async {
    final query = await _supabase
        .from('inbox')
        .select('id')
        .filter('id_user', 'eq', idUser)
        .filter('inbox_channel', 'eq', inboxChannel)
        .single()
        .execute(count: CountOption.exact);

    final data = {
      'id_sender': '$idSender',
      'id_user': '$idUser',
      'inbox_channel': inboxChannel,
      'inbox_last_message': inboxLastMessage,
      'inbox_last_message_date': '$inboxLastMessageDate',
      'inbox_last_message_status': inboxLastMessageStatus,
      'inbox_last_message_type': inboxLastMessageType,
      'total_unread_message': totalUnreadMessage,
    };

    final isNotExists = (query.data ?? 0) == 0;
    PostgrestResponse response;
    if (isNotExists) {
      /// Insert
      data['id_pairing'] = idPairing;
      data['created_at'] = DateTime.now().millisecondsSinceEpoch;

      response = await _supabase.from('inbox').insert(data).execute();
    } else {
      /// Update
      data['updated_at'] = DateTime.now().millisecondsSinceEpoch;
      response = await _supabase
          .from('inbox')
          .update(data)
          .eq('id_user', idUser)
          .eq('inbox_channel', inboxChannel)
          .execute();
    }

    if (response.error?.message != null) {
      throw Exception(response.error?.message);
    }

    return response;
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

  Future<PostgrestResponse> updateTypingInbox(int you, int idPairing) async {
    final inboxChannel = getConversationID(you: you, pairing: idPairing);
    final result = await _supabase
        .from(Constant.tableInbox)
        .update({
          'last_typing_date': DateTime.now().millisecondsSinceEpoch,
        })
        .eq('id_user', you)
        .eq('inbox_channel', inboxChannel)
        .execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    return result;
  }

  ///* END Inbox Section

  ///* START Message Section
  Future<List<MessageModel>> getAllMessageByInboxChannel(String inboxChannel) async {
    final result = await _supabase
        .from('message')
        .select()
        .eq('inbox_channel', inboxChannel)
        .order(
          'message_date',
        )
        .execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    final data = List.from(result.data as List);
    final messages =
        data.map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();

    return messages;
  }

  Future<MessageModel> sendMessage({
    required MessagePost post,
  }) async {
    final result = await _supabase.from('message').insert(post.toJson()).execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }

    final data = List.from(result.data as List).first;
    final message = MessageModel.fromJson(Map<String, dynamic>.from(data as Map));
    return message;
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
