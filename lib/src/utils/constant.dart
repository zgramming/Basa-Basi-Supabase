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
}
