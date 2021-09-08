import 'dart:developer';

import 'package:global_template/global_template.dart';
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
      final result =
          await _insertProfile(email: email, password: password, idUser: auth.user?.id ?? '');
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
      'password': 'password',
      'id_user': idUser,
      'username': randomUsername,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }).execute();
    log('insertProfile 1. ${result.count}');
    log('insertProfile 2. ${result.data}');
    log('insertProfile 3. ${result.error?.toJson()}');
    log('insertProfile 4. ${result.status}');
    return result;
  }

  Future<void> updateUsernameAndProfileImage() async {
    // final result = _supabase.
  }
}
