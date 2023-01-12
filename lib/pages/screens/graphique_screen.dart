// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../widgets/app_text_large.dart';
import '../../widgets/colors.dart';

class Graphique extends StatefulWidget {
  Graphique({
    Key? key,
    required this.userCount,
    required this.playMovie,
    required this.videoCount,
    required this.activity,
  }) : super(key: key);

  int userCount;
  int playMovie;
  int videoCount;
  int activity;

  @override
  State<Graphique> createState() => _GraphiqueState();
}

class _GraphiqueState extends State<Graphique> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('number of users', widget.userCount, '70%'),
      ChartData('active person', widget.activity, '100%'),
      ChartData('video read', widget.playMovie, '82%'),
      ChartData('number of videos', widget.videoCount, '50%')
    ];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                  iconSize: 35,
                  padding: const EdgeInsets.all(15),
                  color: AppColors.activColor,
                  icon: const Icon(Icons.navigate_before),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/screens/analystic_screen',
                      (route) => false,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppTextLarge(
                      text: 'Graphique',
                      color: Theme.of(context).hintColor,
                      size: 22,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  height: 600,
                  width: double.infinity,
                  child: SfCircularChart(
                    palette: const [
                      Colors.deepOrange,
                      Colors.deepPurple,
                      Colors.yellowAccent,
                      Colors.orange
                    ],
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      toggleSeriesVisibility: true,
                      shouldAlwaysShowScrollbar: true,
                      title: LegendTitle(
                        alignment: ChartAlignment.near,
                        text: 'Legende',
                        textStyle: const TextStyle(
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    series: <CircularSeries>[
                      PieSeries<ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                          // Radius for each segment from data source
                          pointRadiusMapper: (ChartData data, _) => data.size)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.size);
  final String x;
  final int y;
  final String size;
}
