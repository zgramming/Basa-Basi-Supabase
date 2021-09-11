import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:image_picker/image_picker.dart';

import '../../../provider/provider.dart';

class SetupProfileImage extends ConsumerStatefulWidget {
  final void Function(File file) onPickImage;

  const SetupProfileImage({
    required this.onPickImage,
  });

  @override
  _SetupProfileImageState createState() => _SetupProfileImageState();
}

class _SetupProfileImageState extends ConsumerState<SetupProfileImage> {
  final _imagePicker = ImagePicker();

  File? _pickedImage;

  Future<File?> pickImage(ImageSource source) async {
    final result = await _imagePicker.pickImage(
      source: source,
      maxHeight: 400,
      maxWidth: 400,
      preferredCameraDevice: CameraDevice.front,
    );
    if (result == null) {
      return null;
    }
    return File(result.path);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(SessionProvider.provider).session.user;
    log('setupprofile ${user?.pictureProfile}');
    return Center(
      child: InkWell(
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) {
              return ActionModalBottomSheet(
                typeAction: TypeAction.none,
                align: WrapAlignment.center,
                children: [
                  ActionCircleButton(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: FeatherIcons.camera,
                    onTap: () async {
                      final file = await pickImage(ImageSource.camera);
                      if (file != null) {
                        widget.onPickImage(file);
                        _pickedImage = file;
                      }
                    },
                  ),
                  ActionCircleButton(
                    backgroundColor: colorPallete.accentColor,
                    foregroundColor: Colors.white,
                    icon: FeatherIcons.image,
                    onTap: () async {
                      final file = await pickImage(ImageSource.gallery);
                      if (file != null) {
                        widget.onPickImage(file);
                        _pickedImage = file;
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Ink(
          width: sizes.width(context) / 2,
          height: sizes.width(context) / 2,
          decoration: BoxDecoration(
            color: colorPallete.accentColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                color: Colors.black.withOpacity(.25),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (user?.pictureProfile == null)
                Positioned.fill(
                  child: SizedBox(
                    child: _pickedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.file(
                              _pickedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                FeatherIcons.image,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(FeatherIcons.edit2, color: colorPallete.accentColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
