// counter_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Count extends StatelessWidget {
  final int count;
  final VoidCallback onCountSelected;

  final Function(int) onCountChange;

  final _controller = TextEditingController();

  Count({
    @required this.count,
    @required this.onCountChange,
    this.onCountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.blueGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              onCountChange(-1);
            },
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
                signed: true,
              ),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
          ),         
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              onCountChange(1);
            },
          ),
        ],
      ),
    );
  }
}