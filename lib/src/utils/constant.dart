import 'package:google_fonts/google_fonts.dart';
import 'package:supabase/supabase.dart';

import 'utils.dart';

class Constant {
  Constant._();

  static final Constant instance = Constant._();

  static final supabase = SupabaseClient(supabaseUrl, supabaseKey);

  static const onboarding1 = 'assets/images/ob1.png';
  static const onboarding2 = 'assets/images/ob2.png';
  static const onboarding3 = 'assets/images/ob3.png';

  static final comfortaa = GoogleFonts.comfortaa();
  static final maitree = GoogleFonts.maitree();

  /// SharedPreferences Key
  static const spOnboardingKey = '_spOnboardingKey';
  static const spDarkModeKey = '_spDarkModeKey';
  static const spUserKey = '_spUserKey';

  /// Name Table Supabase
  static const tableProfile = 'profile';
  static const tableInbox = 'inbox';
  static const tableMessage = 'message';

  /// Hive key box
  static const hiveKeyBoxProfile = 'profile';
}
