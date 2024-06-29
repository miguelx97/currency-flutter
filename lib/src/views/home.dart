import 'package:currency_converter/src/models/button_calc.dart';
import 'package:currency_converter/src/models/calculator.dart';
import 'package:currency_converter/src/widgets/button_neu.dart';
import 'package:flutter/material.dart';
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

  updateFormula(ButtonCalc btn) {
    HapticFeedback.lightImpact();
    setState(() => calculator.add(btn));
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFE7ECEF);
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  calculator.formulaToString(),
                  style: TextStyle(fontSize: 40),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(
                height: 600,
                child: GridView.count(
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 4,
                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(buttons.length, (index) {
                    return ButtonNeu(
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
    );
  }
}
