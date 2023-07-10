import 'package:flutter/material.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartContainer extends StatelessWidget {
  final String title;
  final List<dynamic> chartData;
  final bool animate;
  List<charts.Series<dynamic, String>> seriesList = [];

  ChartContainer({super.key, required this.title, required this.seriesList, required this.animate, required this.chartData});

  @override
  Widget build(BuildContext context) {
    // List<charts.Series<dynamic, String>> createSeries(List<Map<String, dynamic>> chartData) {
    //   Map<String, int> jumlahPerJenis = {};

    //   // Menghitung jumlah per jenis
    //   chartData.forEach((map) {
    //     List<Map<String, dynamic>> detail = map['detail'];
    //     detail.forEach((item) {
    //       String jenis = item['jenis'];
    //       int jumlah = item['jumlah'];

    //       if (jumlahPerJenis.containsKey(jenis)) {
    //         jumlahPerJenis[jenis] += jumlah;
    //       } else {
    //         jumlahPerJenis[jenis] = jumlah;
    //       }
    //     });
    //   });

    //   // Membuat list data series
    //   List<charts.Series<dynamic, String>> seriesList = [
    //     charts.Series<dynamic, String>(
    //       id: 'Produk Terjual',
    //       data: jumlahPerJenis.entries.map((entry) {
    //         return {
    //           'jenis': entry.key,
    //           'jumlah': entry.value,
    //         };
    //       }).toList(),
    //       domainFn: (item, _) => item['jenis'] as String,
    //       measureFn: (item, _) => item['jumlah'] as int,
    //     ),
    //   ];

    //   return seriesList;
    // }

    // Widget buildBarChart(List<Map<String, dynamic>> chartData) {
    //   List<charts.Series<dynamic, String>> seriesList = createSeries(chartData);

    //   return charts.BarChart(
    //     seriesList,
    //     animate: true,
    //     vertical: false,
    //     barRendererDecorator: charts.BarLabelDecorator<String>(),
    //     domainAxis: charts.OrdinalAxisSpec(
    //       renderSpec: charts.NoneRenderSpec(),
    //     ),
    //     primaryMeasureAxis: charts.NumericAxisSpec(
    //       tickProviderSpec: charts.BasicNumericTickProviderSpec(
    //         desiredTickCount: 5,
    //       ),
    //     ),
    //   );
    // }

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
                      seriesList,
                      animate: true,
                      vertical: false,
                      barRendererDecorator: charts.BarLabelDecorator<String>(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  final String jenis;
  final int jumlah;
  final charts.Color color;

  ChartData(this.jenis, this.jumlah, this.color);
}
