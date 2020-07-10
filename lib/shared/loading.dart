import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffC49859), width: 3)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.7, 1],
          colors: [Color(0xff021420), Color(0xff00484F)]
        )
      ),
      child: Center(
        child: SpinKitCubeGrid(
          color: Colors.blue[100],
          size: 50.0,
        )
      )
    );
  }
}