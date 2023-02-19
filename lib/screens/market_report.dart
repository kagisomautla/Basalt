import 'dart:convert';

import 'package:basalt/api/stocks.dart';
import 'package:basalt/controls/snackbar.dart';
import 'package:basalt/controls/text.dart';
import 'package:basalt/models/stocks.dart';
import 'package:basalt/screens/details.dart';
import 'package:basalt/state_management/market_report.dart';
import 'package:basalt/uitils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MarketReportScreen extends StatefulWidget {
  const MarketReportScreen({super.key});

  @override
  State<MarketReportScreen> createState() => _MarketReportScreenState();
}

class _MarketReportScreenState extends State<MarketReportScreen> {
  final DateRangePickerController _controller = DateRangePickerController();
  String? dateFrom;
  String? dateTo;
  bool showCalendar = false;
  bool isSearching = false;
  bool loading = false;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (_controller.selectedRange!.startDate != null && _controller.selectedRange!.endDate != null) {
      setState(() {
        dateFrom = formatDate(date: _controller.selectedRange!.startDate.toString());
        dateTo = formatDate(date: _controller.selectedRange!.endDate.toString());
      });
    }
  }

  void onCalendarSelection(bool value) {
    setState(() {
      showCalendar = !value;
    });
  }

  init({stockParameters}) async {
    MarketReportProvider marketReportProvider = Provider.of<MarketReportProvider>(context, listen: false);
    setState(() {
      loading = true;
    });

    await getStocks(context: context).then((response) {
      if (response['status'] == 200) {
        List<Stocks> stocks = [];
        Map<String, dynamic> body = jsonDecode(response['body']);

        for (var stock in body['data']) {
          stocks.add(Stocks.fromJson(stock));
        }
        marketReportProvider.stocks = stocks;
      } else {
        marketReportProvider.stocks = [];
      }
    });

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MarketReportProvider marketReportProvider = Provider.of<MarketReportProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () async {
          FocusScope.of(context).unfocus();
          await Future.delayed(Duration(milliseconds: 300));
        },
        child: SafeArea(
          child: loading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextControl(
                        text: 'Fetching stock data...',
                        size: TextProps.small,
                        isBold: true,
                      ),
                      SpinKitCircle(
                        color: Colors.lightBlueAccent,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextControl(
                        text: 'End of Day Stocks',
                        isBold: true,
                        color: Colors.grey,
                        size: TextProps.large,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      showCalendar
                          ? SfDateRangePicker(
                              controller: _controller,
                              allowViewNavigation: true,
                              backgroundColor: Colors.white,
                              cancelText: 'Cancel',
                              confirmText: 'Confirm',
                              initialDisplayDate: DateTime.now(),
                              todayHighlightColor: Colors.blue,
                              enablePastDates: true,
                              startRangeSelectionColor: Colors.lightBlueAccent,
                              showTodayButton: true,
                              endRangeSelectionColor: Colors.lightBlueAccent,
                              initialSelectedDate: DateTime.now(),
                              onSelectionChanged: _onSelectionChanged,
                              showNavigationArrow: true,
                              navigationMode: DateRangePickerNavigationMode.scroll,
                              maxDate: DateTime.now(),
                              minDate: DateTime.now().subtract(Duration(days: (365 * 20))),
                              onSubmit: (p0) async {
                                if (dateFrom == null) {
                                  snackBarControl(
                                    context: context,
                                    message: 'Please enter start date',
                                  );
                                }

                                if (dateTo == null) {
                                  snackBarControl(
                                    context: context,
                                    message: 'Please enter end date',
                                  );
                                }

                                if (dateTo != null && dateFrom != null) {
                                  setState(() {
                                    loading = true;
                                  });

                                  await getStocks(context: context).then((response) {
                                    if (response['status'] == 200) {
                                      List<Stocks> stocks = [];
                                      Map<String, dynamic> body = jsonDecode(response['body']);

                                      for (var stock in body['data']) {
                                        stocks.add(Stocks.fromJson(stock));
                                      }
                                      marketReportProvider.stocks = stocks;
                                    } else {
                                      marketReportProvider.stocks = [];
                                    }
                                  });

                                  setState(() {
                                    loading = false;
                                  });
                                  _controller.dispose();
                                  onCalendarSelection(showCalendar);
                                }
                              },
                              showActionButtons: true,
                              rangeSelectionColor: Colors.blueAccent,
                              selectionMode: DateRangePickerSelectionMode.range,
                              onCancel: () => onCalendarSelection(showCalendar),
                              headerStyle: DateRangePickerHeaderStyle(
                                backgroundColor: Colors.blueAccent,
                                textAlign: TextAlign.center,
                                textStyle: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              monthCellStyle: DateRangePickerMonthCellStyle(
                                cellDecoration: BoxDecoration(shape: BoxShape.circle),
                                todayCellDecoration: BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Autocomplete<Stocks>(
                                          optionsBuilder: (TextEditingValue value) {
                                            if (value.text.isEmpty) {
                                              setState(() {
                                                isSearching = false;
                                              });
                                            } else {
                                              setState(() {
                                                isSearching = true;
                                              });
                                            }
                                            if (value.text.isEmpty) {
                                              return List.empty();
                                            }
                                            return marketReportProvider.stocks.where((element) => element.exhange!.toLowerCase().contains(value.text.toLowerCase())).toList();
                                          },
                                          fieldViewBuilder: (BuildContext context, TextEditingController controller, FocusNode node, Function onSubmit) => TextField(
                                            controller: controller,
                                            focusNode: node,
                                            decoration: InputDecoration(hintText: 'Search for Stock...'),
                                            style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          optionsViewBuilder: (BuildContext context, Function onSelect, Iterable<Stocks> dataList) {
                                            return Scaffold(
                                              body: ListView.builder(
                                                itemCount: dataList.length,
                                                itemBuilder: (context, index) {
                                                  Stocks stock = dataList.elementAt(index);
                                                  return InkWell(
                                                    onTap: () {
                                                      onSelect(stock);
                                                      marketReportProvider.selectedStock = stock;
                                                    },
                                                    child: StockView(
                                                      stock: stock,
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          onSelected: (value) {},
                                          displayStringForOption: (Stocks d) => '${d.exhange}',
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => onCalendarSelection(showCalendar),
                                        child: Icon(
                                          Icons.calendar_month,
                                          size: 40,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  isSearching == false
                                      ? marketReportProvider.stocks.isNotEmpty
                                          ? Expanded(
                                              child: ListView.builder(
                                                itemCount: marketReportProvider.stocks.length < 10 ? marketReportProvider.stocks.length : 10,
                                                itemBuilder: (context, index) {
                                                  return StockView(
                                                    stock: marketReportProvider.stocks[index],
                                                  );
                                                },
                                              ),
                                            )
                                          : Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    TextControl(
                                                      text: 'No Data Found',
                                                    ),
                                                    SizedBox(
                                                      height: 50,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          loading = true;
                                                        });

                                                        await getStocks(context: context).then((response) {
                                                          if (response['status'] == 200) {
                                                            List<Stocks> stocks = [];
                                                            Map<String, dynamic> body = jsonDecode(response['body']);

                                                            for (var stock in body['data']) {
                                                              stocks.add(Stocks.fromJson(stock));
                                                            }
                                                            marketReportProvider.stocks = stocks;
                                                          } else {
                                                            marketReportProvider.stocks = [];
                                                          }
                                                        });

                                                        setState(() {
                                                          loading = false;
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.replay,
                                                        color: Colors.lightBlueAccent,
                                                        size: 50,
                                                      ),
                                                    ),
                                                    TextControl(
                                                      text: 'Reload the latest stocks data.',
                                                      color: Colors.grey,
                                                      size: TextProps.small,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                      : Container(),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class StockView extends StatelessWidget {
  final Stocks? stock;
  const StockView({super.key, this.stock});

  @override
  Widget build(BuildContext context) {
    MarketReportProvider marketReportProvider = Provider.of<MarketReportProvider>(context);
    return InkWell(
      onTap: () {
        marketReportProvider.selectedStock = stock;
        Navigator.push(context, MaterialPageRoute(builder: ((context) => DetailsScreen())));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextControl(
                text: stock?.exhange,
                size: TextProps.normal,
                isBold: true,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextControl(
                    text: stock?.volume.toString(),
                    isBold: true,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.greenAccent,
                    child: Center(
                      child: TextControl(
                        text: stock?.open.toString(),
                        size: TextProps.small,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  TextControl(
                    text: formatDate(date: stock!.date!, dateInWords: true),
                    isBold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
