import 'package:basalt/api/stocks.dart';
import 'package:basalt/state_management/market_report.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class Stocks {
  String? exhange;
  double? open;
  double? high;
  double? low;
  double? close;
  double? volume;
  double? adjHigh;
  double? adjLow;
  double? adjVolume;
  double? splitFactor;
  double? dividend;
  String? symbol;
  String? date;

  Stocks({
    this.exhange,
    this.open,
    this.adjHigh,
    this.adjLow,
    this.adjVolume,
    this.close,
    this.dividend,
    this.high,
    this.low,
    this.splitFactor,
    this.symbol,
    this.volume,
    this.date,
  });

  factory Stocks.fromJson(Map<String, dynamic> json) {
    return Stocks(
      exhange: json['exchange'].toString(),
      open: json['open'],
      adjHigh: json['adj_high'],
      adjLow: json['adj_low'],
      adjVolume: json['adj_volume'],
      close: json['close'],
      dividend: json['dividend'],
      high: json['high'],
      low: json['low'],
      splitFactor: json['split_factor'],
      symbol: json['symbol'].toString(),
      volume: json['volume'],
      date: json['date'],
    );
  }
}
