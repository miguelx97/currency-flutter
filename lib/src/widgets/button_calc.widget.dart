import 'package:currency_converter/src/models/button_calc.dart';
import 'package:currency_converter/src/shared/colors.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class ButtonCalcWidget extends StatefulWidget {
  final ButtonCalc btn;
  final Color bgColor;
  final Function(ButtonCalc btn) func;
  const ButtonCalcWidget({super.key, required this.bgColor, required this.btn, required this.func});

  @override
  State<ButtonCalcWidget> createState() => _ButtonCalcWidgetState();
}

class _ButtonCalcWidgetState extends State<ButtonCalcWidget> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    Offset shadowDistance = isPressed ? const Offset(1, 1) : const Offset(2, 2);
    double blur = isPressed ? 2.0 : 4.0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Listener(
        onPointerUp: (_) {
          widget.func(widget.btn);
          setState(() => isPressed = false);
        },
        onPointerDown: (_) => setState(() => isPressed = true),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: widget.btn.bgColor ?? widget.bgColor,
              boxShadow: [
                BoxShadow(
                  offset: -shadowDistance,
                  color: Colors.white,
                  blurRadius: blur,
                  inset: isPressed,
                ),
                BoxShadow(
                  offset: shadowDistance,
                  color: Colors.black38,
                  blurRadius: blur,
                  inset: isPressed,
                )
              ]),
          child: Center(
            child: Text(
              widget.btn.value,
              style: TextStyle(fontSize: 32, color: widget.btn.bgColor == null ? ColorTheme.dark : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
