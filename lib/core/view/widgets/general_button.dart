import 'package:flutter/material.dart';
import 'package:social_app/core/colors_pallete.dart';
import 'package:social_app/core/domain/button_state.dart';

class GeneralButton extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Function() onPress;
  final ButtonState buttonState;

  const GeneralButton({
    super.key,
    this.width = 280.0,
    this.height = 64.0,
    this.padding = const EdgeInsets.all(8.0),
    required this.child,
    required this.onPress,
    this.buttonState = ButtonState.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsPalette.purpleMain,
          foregroundColor: ColorsPalette.baseWhite,
        ),
        onPressed: buttonState == ButtonState.active ? onPress : null,
        child: buttonState == ButtonState.loading
            ? CircularProgressIndicator()
            : child,
      ),
    );
  }
}
