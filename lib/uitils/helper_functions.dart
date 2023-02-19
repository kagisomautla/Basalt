import 'dart:io';
import 'package:intl/intl.dart';

Future<bool> isOnline() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (e) {
    print(e.message);
  }
  return false;
}

formatDate({required String? date, bool? dateInWords}) {
  if (date == null) {
    return;
  }
  DateTime now = DateTime.parse(date);
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);

  String formattedDateInWords = DateFormat.yMMMEd().format(now);

  if (dateInWords != null) {
    return formattedDateInWords;
  }

  return formattedDate;
}
