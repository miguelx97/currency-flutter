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
  Conversor conversor = Conversor();

  updateFormula(ButtonCalc btn) {
    HapticFeedback.lightImpact();
    setState(() {
      calculator.add(btn, onButtonAdded: () => conversor.convert(calculator, reverse: selectedField == 1));
    });
  }

  @override
  void initState() {
    super.initState();
    conversor.selectCurrency('EUR', 'THB');
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
                      value: selectedField == 1
                          ? calculator.formulaToString()
                          : conversor.value2.toString(),
                      currency: 'EUR',
                      selected: selectedField == 1,
                      bgColor: bgColor,
                      onTap: () {
                        if (selectedField == 1) return;
                        setState(() {
                          selectedField = 1;
                        });

                        calculator.formula.clear();

                        if (conversor.value2 != null && conversor.value2 != 0) {
                          calculator.add(ButtonCalc(
                              value: conversor.value2.toString(),
                              type: ButtonCalcType.number));
                        }
                      },
                    ),
                    FieldFormulaWidget(
                      value: selectedField == 2
                          ? calculator.formulaToString()
                          : conversor.value1.toString(),
                      currency: 'BAHT',
                      selected: selectedField == 2,
                      bgColor: bgColor,
                      onTap: () {
                        if (selectedField == 2) return;
                        setState(() {
                          selectedField = 2;
                        });

                        calculator.formula.clear();
                        if (conversor.value1 != null && conversor.value1 != 0) {
                          calculator.add(ButtonCalc(
                              value: conversor.value1.toString(),
                              type: ButtonCalcType.number));
                        }
                      },
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
