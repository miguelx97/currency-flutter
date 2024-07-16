import 'package:currencii/src/models/button_calc.dart';
import 'package:currencii/src/models/calculator2.dart';
import 'package:currencii/src/models/conversor.dart';
import 'package:currencii/src/models/currency.dart';
import 'package:currencii/src/screens/currency_picker.widget.dart';
import 'package:currencii/src/services/currencies.service.dart';
import 'package:currencii/src/shared/utils.dart';
import 'package:currencii/src/widgets/button_calc.widget.dart';
import 'package:currencii/src/widgets/field_formula.widget.dart';
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
  int selectedField = 1;
  Conversor conversor = Conversor();

  onButtonAdded() {
    conversor.convert(calculator, reverse: selectedField == 1);
    //print('v1 ${conversor.value1} - v2 ${conversor.value2}');
  }

  updateFormula(ButtonCalc btn) {
    HapticFeedback.lightImpact();
    setState(() {
      calculator.add(btn,
          onButtonAdded: onButtonAdded);
    });
  }

  selectCurrency(int filed) async {
    Currency? currency = await showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const CurrencyPickerSheet();
      },
    );
    if (currency == null) return;

    if (filed == 1) {
      conversor.fromCurrency!.updating = true;
      setState(() {});
      await conversor.updateFromCurrency(currency);
    } else {
      conversor.toCurrency!.updating = true;
      setState(() {});
      await conversor.updateToCurrency(currency);
    }
    conversor.fromCurrency!.updating = false;
    conversor.toCurrency!.updating = false;
    conversor.convert(calculator, reverse: selectedField == 1);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialCurrencies();
  }

  Future<void> initialCurrencies() async {
    Conversor? savedConversorData = await CurrenciesService().getConversorData();
    if (savedConversorData != null) {
      await conversor.setCurrency(savedConversorData);
    } else {
      await conversor.setDefaultCurrencyValues();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Theme.of(context).colorScheme.background;
    final List<ButtonCalc> buttons = getButtons(context);
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
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
                          ? calculator.formatedExpression
                          : format(conversor.value2),
                      currency: conversor.fromCurrency,
                      selected: selectedField == 1,
                      bgColor: bgColor,
                      onTap: () {
                        if (selectedField == 1) return;
                        selectedField = 1;

                        if (conversor.value2 != null && conversor.value2 != 0) {
                          calculator.setValue(conversor.value2);
                        }

                        setState(() {});
                      },
                      onCurrencyTap: () => selectCurrency(1),
                    ),
                    FieldFormulaWidget(
                      value: selectedField == 2
                          ? calculator.formatedExpression
                          : format(conversor.value1),
                      currency: conversor.toCurrency,
                      selected: selectedField == 2,
                      bgColor: bgColor,
                      onTap: () {
                        if (selectedField == 2) return;
                        selectedField = 2;

                        if (conversor.value1 != null && conversor.value1 != 0) {
                          calculator.setValue(conversor.value1);
                        }

                        setState(() {});
                      },
                      onCurrencyTap: ()=> selectCurrency(2),
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
