import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/locales/strings.dart';

class ErrorDialog extends StatelessWidget {
  final Function()? onClose;
  final String title;
  final String? message;

  const ErrorDialog({
    super.key,
    this.onClose,
    required this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: message != null ? Text(message!) : null,
      actions: [
        TextButton(
          onPressed: () {
            context.popRoute();
            onClose?.call();
          },
          child: Text(Strings.ok),
        ),
      ],
    );
  }
}
