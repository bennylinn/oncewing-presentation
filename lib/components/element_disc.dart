import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:OnceWing/components/exp_loader.dart';

class ElementDisc extends StatelessWidget {
  final int waterCount;
  final int windCount;
  final int fireCount;
  final int earthCount;
  final int level;
  ElementDisc(
      {this.waterCount,
      this.windCount,
      this.fireCount,
      this.earthCount,
      this.level});

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = new Map<String, double>();

    dataMap.putIfAbsent("Water", () => waterCount.toDouble());
    dataMap.putIfAbsent("Wind", () => windCount.toDouble());
    dataMap.putIfAbsent("Fire", () => fireCount.toDouble());
    dataMap.putIfAbsent("Earth", () => earthCount.toDouble());

    return Container(
      height: 130,
      width: 130,
      child: Stack(alignment: Alignment.center, children: <Widget>[
        CircleAvatar(
          radius: 78,
          backgroundColor: Colors.blue[100],
        ),
        PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartRadius: MediaQuery.of(context).size.width / 2.7,
          chartValueBackgroundColor: Colors.purple[50],
          colorList: [Colors.blue, Colors.grey, Colors.red, Colors.brown],
          showLegends: false,
          showChartValuesOutside: true,
          showChartValueLabel: true,
          initialAngle: 0,
          chartType: ChartType.disc,
        ),
        CircleAvatar(
          backgroundColor: Colors.black,
          radius: 47,
          child: Text('LVL $level',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        ExperienceLoader(
          size: 98,
          exp: 150,
          child: Container(),
        ),
      ]),
    );
  }
}
