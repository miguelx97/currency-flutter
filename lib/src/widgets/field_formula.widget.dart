import 'package:currency_converter/src/models/currency.dart';
import 'package:currency_converter/src/shared/colors.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class FieldFormulaWidget extends StatelessWidget {
  const FieldFormulaWidget({
    super.key,
    required this.value,
    required this.currency,
    required this.selected,
    required this.bgColor,
    required this.onTap,
    required this.onCurrencyTap,
  });
  final String value;
  final Currency? currency;
  final bool selected;
  final Color bgColor;
  final Function() onTap;
  final Function() onCurrencyTap;

  void copyValue() {
    Clipboard.setData(ClipboardData(text: value));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: ColorTheme.primary,
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      onLongPress: copyValue,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        width: double.infinity,
        padding: const EdgeInsets.only(right: 16, top: 2, bottom: 2),
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
            : BoxDecoration(
                borderRadius: BorderRadius.circular(20), boxShadow: const []),
        child: Row(
          children: [
            InkWell(
              onTap: onCurrencyTap,
              splashColor: ColorTheme.primary,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: currency != null && !currency!.updating
                    ? Row(
                        children: [
                          Text(
                            currency!.flag,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'NotoEmoji',
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            currency!.iso,
                            style: const TextStyle(
                              fontSize: 20,
                              color: ColorTheme.dark,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      )
                    : const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: value.length < 10,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 40, color: ColorTheme.dark),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
