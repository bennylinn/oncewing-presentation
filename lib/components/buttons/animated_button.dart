import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final bool ready;
  final Function(bool) onPressed;
  AnimatedButton({Key key, this.onPressed, this.ready, this.text})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Container(
      height: 50,
      width: 150,
      child: Center(
        child: _animatedButtonUI,
      ),
    );
  }

  Widget get _animatedButtonUI => GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Transform.scale(
          scale: _scale,
          child: Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              border: widget.ready
                  ? Border.all(color: Color(0xffC49859), width: 3)
                  : Border.all(color: Colors.grey, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Color(0x80000000),
                  blurRadius: 30.0,
                  offset: Offset(0.0, 5.0),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff021420), Colors.blue[600]],
              ),
              // image: DecorationImage(
              //   image: AssetImage('assets/blueTransitions.gif'),
              //   fit: BoxFit.cover
              // ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          offset: Offset(-3, 3),
                          blurRadius: 5)
                    ],
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    color: widget.ready ? Color(0xffC49859) : Colors.grey),
              ),
            ),
          )));

  void _onTapDown(TapDownDetails details) {
    _controller.forward(from: 0.08);
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.ready) {
      widget.onPressed(true);
    }
    _controller.reverse(from: 1);
  }
}
