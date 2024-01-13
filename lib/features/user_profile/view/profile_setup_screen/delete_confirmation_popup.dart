import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/locales/strings.dart';

class DeleteConfirmationPopUp extends StatelessWidget {
  final Function() onAccept;

  const DeleteConfirmationPopUp({
    super.key,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Strings.warning),
      content: Text(Strings.deleteAccountExplanation),
      actions: [
        TextButton(
          onPressed: () {
            onAccept();
            context.popRoute();
          },
          child: Text(Strings.confirm),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
        ),
        TextButton(
          onPressed: () {
            context.popRoute();
          },
          child: Text(Strings.cancel),
        ),
      ],
    );
  }
}
