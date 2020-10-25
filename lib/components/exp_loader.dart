import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ExperienceLoader extends StatefulWidget {
  Widget child;
  double size;
  int exp;
  ExperienceLoader({this.child, this.size, this.exp});
  @override
  _ExperienceLoaderState createState() => _ExperienceLoaderState();
}

class _ExperienceLoaderState extends State<ExperienceLoader> {
  var percent;

  showPercentLevel(exp) {
    if (exp < 200) {
      return exp / 2;
    } else if (exp < 450) {
      return (exp - 200) / 2.5;
    } else if (exp < 800) {
      return (exp - 450) / 3.5;
    } else if (exp < 1200) {
      return (exp - 800) / 4;
    } else {
      return 100.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      innerWidget: (double value) {
        return Padding(
          padding: const EdgeInsets.all(9.0),
          child: widget.child,
        );
      },
      initialValue: showPercentLevel(widget.exp),
      appearance: CircularSliderAppearance(
          size: widget.size,
          angleRange: 300,
          startAngle: 121,
          customWidths: CustomSliderWidths(
            handlerSize: 2,
            progressBarWidth: 5,
          ),
          customColors: CustomSliderColors(
              trackColor: Colors.white,
              dotColor: Colors.transparent,
              progressBarColor: Color(0xffC49859),
              progressBarColors: [Color(0xffC49859), Color(0xff2B2213)])),
    );
  }
}
