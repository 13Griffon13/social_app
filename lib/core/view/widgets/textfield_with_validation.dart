import 'package:flutter/material.dart';

class TextFieldWithValidation extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? errorText;
  final String? hint;
  final Widget? trailingWidget;

  const TextFieldWithValidation({
    super.key,
    this.padding = const EdgeInsets.all(8.0),
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.errorText,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
          hintText: hint,
          errorText: errorText,
          errorMaxLines: 2,
          suffix: trailingWidget,
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        expands: false,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        maxLines: 1,

      ),
    );
  }
}
