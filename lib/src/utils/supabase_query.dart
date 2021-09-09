import 'dart:developer';
import 'dart:io';

import 'package:global_template/global_template.dart';
import 'package:supabase/supabase.dart';
import 'package:path/path.dart' as path;
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

  /// Profile Section
  Future<PostgrestResponse> _insertProfile({
    required String email,
    required String password,
    required String idUser,
  }) async {
    final randomUsername = GlobalFunction.generateRandomString(
      10,
      rules: GenerateRandomStringRules.combineNumberAlphabetLowercase,
    );
    // final ProfileModel profile = ProfileModel(
    //   email: email,
    //   password: password,
    //   idUser: idUser,
    //   username: randomUsername,
    //   createdAt: DateTime.now(),
    // );

    final result = await _supabase.from(Constant.tableProfile).insert({
      'email': email,
      'password': password,
      'id_user': idUser,
      'username': randomUsername,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }).execute();

    return result;
  }

  Future<PostgrestResponse> setupProfileWhenFirstRegister(
    String idUser, {
    required String username,
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
    log('pcutre profile $pictureProfileUrl || iduser $idUser');
    final result = await _supabase
        .from('profile')
        .update({'username': username, 'picture_profile': pictureProfileUrl})
        .eq('id_user', idUser)
        .execute();

    log('result ${result.data}');

    if (result.error != null) {
      throw Exception(result.error!.message);
    }
    return result;
  }
}
