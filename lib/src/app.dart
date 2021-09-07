import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:basa_basi_supabase/src/utils/constant.dart';

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
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: colorPallete.primaryColor,
              onPrimary: Colors.white,
              secondary: colorPallete.accentColor,
              onSecondary: Colors.white,
            ),
        primaryColor: colorPallete.primaryColor,
        accentColor: colorPallete.accentColor,
        textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme),
      ),
      home: OnboardingScreen(),
      onGenerateRoute: (settings) {
        final routeAnimation = RouteAnimation();
        switch (settings.name) {
          case LoginScreen.routeNamed:
            return routeAnimation.fadeTransition(
                screen: (ctx, animation, secondaryAnimation) => const LoginScreen());
          case WelcomeScreen.routeNamed:
            return routeAnimation.fadeTransition(
                screen: (ctx, animation, secondaryAnimation) => const WelcomeScreen());
          case MessageDetailScreen.routeNamed:
            return routeAnimation.slideTransition(
              screen: (ctx, animation, secondaryAnimation) => const MessageDetailScreen(),
              slidePosition: SlidePosition.fromLeft,
            );

          default:
        }
      },
      // onGenerateRoute: MyRoute.configure,
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;
  int _selectedIndex = 0;

  final _pages = <Widget>[
    PageItem(
      urlImageAsset: '${appConfig.urlImageAsset}/ob1.png',
      title: 'Login with Google',
      subtitle: 'Login & Daftar dengan mudah menggunakan akun Google-mu',
    ),
    PageItem(
      urlImageAsset: '${appConfig.urlImageAsset}/ob2.png',
      title: 'Bincang-Bincang Bersama',
      subtitle: 'Melakukan percakapan dengan teman, gebetan, calon pacar dimana saja dengan mudah',
    ),
    PageItem(
      urlImageAsset: '${appConfig.urlImageAsset}/ob3.png',
      title: 'Fitur-Fitur Menarik',
      subtitle: 'Mengirim pesan, gambar, file dan lainnya agar percakapan kamu tidak membosankan',
    ),
  ];

  @override
  void initState() {
    _controller = PageController(initialPage: _selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (value) => setState(() => _selectedIndex = value),
              itemBuilder: (context, index) {
                final page = _pages[index];
                return page;
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: sizes.width(context),
              // color: Colors.red,
              padding: EdgeInsets.only(bottom: sizes.height(context) / 10, left: 24.0, right: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: _pages.length,
                      effect: SlideEffect(
                        dotColor: const Color(0xFFC4C4C4),
                        activeDotColor: colorPallete.accentColor!,
                      ),
                      onDotClicked: (index) {
                        setState(() => _selectedIndex = index);
                        _controller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                        log('$_selectedIndex');
                      },
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (_selectedIndex == (_pages.length - 1)) {
                          Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
                        } else {
                          setState(() {
                            _selectedIndex++;
                          });
                          _controller.animateToPage(
                            _selectedIndex,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        side: BorderSide(color: colorPallete.accentColor!),
                        padding: const EdgeInsets.all(16.0),
                        backgroundColor: _selectedIndex == (_pages.length - 1)
                            ? colorPallete.accentColor
                            : Colors.transparent,
                      ),
                      child: Text(
                        _selectedIndex == (_pages.length - 1) ? 'Ayo Mulai' : 'Selanjutnya',
                        style: Constant.comfortaa.copyWith(
                          color: _selectedIndex == (_pages.length - 1)
                              ? Colors.white
                              : colorPallete.accentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageItem extends StatelessWidget {
  const PageItem({
    Key? key,
    required this.urlImageAsset,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String urlImageAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: sizes.height(context) / 1.75,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: colorPallete.primaryColor,
                ),
              ),
              Positioned(
                top: sizes.statusBarHeight(context) + 20,
                right: -40,
                child: Image.asset(
                  urlImageAsset,
                  width: sizes.width(context) / 1.5,
                  height: sizes.width(context) / 1.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: Constant.maitree.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorPallete.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: Constant.comfortaa.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: colorPallete.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class LoginScreen extends StatelessWidget {
  static const routeNamed = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      '${appConfig.urlImageAsset}/logo_primary.png',
                      width: sizes.width(context) / 2,
                      height: sizes.width(context) / 2,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Ayo mulai jalin kebersamaan dengan berbincang bersama teman kamu',
                      style: Constant.comfortaa.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: sizes.width(context),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: OutlinedButton(
                    onPressed: () async {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      padding: const EdgeInsets.all(24.0),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          '${appConfig.urlImageAsset}/ob1.png',
                          width: 32,
                        ),
                        Expanded(
                          child: Text(
                            'Login with Google',
                            textAlign: TextAlign.center,
                            style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CopyRightVersion(
              decoration: BoxDecoration(color: colorPallete.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;

  final _items = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(icon: Icon(FeatherIcons.messageCircle), label: 'Pesan'),
    const BottomNavigationBarItem(icon: Icon(FeatherIcons.airplay), label: 'Story'),
    const BottomNavigationBarItem(icon: Icon(FeatherIcons.user), label: 'Akun'),
  ];

  final _screens = <Widget>[
    InboxScreen(),
    StoryScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          '${appConfig.urlImageAsset}/logo_white.png',
          width: 40.0,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.search),
          )
        ],
      ),
      body: IndexedStack(children: _screens, index: _currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        showUnselectedLabels: false,
        onTap: (value) => setState(() => _currentIndex = value),
      ),
    );
  }
}

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: sizes.width(context) / 3,
                        height: sizes.width(context) / 3,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.asset(
                                  '${appConfig.urlImageAsset}/ob1.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: colorPallete.accentColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const FittedBox(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      FeatherIcons.edit2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Zeffry Reynando',
                    style: Constant.maitree.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                  Text(
                    'Dibuat pada 1 Januari 2020 | 6 Bulan',
                    style: Constant.maitree.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 10.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(14.0),
                    margin: const EdgeInsets.only(bottom: 14.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: colorPallete.accentColor!.withOpacity(.25),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Icon(
                              FeatherIcons.smile,
                              color: colorPallete.accentColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            'Tentang Developer',
                            style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.1),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Icon(
                            Icons.chevron_right,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CopyRightVersion(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: colorPallete.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InboxScreen extends StatelessWidget {
  const InboxScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.archive_outlined),
                  Expanded(
                    child: Center(
                      child: Text(
                        '1 Pesan diarsipkan',
                        style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 100,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, MessageDetailScreen.routeNamed);
                      },
                      splashColor: colorPallete.primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2.0,
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 80.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2.0,
                                      color: Colors.black.withOpacity(.25),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      '${appConfig.urlImageAsset}/ob3.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Zeffry Reynando',
                                          style: Constant.comfortaa.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              CircleAvatar(
                                                radius: sizes.width(context) * 0.015,
                                                backgroundColor: const Color(0xFfC4C4C4),
                                              ),
                                              const SizedBox(width: 5.0),
                                              Text(
                                                '20.20',
                                                style: Constant.maitree.copyWith(
                                                  fontSize: 8.0,
                                                  color: const Color(0xFFC4C4C4),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Lagi dimana lu bro? udah ditungguin sama anak-anak yang lain nih...',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constant.comfortaa.copyWith(
                                        fontSize: 8.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        color: colorPallete.accentColor,
                                      ),
                                      child: Text.rich(
                                        TextSpan(
                                          style: Constant.comfortaa
                                              .copyWith(fontSize: 8.0, color: Colors.white),
                                          children: [
                                            TextSpan(
                                              text: '1',
                                              style: Constant.comfortaa.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const TextSpan(text: ' Pesan belum dibaca')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MessageDetailScreen extends StatelessWidget {
  static const routeNamed = '/message-detail-screen';
  const MessageDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FeatherIcons.chevronLeft),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              '${appConfig.urlImageAsset}/ob1.png',
              width: 30,
              height: 30.0,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Zeffry Reynando',
                  style: Constant.maitree.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online 1 jam yang lalu',
                  style: Constant.maitree.copyWith(
                    fontSize: 8.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.moreVertical),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ListView.builder(
                    itemCount: 10,
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    itemBuilder: (context, index) {
                      final isEven = index.floor().isEven;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        child: Align(
                          alignment: isEven ? Alignment.centerLeft : Alignment.centerRight,
                          child: Card(
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            color: isEven ? Colors.white : colorPallete.primaryColor,
                            margin: EdgeInsets.only(
                              left: isEven ? 0.0 : sizes.width(context) / 4,
                              right: isEven ? sizes.width(context) / 4 : 0.0,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "asdjksajd sajjd jsajsa jdksa jdkjsad jas dasdaskjda asdjksajd sajjd jsajsa jdksa jdkjsad jas dasdaskjda asdjksajd sajjd jsajsa jdksa jdkjsad jas dasdaskjda ",
                                    style: Constant.comfortaa.copyWith(
                                      color: isEven ? Colors.black.withOpacity(.5) : Colors.white,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (isEven) ...[
                                        Text(
                                          '20.00',
                                          style: Constant.comfortaa
                                              .copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        Icon(FeatherIcons.smile),
                                      ] else ...[
                                        Icon(FeatherIcons.smile, color: Colors.white),
                                        Text(
                                          '20.00',
                                          style: Constant.comfortaa.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                ///TODO: Lakukan sesuatu saat ada yang mengetik
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: colorPallete.accentColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'Pacarmu sedang mengetik...',
                        textAlign: TextAlign.center,
                        style: Constant.comfortaa.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: sizes.height(context) / 8,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  color: Colors.black.withOpacity(.25),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormFieldCustom(
                    hintText: 'Tulis Pesan...',
                    disableOutlineBorder: false,
                    radius: 60.0,
                    borderFocusColor: colorPallete.accentColor,
                    activeColor: colorPallete.accentColor,
                    borderColor: Colors.black.withOpacity(.25),
                    textStyle: Constant.comfortaa.copyWith(fontSize: 12.0),
                    padding: const EdgeInsets.all(18.0),
                    hintStyle: Constant.comfortaa.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 10.0,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: sizes.width(context) / 8,
                  width: sizes.width(context) / 8,
                  decoration: BoxDecoration(
                    color: colorPallete.accentColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Icon(
                    FeatherIcons.send,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
