import 'package:basalt/controls/text.dart';
import 'package:basalt/state_management/market_report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MarketReportProvider marketReportProvider = Provider.of<MarketReportProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextControl(
              text: marketReportProvider.selectedStock?.exhange ?? '',
              size: TextProps.large,
              isBold: true,
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.blueAccent,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Detail(name: 'open:', value: marketReportProvider.selectedStock?.open),
              Detail(name: 'close:', value: marketReportProvider.selectedStock?.close),
              Detail(name: 'high:', value: marketReportProvider.selectedStock?.high),
              Detail(name: 'low:', value: marketReportProvider.selectedStock?.low),
              Detail(name: 'volume:', value: marketReportProvider.selectedStock?.volume),
              Detail(name: 'adj high:', value: marketReportProvider.selectedStock?.adjHigh),
              Detail(name: 'adj low:', value: marketReportProvider.selectedStock?.low),
              Detail(name: 'adj volume:', value: marketReportProvider.selectedStock?.adjVolume),
              Detail(name: 'dividend:', value: marketReportProvider.selectedStock?.dividend),
              Detail(name: 'split factor:', value: marketReportProvider.selectedStock?.splitFactor),
            ],
          ),
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  const Detail({
    required this.value,
    required this.name,
  });

  final dynamic value;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextControl(
              text: name,
              color: Colors.white,
              isBold: true,
            ),
            SizedBox(
              width: 5,
            ),
            TextControl(
              text: value,
              color: Colors.amberAccent,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
