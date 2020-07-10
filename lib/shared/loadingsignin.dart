import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff2E2E38),
      child: Center(
        child: SpinKitCubeGrid(
          color: Colors.blue[100],
          size: 50.0,
        )
      )
    );
  }
}