import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../network/model/network.dart';
import '../../utils/utils.dart';

class AboutDeveloperScreen extends StatelessWidget {
  static const routeNamed = '/about-developer-screen';
  const AboutDeveloperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tentang Developer',
          style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: listSocialMedia.length,
        padding: const EdgeInsets.all(24.0),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final socialMedia = listSocialMedia[index];
          return InkWell(
            onTap: () async {
              try {
                await Shared.instance.openUrl(socialMedia.url);
              } catch (e) {
                GlobalFunction.showSnackBar(
                  context,
                  content: Text(e.toString()),
                  snackBarType: SnackBarType.error,
                );
              }
            },
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(blurRadius: 2.0, color: Colors.black.withOpacity(.25)),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: CircleAvatar(
                  backgroundColor: colorPallete.accentColor,
                  child: Icon(
                    socialMedia.logo,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  socialMedia.title,
                  style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(socialMedia.subtitle),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
