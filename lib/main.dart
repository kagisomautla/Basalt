import 'package:basalt/screens/market_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'state_management/market_report.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env").then((_) => runApp(const MarketApplication()));
}

class MarketApplication extends StatefulWidget {
  const MarketApplication({super.key});

  @override
  State<MarketApplication> createState() => _MarketApplicationState();
}

class _MarketApplicationState extends State<MarketApplication> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MarketReportProvider>(create: (_) => MarketReportProvider()),
      ],
      child: MaterialApp(
        builder: (context, child) {
          final scale = MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.0);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
            child: child!,
          );
        },
        routes: <String, WidgetBuilder>{
          "/": (BuildContext context) => MarketReportScreen(),
        },
      ),
    );
  }
}
