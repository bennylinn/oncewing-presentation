import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class ToggleButton extends StatefulWidget {
  final active;
  final Function(bool) toggleFn;
  final Null Function() onSlide;
  ToggleButton({Key key, this.toggleFn, this.onSlide, this.active})
      : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 200,
        child: Center(
            child: SliderButton(
          width: 200,
          height: 60,
          vibrationFlag: false,
          dismissible: false,
          buttonSize: 50,
          action: () {
            print('slid');
            widget.toggleFn(!widget.active);
            if (widget.active) {
              widget.onSlide();
            }
            setState(() {
              active = !active;
            });
          },
          label: Text(
            "Update Scores",
            style: TextStyle(
                color: Color(0xff4a4a4a),
                fontWeight: FontWeight.w500,
                fontSize: 17),
          ),
          icon: Center(
              child: Icon(
            Icons.navigate_next,
            color: Colors.white,
            size: 30.0,
            semanticLabel: 'Text to announce in accessibility modes',
          )),
          buttonColor: widget.active ? Colors.red : Colors.grey,
          backgroundColor: widget.active ? Colors.red[300] : Colors.grey[400],
          highlightedColor: widget.active ? Colors.black : Colors.white,
          baseColor: Colors.white,
        )));
  }
}
