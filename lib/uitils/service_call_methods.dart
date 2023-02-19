import 'dart:convert';
import 'dart:io';

import 'package:basalt/controls/snackbar.dart';
import 'package:basalt/uitils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as Http;

dynamic httpGet({
  required BuildContext context,
  String apiUrl = "API_URL",
  String apiKey = "API_KEY",
  required String params,
}) async {
  bool online = await isOnline();
  if (online) {
    final Uri url = Uri.parse("${dotenv.env[apiUrl]}/eod?access_key=${dotenv.env[apiKey]}&symbols=AAPL&$params");

    final response = await Http.get(
      url,
      headers: {
        "content-type": "application/json",
      },
    );

    return jsonEncode({
      'status': response.statusCode,
      'body': response.body,
    });
  } else {
    // ignore: use_build_context_synchronously
    snackBarControl(context: context, message: 'You are currently offline. Please connect to the internet and try again.');
    return _notOnlineMessage();
  }
}

String _notOnlineMessage() {
  return '{"success": false, "message": "You are currently offline. Please connect to the internet and try again.", "content": ""}';
}
