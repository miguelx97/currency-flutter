import 'package:currency_converter/src/models/button_calc.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class ButtonNeu extends StatefulWidget {
  final ButtonCalc btn;
  final Color bgColor;
  final Function(ButtonCalc btn) func;
  const ButtonNeu({super.key, required this.bgColor, required this.btn, required this.func});

  @override
  State<ButtonNeu> createState() => _ButtonNeuState();
}

class _ButtonNeuState extends State<ButtonNeu> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    Offset shadowDistance = isPressed ? const Offset(1, 1) : const Offset(2, 2);
    double blur = isPressed ? 2.0 : 4.0;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Listener(
        onPointerUp: (_) {
          widget.func(widget.btn);
          setState(() => isPressed = false);
        },
        onPointerDown: (_) => setState(() => isPressed = true),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: widget.bgColor,
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
              style: TextStyle(fontSize: 32),
            ),
          ),
        ),
      ),
    );
  }
}
