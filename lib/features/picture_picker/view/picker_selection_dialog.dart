import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/locales/strings.dart';
import 'package:social_app/navigation/app_router.dart';

class PickerSelector extends StatelessWidget {
  final Function(String imagePath) onPhotoSelected;
  final ImagePicker _picker = ImagePicker();

  PickerSelector({
    super.key,
    required this.onPhotoSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            final image = await _picker.pickImage(source: ImageSource.camera);
            if (image != null) {
              final cropResult = await context
                  .pushRoute<String?>(CropperRoute(imagePath: image.path));
              if (cropResult != null) {
                onPhotoSelected(cropResult);
              }
              context.popRoute();
            }
          },
          child: Text(Strings.takePhoto),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            final image = await _picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              final cropResult = await context
                  .pushRoute<String?>(CropperRoute(imagePath: image.path));
              if (cropResult != null) {
                onPhotoSelected(cropResult);
              }
              context.popRoute();
            }
          },
          child: Text(Strings.gallery),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          context.popRoute();
        },
        child: Text(Strings.cancel),
      ),
    );
  }
}
