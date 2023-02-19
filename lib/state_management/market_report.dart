import 'package:basalt/models/stocks.dart';
import 'package:flutter/foundation.dart';

class MarketReportProvider with ChangeNotifier {
  List<Stocks> _stocks = [];
  List<Stocks> get stocks => _stocks;
  set stocks(List<Stocks> newVal) {
    _stocks = newVal;
    notifyListeners();
  }

  Stocks? _selectedStock;
  Stocks? get selectedStock => _selectedStock;
  set selectedStock(Stocks? newVal) {
    _selectedStock = newVal;
    notifyListeners();
  }
}
