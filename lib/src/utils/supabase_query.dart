import 'dart:developer';
import 'dart:io';

import 'package:basa_basi_supabase/src/network/model/inbox/inbox_model.dart';
import 'package:basa_basi_supabase/src/network/model/network.dart';
import 'package:global_template/global_template.dart';
import 'package:path/path.dart' as path;
import 'package:supabase/supabase.dart';

import 'utils.dart';

class SupabaseQuery {
  SupabaseQuery._();

  static final SupabaseQuery instance = SupabaseQuery._();
  static final _supabase = Constant.supabase;

  Future<PostgrestResponse> signUp({
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
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<PostgrestResponse> signIn({
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
      return getUser;
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

    return result;
  }

  Future<PostgrestResponse> setupProfileWhenFirstRegister(
    String idUser, {
    String? username,
    String? fullname,
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
          'picture_profile': pictureProfileUrl,
          'fullname': fullname,
        })
        .eq('id_user', idUser)
        .execute();

    log('SetupProfileQuery Data: ${result.data} || IdUser $idUser');
    log('SetupProfileQuery Error: ${result.error}');

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }
    return result;
  }

  ///* END Profile Section

  ///* START Inbox Section

  ///? Get All inbox by idUser
  Future<PostgrestResponse> getAllInboxByIdUser(int idUser) async {
    /**
     * SELECT * FROM inbox as inbox 
     * JOIN profile as user ON (inbox.id_user = user.id)
     * JOIN profile as sender ON (inbox.id_sender = sender.id)
     * WHERE inbox.id_user = $idUser
     * 
     */
    final result = await _supabase
        .from("inbox")
        .select("*, user:id_user(*), sender:id_sender(*)")
        .eq('id_user', idUser)
        .execute();

    if (result.error?.message != null) {
      throw Exception(result.error?.message);
    }
    return result;
  }

  Future<void> insertOrUpdate(int you) async {
    final isExists =
        await _supabase.from('inbox').select('id').eq('id_user', you).single().execute();
    if ((isExists.count ?? 0) <= 0) {
      /// Insert
      final insert = await _supabase.from('inbox').insert(
        {},
      ).execute();
    } else {
      /// Update
      final update = await _supabase.from('inbox').update(
        {},
      ).execute();
    }
  }

  ///* END Inbox Section

  ///* START Message Section
  Future<PostgrestResponse> getAllMessageByInboxChannel(String inboxChannel) async {
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
    return result;
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
}
