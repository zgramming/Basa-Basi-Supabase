import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import './widgets/onboarding_page_item.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeNamed = '/onboarding-screen';
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
              padding: EdgeInsets.only(
                bottom: sizes.height(context) / 10,
                left: 24.0,
                right: 24.0,
              ),
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
                      },
                    ),
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) => OutlinedButton(
                        onPressed: () async {
                          if (_selectedIndex == (_pages.length - 1)) {
                            await ref
                                .read(SessionProvider.provider.notifier)
                                .setOnboardingSession(value: true);
                            if (mounted) {
                              Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
                            }
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
