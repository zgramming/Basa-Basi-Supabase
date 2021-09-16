import 'package:basa_basi_supabase/src/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import './screen/login/login_screen.dart';
import './screen/message/message_screen.dart';
import './screen/onboarding/onboarding_screen.dart';
import './screen/search_new_friend/search_new_friend.dart';
import './screen/setup_profile/setup_profile_screen.dart';
import './screen/splash/splash_screen.dart';
import './screen/welcome/welcome_screen.dart';
import './screen/welcome/widgets/search_message.dart';
import 'screen/inbox/widgets/inbox_archived.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basa Basi',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale('id', 'ID')],
      color: Colors.white,
      theme: ThemeData(
        primaryColor: colorPallete.primaryColor,
        textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme),
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: colorPallete.primaryColor,
              onPrimary: Colors.white,
              secondary: colorPallete.accentColor,
              onSecondary: Colors.white,
            ),
      ),
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        final routeAnimation = RouteAnimation();
        switch (settings.name) {
          case OnboardingScreen.routeNamed:
            return routeAnimation.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) => const OnboardingScreen(),
            );
          case LoginScreen.routeNamed:
            return routeAnimation.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) => const LoginScreen(),
            );
          case SetupProfileScreen.routeNamed:
            return routeAnimation.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) => const SetupProfileScreen(),
            );
          case WelcomeScreen.routeNamed:
            return routeAnimation.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) => const WelcomeScreen(),
            );
          case MessageScreen.routeNamed:
            return routeAnimation.slideTransition(
              screen: (ctx, animation, secondaryAnimation) => const MessageScreen(),
              slidePosition: SlidePosition.fromLeft,
            );
          case SearchMessage.routeNamed:
            return routeAnimation.slideTransition(
              screen: (ctx, animation, secondaryAnimation) => const SearchMessage(),
            );
          case SearchNewFriendScreen.routeNamed:
            return routeAnimation.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) => const SearchNewFriendScreen(),
            );
          case MessagePreviewImage.routeNamed:
            final String? fileUrl = settings.arguments as String?;
            return routeAnimation.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) =>
                  MessagePreviewImage(fileUrl: fileUrl ?? ''),
            );
          case InboxArchived.routeNamed:
            return routeAnimation.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) => const InboxArchived(),
            );

          default:
        }
      },
      // onGenerateRoute: MyRoute.configure,
    );
  }
}
