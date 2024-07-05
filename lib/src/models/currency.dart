import 'package:currency_converter/src/services/lib/services/local_storage.service.dart';

class Currency extends LsParser<Currency> {
    String name;
    String iso;
    String symbol;
    String territory;
    String flag;
    String position;
    bool isFavorite;

    Currency({
        this.name = '',
        this.iso = '',
        this.symbol = '',
        this.territory = '',
        this.flag = '',
        this.position = '',
        this.isFavorite = false,
    });
    
      @override
      Currency fromMap(Map<String, dynamic> map) => Currency(
        name: map["name"],
        iso: map["iso"],
        symbol: map["symbol"],
        territory: map["territory"],
        flag: map["flag"],
        position: map["position"],
    );
    
      @override
      Map<String, dynamic> toMap() => {
        "name": name,
        "iso": iso,
        "symbol": symbol,
        "territory": territory,
        "flag": flag,
        "position": position,
    };
}
