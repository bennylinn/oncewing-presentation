import 'package:flutter/material.dart';

class ScrolledForm extends StatefulWidget {
  void Function(String) onChanged;
  List<String> listItems;

  ScrolledForm({ this.listItems, this.onChanged });

  @override
  _ScrolledFormState createState() => _ScrolledFormState();
}

class _ScrolledFormState extends State<ScrolledForm> {
  var _currentValue;
  PageController _controller;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: (index) {
        setState(() {
          _currentValue = widget.listItems[index];
        });
        widget.onChanged(_currentValue);
      },
      controller: _controller,
      scrollDirection: Axis.vertical,
      itemCount: widget.listItems.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Center(
            child: Text('${widget.listItems[index]}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )
            ), 
            heightFactor: 1,
          ),
        );
      },
    );
  }
}