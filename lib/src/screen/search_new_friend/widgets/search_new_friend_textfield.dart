import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class SearchNewFriendTextField extends StatefulWidget {
  const SearchNewFriendTextField({
    Key? key,
  }) : super(key: key);
  @override
  State<SearchNewFriendTextField> createState() => _SearchNewFriendTextFieldState();
}

class _SearchNewFriendTextFieldState extends State<SearchNewFriendTextField> {
  final _formKey = GlobalKey<FormState>();

  final debounce = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 2.0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Consumer(
        builder: (context, ref, child) => Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormFieldCustom(
            prefixIcon: const Icon(FeatherIcons.search),
            disableOutlineBorder: false,
            hintText: 'Cari berdasarkan username atau email',
            hintStyle: Constant.comfortaa.copyWith(
              color: Colors.black.withOpacity(.5),
              fontSize: 12.0,
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              debounce.run(() {
                if (value.length >= 3) {
                  ref.read(querySearch).state = value;
                } else {
                  ref.read(querySearch).state = null;
                }
              });
            },
            validator: (value) {
              final length = value?.length ?? 0;
              if (length < 3) {
                return 'Inputan minimal 3 karakter';
              }
              return null;
            },
            onFieldSubmitted: (value) => log('onsubmit $value'),
          ),
        ),
      ),
    );
  }
}
