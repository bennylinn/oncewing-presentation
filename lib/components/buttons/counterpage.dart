import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountButton extends StatefulWidget {
  final List<dynamic> count;
  final Function(List<int>, int) callback;
  final int index;
  final double height;
  final double width;
  CountButton(this.count, this.callback, this.index, this.height, this.width);

  @override
  _NumberInputWithIncrementDecrementState createState() =>
      new _NumberInputWithIncrementDecrementState();
}

class _NumberInputWithIncrementDecrementState extends State<CountButton> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  bool saved;

  @override
  void initState() {
    super.initState();
    _controller1.text = "0";
    _controller2.text = "0";
    saved = true;
  }

  @override
  void didUpdateWidget(CountButton oldWidget) {
    if (oldWidget.count != widget.count) {
      // values changed, restart animation.
      _controller1.text = widget.count[0].toString();
      _controller2.text = widget.count[1].toString();
      print('we updating...');
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: Container(
            height: widget.height,
            width: 200,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Colors.blue[100],
                width: 2.0,
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: widget.height,
                  width: 125,
                  child: Column(
                    children: [
                      Container(
                        height: widget.height / 2,
                        width: 125,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                style: TextStyle(
                                  color: saved ? Colors.black : Colors.white,
                                  fontSize: 24,
                                  fontWeight: saved
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 5.0),
                                ),
                                controller: _controller1,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: false,
                                  signed: true,
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            Container(
                              height: widget.height / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    hoverColor: Colors.white,
                                    child: Icon(
                                      Icons.arrow_drop_up,
                                      size: (widget.height / 4) - 1,
                                      color: Colors.blue[100],
                                    ),
                                    onTap: () {
                                      saved = false;
                                      int currentValue =
                                          int.parse(_controller1.text);
                                      if (int.parse(_controller1.text) +
                                              int.parse(_controller2.text) ==
                                          0) {
                                        setState(() {
                                          _controller1.text = '21';
                                        });
                                      } else {
                                        setState(() {
                                          currentValue++;
                                          _controller1.text = (currentValue)
                                              .toString(); // incrementing value
                                        });
                                      }
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        _controller1.text = '21';
                                      });
                                    },
                                  ),
                                  InkWell(
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      size: (widget.height / 4) - 1,
                                      color: Colors.blue[100],
                                    ),
                                    onTap: () {
                                      saved = false;
                                      int currentValue =
                                          int.parse(_controller1.text);
                                      setState(() {
                                        currentValue--;
                                        _controller1.text = (currentValue > 0
                                                ? currentValue
                                                : 0)
                                            .toString(); // decrementing value
                                      });
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        _controller1.text = '0';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: widget.height / 2,
                        width: 125,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: TextFormField(
                                  style: TextStyle(
                                    color: saved ? Colors.black : Colors.white,
                                    fontSize: 24,
                                    fontWeight: saved
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 5.0),
                                  ),
                                  controller: _controller2,
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: true,
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: widget.height / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    hoverColor: Colors.white,
                                    child: Icon(
                                      Icons.arrow_drop_up,
                                      size: (widget.height / 4) - 1,
                                      color: Colors.blue[100],
                                    ),
                                    onTap: () {
                                      saved = false;
                                      int currentValue =
                                          int.parse(_controller2.text);
                                      if (int.parse(_controller1.text) +
                                              int.parse(_controller2.text) ==
                                          0) {
                                        setState(() {
                                          _controller2.text = '21';
                                        });
                                      } else {
                                        setState(() {
                                          currentValue++;
                                          _controller2.text = (currentValue)
                                              .toString(); // incrementing value
                                        });
                                      }
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        _controller2.text = '21';
                                      });
                                    },
                                  ),
                                  InkWell(
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      size: (widget.height / 4) - 1,
                                      color: Colors.blue[100],
                                    ),
                                    onTap: () {
                                      saved = false;
                                      int currentValue =
                                          int.parse(_controller2.text);
                                      setState(() {
                                        print("Setting state");
                                        currentValue--;
                                        _controller2.text = (currentValue > 0
                                                ? currentValue
                                                : 0)
                                            .toString(); // decrementing value
                                      });
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        _controller2.text = '0';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.blue[100],
                        width: 2.0,
                      ),
                    ),
                  ),
                  width: 75,
                  child: Column(
                    children: [
                      Container(
                        height: widget.height / 2,
                        child: FlatButton(
                          splashColor: Colors.white,
                          onPressed: () {
                            widget.callback([
                              int.parse(_controller1.text),
                              int.parse(_controller2.text)
                            ], widget.index);
                            setState(() {
                              saved = true;
                            });
                            print([
                              int.parse(_controller1.text),
                              int.parse(_controller2.text)
                            ]); //call to parent
                          },
                          child: Icon(Icons.check_circle,
                              color: Colors.greenAccent),
                        ),
                      ),
                      Container(
                        height: widget.height / 2,
                        child: FlatButton(
                          splashColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              saved = false;
                            });

                            _controller1.text = "0";
                            _controller2.text = "0";
                            widget.callback([
                              int.parse(_controller1.text),
                              int.parse(_controller2.text)
                            ], widget.index);
                          },
                          child: Icon(Icons.remove_circle_outline,
                              color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
