import 'package:flutter/material.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartContainer extends StatelessWidget {
  final String title;
  final List chart;

  const ChartContainer({
    Key? key,
    required this.title,
    required this.chart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(chart);
    final List<BarChartModel> data = [];
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
        id: title,
        data: data,
        domainFn: (BarChartModel series, _) => series.bottom,
        measureFn: (BarChartModel series, _) => series.left,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          title,
          style: ListTextStyle.textStyleBlackW700,
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.width * 0.95 * 0.65,
            padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: charts.BarChart(
                    series,
                    animate: true,
                  ),
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BarChartModel {
  String bottom;
  int left;

  BarChartModel({
    required this.bottom,
    required this.left,
  });
}
