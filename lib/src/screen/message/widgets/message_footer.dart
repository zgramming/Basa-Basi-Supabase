import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:image_picker/image_picker.dart';

import './message_preview_image.dart';

import '../../../network/model/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessageFooter extends ConsumerStatefulWidget {
  final TextEditingController messageController;
  const MessageFooter({
    required this.messageController,
  });

  @override
  _MessageFooterState createState() => _MessageFooterState();
}

class _MessageFooterState extends ConsumerState<MessageFooter> {
  final debounce = Debouncer(milliseconds: 500);
  bool _showButtonImage = true;
  int _flagShowButtonImage = 0;
  @override
  void dispose() {
    super.dispose();
    debounce.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormFieldCustom(
                controller: widget.messageController,
                hintText: 'Tulis Pesan...',
                disableOutlineBorder: false,
                radius: 10.0,
                activeColor: colorPallete.accentColor,
                focusedBorderStyle: InputBorderStyle(color: colorPallete.accentColor),
                defaultBorderStyle: InputBorderStyle(color: Colors.black.withOpacity(.25)),
                textStyle: Constant.comfortaa.copyWith(fontSize: 14.0),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 5,
                padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  bottom: 20.0,
                  right: 40.0,
                ),
                hintStyle: Constant.comfortaa.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 10.0,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (_flagShowButtonImage == 0) {
                      setState(() {});
                    }
                    _showButtonImage = false;
                    _flagShowButtonImage = 1;

                    debounce.run(() async {
                      if (mounted) {
                        try {
                          await ref.read(MessageProvider.provider.notifier).updateTyping();
                        } catch (e) {
                          log('error when realtime typing ${e.toString()}');
                        }
                      }
                    });
                  }
                  if (value.isEmpty) {
                    _showButtonImage = true;
                    _flagShowButtonImage = 0;
                    setState(() {});
                  }
                  // debounce.run(() {});
                },
                suffixIconConfiguration: const SuffixIconConfiguration(
                  rightPosition: 15,
                  bottomPosition: 10,
                ),
                suffixIcon: [
                  if (_showButtonImage)
                    InkWell(
                      onTap: () async {
                        final result = await uploadImage(source: ImageSource.camera);
                        if (result != null) {
                          await Future.delayed(Duration.zero, () {
                            Navigator.pushNamed(
                              context,
                              MessagePreviewImage.routeNamed,
                              arguments: result,
                            );
                          });
                        }
                      },
                      child: const Icon(FeatherIcons.camera),
                    ),
                  InkWell(
                    onTap: () async {
                      await showModalBottomSheet(
                        context: context,
                        builder: (context) => ActionModalBottomSheet(
                          typeAction: TypeAction.none,
                          align: WrapAlignment.center,
                          children: [
                            ActionCircleButton(
                              icon: FeatherIcons.camera,
                              backgroundColor: colorPallete.primaryColor,
                              foregroundColor: Colors.white,
                              onTap: () async {
                                final result = await uploadImage(source: ImageSource.camera);
                                if (result != null) {
                                  await Future.delayed(Duration.zero, () {
                                    Navigator.pushNamed(
                                      context,
                                      MessagePreviewImage.routeNamed,
                                      arguments: result,
                                    );
                                  });
                                }
                              },
                            ),
                            ActionCircleButton(
                              icon: FeatherIcons.image,
                              backgroundColor: colorPallete.success,
                              foregroundColor: Colors.white,
                              onTap: () async {
                                final result = await uploadImage();
                                if (result != null) {
                                  await Future.delayed(Duration.zero, () {
                                    Navigator.pushNamed(
                                      context,
                                      MessagePreviewImage.routeNamed,
                                      arguments: result,
                                    );
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Icon(Icons.attach_file),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Consumer(
              builder: (context, ref, child) => InkWell(
                borderRadius: BorderRadius.circular(15.0),
                splashColor: Colors.black,
                onTap: () async {
                  if (widget.messageController.text.isEmpty) {
                    return;
                  }

                  try {
                    ref.read(isLoading).state = true;

                    final messageContent = widget.messageController.text;

                    /// Reset textfield
                    widget.messageController.clear();

                    await ref.read(MessageProvider.provider.notifier).sendMessage(
                          messageContent: messageContent,
                          status: MessageStatus.send,
                          type: MessageType.text,
                        );

                    setState(() {
                      _showButtonImage = true;
                      _flagShowButtonImage = 0;
                    });
                  } catch (e) {
                    GlobalFunction.showSnackBar(
                      context,
                      content: Text(e.toString()),
                      snackBarType: SnackBarType.error,
                    );
                    log('Error SendMessage Only Text : ${e.toString()}');
                  } finally {
                    ref.read(isLoading).state = false;
                  }
                },
                child: Ink(
                  height: sizes.width(context) / 9,
                  width: sizes.width(context) / 9,
                  decoration: BoxDecoration(
                    color: colorPallete.accentColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Icon(
                    FeatherIcons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
