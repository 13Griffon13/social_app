import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/core/view/widgets/general_button.dart';
import 'package:social_app/locales/strings.dart';
import 'package:cropperx/cropperx.dart';

@RoutePage<String>()
class CropperScreen extends StatefulWidget {
  final String imagePath;

  const CropperScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<CropperScreen> createState() => _CropperScreenState();
}

class _CropperScreenState extends State<CropperScreen> {
  final GlobalKey _cropperKey = GlobalKey();
  late final File imageFile;
  late final String outputPath;

  @override
  void initState() {
    super.initState();
    imageFile = File(widget.imagePath);
    final fileName = widget.imagePath.split('/').last;
    final outputName = '_$fileName'.replaceAll('.jpg', '.png');
    outputPath = widget.imagePath.replaceAll(fileName, outputName);
    print(widget.imagePath);
    print(outputPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Cropper(
            cropperKey: _cropperKey,
            image: Image(
              image: FileImage(imageFile),
            ),

            overlayType: OverlayType.circle,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: GeneralButton(
                onPress: () async {
                  final croppedData =
                      await Cropper.crop(cropperKey: _cropperKey);
                  if (croppedData != null) {
                    File(outputPath).writeAsBytesSync(
                      croppedData,
                      mode: FileMode.writeOnly,
                    );
                  }
                  context.popRoute(outputPath);
                },
                child: Text(
                  Strings.accept,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
