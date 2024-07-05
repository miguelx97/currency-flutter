import 'package:currency_converter/src/models/currency.dart';
import 'package:currency_converter/src/services/currencies.service.dart';
import 'package:currency_converter/src/widgets/currency_item.widget.dart';
import 'package:flutter/material.dart';

class CurrencyPickerSheet extends StatefulWidget {
  const CurrencyPickerSheet({super.key});

  @override
  State<CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<CurrencyPickerSheet> {
  List<Currency> allCurrencies = [];
  List<Currency> currencies = [];

  @override
  void initState() {
    super.initState();
    loadCurrencies();
  }

  loadCurrencies() async {
    List<Currency> initialCurrencies =
        await CurrenciesService().getCurrencies();
    List<String> favoriteCurrenciesIso =
        await CurrenciesService().getFavoriteCurrencies();
    List<Currency> favoriteCurrencies = [];
    for (String iso in favoriteCurrenciesIso) {
      Currency currency =
          initialCurrencies.firstWhere((currency) => currency.iso == iso);
      initialCurrencies.remove(currency);
      currency.isFavorite = true;
      favoriteCurrencies.add(currency);
    }
    setState(() {
      allCurrencies = [...favoriteCurrencies, ...initialCurrencies];
      currencies = [...allCurrencies];
    });
  }

  switchFavorite(Currency currency) {
    currency.isFavorite = !currency.isFavorite;
    if (currency.isFavorite) {
      CurrenciesService().saveFavoriteCurrency(currency);
    } else {
      CurrenciesService().removeFavoriteCurrency(currency);
    }
    setState(() {});
  }

  selectCurrency(Currency currency) {
    Navigator.of(context).pop(currency);
  }

  void searchCurrency(String query) {
    setState(() {
      currencies = allCurrencies
          .where((currency) =>
              currency.name.toLowerCase().contains(query.toLowerCase()) ||
              currency.iso.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      height: screenHeight * .7,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.only(top: 16),
      child: Scaffold(
        body: Column(
          children: [
            //searcher
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: searchCurrency,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return CurrencyItem(
                      currency: currencies[index],
                      onFavorite: switchFavorite,
                      onTap: selectCurrency);
                },
                itemCount: currencies.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
