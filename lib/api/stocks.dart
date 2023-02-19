import 'dart:convert';
import 'package:basalt/uitils/service_call_methods.dart';
import 'package:flutter/material.dart';

Future<dynamic> getStocks({
  required BuildContext context,
  String? dateFrom,
  String? dateTo,
}) async {
  String? params;

  if (dateFrom != null && dateTo != null) {
    params = 'date_from=$dateFrom&date_to=$dateTo';
  }

  try {
    dynamic response = await httpGet(
      context: context,
      params: params ?? 'latest',
    );
    Map<String, dynamic> decodedResponse = jsonDecode(response);

    return decodedResponse;
  } catch (e) {
    String message = "Local Error:\n$e'";
    print(message);
  }
}
