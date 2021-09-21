import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SocialMedia extends Equatable {
  final String title;
  final String url;
  final IconData logo;
  final String subtitle;

  const SocialMedia({
    this.title = '',
    this.url = '',
    this.logo = Icons.home,
    this.subtitle = '',
  });

  @override
  List<Object> get props => [title, url, logo, subtitle];

  @override
  bool get stringify => true;

  SocialMedia copyWith({
    String? title,
    String? url,
    IconData? logo,
    String? subtitle,
  }) {
    return SocialMedia(
      title: title ?? this.title,
      url: url ?? this.url,
      logo: logo ?? this.logo,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}

const listSocialMedia = [
  SocialMedia(
    title: 'Github',
    subtitle: 'Kumpulan project open-source dan portfolio',
    logo: FeatherIcons.github,
    url: 'https://github.com/zgramming',
  ),
  SocialMedia(
    title: 'LinkedIn',
    subtitle: 'Mari berkoneksi denganku disini',
    logo: FeatherIcons.linkedin,
    url: 'https://www.linkedin.com/in/zeffry-reynando/',
  ),
  SocialMedia(
    title: 'Email',
    subtitle: 'Membutuhkan saya untuk sesuatu ? bisa kirimkan melalu email saya',
    logo: FeatherIcons.mail,
    url: 'mailto:zeffry.reynando@gmail.com?subject=Hallo%20Zeffry&body=Kumaha%20Damang?',
  ),
  SocialMedia(
    title: 'Zeffry.dev',
    subtitle: 'Website resmiku...',
    logo: FeatherIcons.globe,
    url: 'https://zeffry.dev',
  ),
];
