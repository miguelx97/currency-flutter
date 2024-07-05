import 'package:currency_converter/src/models/currency.dart';
import 'package:flutter/material.dart';

class CurrencyItem extends StatelessWidget {
  final Currency currency;
  final Function(Currency) onFavorite;
  final Function(Currency) onTap;
  const CurrencyItem({super.key, required this.currency, required this.onFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(currency.name),
      leading: Text(
        currency.flag,
        style: const TextStyle(
          fontFamily: 'NotoEmoji',
          fontSize: 20,
        ),
      ),
      trailing: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => onFavorite(currency),
        child: Icon(
          currency.isFavorite ? Icons.star : Icons.star_border,
          color: currency.isFavorite ? Colors.amber : Colors.grey,
        ),
      ),
      onTap: () => onTap(currency),

    );
  }
}
