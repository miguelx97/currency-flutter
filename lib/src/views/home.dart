import 'package:currency_converter/src/models/button_calc.dart';
import 'package:currency_converter/src/models/calculator.dart';
import 'package:currency_converter/src/models/conversor.dart';
import 'package:currency_converter/src/widgets/button_calc.widget.dart';
import 'package:currency_converter/src/widgets/field_formula.widget.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Calculator calculator = Calculator();
  List<ButtonCalc> buttons = getButtons();
  int selectedField = 1;
  Conversor conversor = Conversor(
    conversionRate: 0.025,
  );

  updateFormula(ButtonCalc btn) {
    HapticFeedback.lightImpact();
    setState(() => calculator.add(btn));
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFE7ECEF);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    FieldFormulaWidget(
                      value: selectedField == 1 ? calculator.formulaToString() : conversor.reverseConvert(calculator),
                      currency: 'EUR',
                      selected: selectedField == 1,
                      bgColor: bgColor,
                      onTap: () => setState(() {
                        if(selectedField == 1) return;
                        final String value = conversor.reverseConvert(calculator);
                        calculator.formula.clear();
                        calculator.add(ButtonCalc(value: value, type: ButtonCalcType.number));
                        selectedField = 1;
                      }),
                    ),
                    FieldFormulaWidget(
                      value: selectedField == 2 ? calculator.formulaToString() : conversor.convert(calculator),
                      currency: 'BAHT',
                      selected: selectedField == 2,
                      bgColor: bgColor,
                      onTap: () => setState(() {
                        if(selectedField == 2) return;
                        final String value = conversor.convert(calculator);
                        calculator.formula.clear();
                        calculator.add(ButtonCalc(value: value, type: ButtonCalcType.number));
                        selectedField = 2;
                      }),
                    ),
                  ],
                ),
                SizedBox(
                  child: GridView.count(
                    shrinkWrap: true,
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 4,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(buttons.length, (index) {
                      return ButtonCalcWidget(
                        bgColor: bgColor,
                        btn: buttons[index],
                        func: updateFormula,
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
