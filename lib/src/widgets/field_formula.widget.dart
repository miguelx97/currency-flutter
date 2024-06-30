import 'package:currency_converter/src/shared/colors.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class FieldFormulaWidget extends StatelessWidget {
  const FieldFormulaWidget({
    super.key,
    required this.value,
    required this.currency,
    required this.selected,
    required this.bgColor,
    required this.onTap,
  });
  final String value;
  final String currency;
  final bool selected;
  final Color bgColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: selected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: bgColor,
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(-2, -2),
                    color: Colors.white,
                    blurRadius: 4,
                    inset: true,
                  ),
                  BoxShadow(
                    offset: Offset(2, 2),
                    color: Colors.black38,
                    blurRadius: 4,
                    inset: true,
                  ),
                ],
              )
            : BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: const []),
        child: Row(
          children: [
            Text(
              currency,
              style: TextStyle(fontSize: 20, color: ColorTheme.dark),
              textAlign: TextAlign.right,
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 40, color: ColorTheme.dark),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
