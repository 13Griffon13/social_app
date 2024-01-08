import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:crop/crop.dart';
import 'package:flutter/material.dart';
import 'package:social_app/core/view/widgets/general_button.dart';

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
  final CropController controller =CropController(aspectRatio: 1);
  late final File imageFile;
  late final String outputPath;

  @override
  void initState() {
    super.initState();
    imageFile = File(widget.imagePath);
    outputPath = widget.imagePath.replaceAll('.jpg', '.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Crop(
            child: Image(
              image: FileImage(imageFile),
            ),
            controller: controller,
            shape: BoxShape.circle,
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: GeneralButton(
                onPress: () async{
                  final cropped = await controller.crop();
                  final data =  await cropped!.toByteData(format: ImageByteFormat.png);
                  final buffer = data!.buffer.asUint8List();
                  File(outputPath).writeAsBytesSync(buffer,mode: FileMode.writeOnly);
                  context.popRoute(outputPath);
                },
                child: Text(
                  'Accept'
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}
