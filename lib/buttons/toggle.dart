import 'package:flutter/material.dart';


class ToggleButton extends StatefulWidget {
  final Function(bool) onPressed;
  ToggleButton ({ Key key, this.onPressed}): super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool toggleValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 75,
      child: Center(
        child: _animatedButtonUI,
      )
    );
  }
  
  Widget get _animatedButtonUI => GestureDetector(
    onTapDown: _onTap,
    child: Container(
          height: 30,
          width: 75,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            height: 30.0,
            width: 75.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: toggleValue ? Colors.greenAccent[100] : Colors.redAccent[100].withOpacity(0.5),
            ),
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeIn,
                  top: 3.0,
                  left: toggleValue ? 40.0 : 0.0,
                  right: toggleValue ? 0.0 : 40.0,
                  child: InkWell(
                    onTap: toggleButton,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      // transitionBuilder: (Widget child, Animation<double> animation) {
                      //   return RotationTransition(
                      //     child: child, turns: animation);
                      // },
                      child: toggleValue ? Icon(Icons.check_circle, color: Colors.green, size: 25.0, 
                      key: UniqueKey(),
                      ) : Icon(Icons.remove_circle_outline, color: Colors.red, size: 25.0,
                      key: UniqueKey(),
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  
  void _onTap(TapDownDetails details) {
    widget.onPressed(toggleValue);
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }
}