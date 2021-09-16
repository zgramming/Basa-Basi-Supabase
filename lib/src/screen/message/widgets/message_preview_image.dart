import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './message_appbar_title.dart';
import '../../../network/model/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessagePreviewImage extends ConsumerStatefulWidget {
  static const routeNamed = '/message-preview-image';
  final String fileUrl;
  const MessagePreviewImage({
    Key? key,
    required this.fileUrl,
  }) : super(key: key);

  @override
  _MessagePreviewImageState createState() => _MessagePreviewImageState();
}

class _MessagePreviewImageState extends ConsumerState<MessagePreviewImage> {
  final _messageController = TextEditingController();
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<StateController<bool>>(isLoading, (loading) {
      if (loading.state) {
        GlobalFunction.showDialogLoading(context);
      } else {
        Navigator.pop(context);
      }
    });
    return WillPopScope(
      onWillPop: () async => Future.value(true),
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                panEnabled: false,
                minScale: 0.5,
                maxScale: 2,
                child: Image.file(
                  File(widget.fileUrl),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: Colors.black.withOpacity(.5),
                elevation: 0,
                title: const MessageAppbarTitle(),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: KeyboardVisibilityBuilder(
                builder: (context, child, isKeyboardVisible) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 0.0,
                      left: 24.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormFieldCustom(
                            controller: _messageController,
                            disableOutlineBorder: false,
                            padding: const EdgeInsets.all(20.0),
                            hintText: 'Tulis Pesan...',
                            radius: 10.0,
                            activeColor: colorPallete.accentColor,
                            focusedBorderStyle: InputBorderStyle(color: colorPallete.accentColor),
                            defaultBorderStyle:
                                InputBorderStyle(color: Colors.black.withOpacity(.25)),
                            textStyle: Constant.comfortaa.copyWith(fontSize: 14.0),
                            hintStyle: Constant.comfortaa.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () async {
                            try {
                              ref.read(isLoading).state = true;
                              // await Future.delayed(const Duration(seconds: 3));
                              final urlImage = await SupabaseQuery.instance.uploadFileToSupabase(
                                file: File(widget.fileUrl),
                                storageName: Constant.imageChatBucket,
                              );

                              final messageContent = _messageController.text;
                              await ref.read(MessageProvider.provider.notifier).sendMessage(
                                    messageContent: messageContent,
                                    status: MessageStatus.send,
                                    type: messageContent.isEmpty
                                        ? MessageType.image
                                        : MessageType.imageWithText,
                                    messageFileUrl: urlImage,
                                  );

                              if (mounted) {
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              GlobalFunction.showSnackBar(
                                context,
                                content: Text(e.toString()),
                                snackBarType: SnackBarType.error,
                              );
                            } finally {
                              ref.read(isLoading).state = false;
                            }
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: colorPallete.accentColor,
                            foregroundColor: Colors.white,
                            child: const Icon(FeatherIcons.send),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
