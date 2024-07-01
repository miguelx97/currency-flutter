String roundNumberStr(double d) =>
    // toStringAsFixed guarantees the specified number of fractional
    // digits, so the regular expression is simpler than it would need to
    // be for more general cases.
    d.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0*$'), '');

double roundNumber(double d) => double.parse(roundNumberStr(d));