import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState.withSampleData();
}

class _ChartPageState extends State<ChartPage> {
  late List<charts.Series> seriesList;
  final bool animate = true;

  _ChartPageState(this.seriesList);

  factory _ChartPageState.withSampleData() {
    return new _ChartPageState(_createSampleData());
  }
  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60));
  }

  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 100),
      new LinearSales(1, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
