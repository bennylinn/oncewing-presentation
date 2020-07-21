import 'package:OnceWing/buttons/toggle.dart';
import 'package:OnceWing/services/database.dart';
import 'package:OnceWing/services/game_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EmptyContainer extends StatefulWidget {
  @override
  _EmptyContainerState createState() => _EmptyContainerState();
}

class _EmptyContainerState extends State<EmptyContainer> {
  @override
  void initState() {
    super.initState();
  }

  bool _toggle = true;
  final _globalKey = GlobalKey<ScaffoldState>();

  toggleCallback(lebool) {
    setState(() {
      _toggle = lebool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Temple',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: ToggleButton(
            toggleFn: toggleCallback,
            onSlide: () {
              GameDatabaseService()
                  .updateGameData(
                '123',
                ['alphauid'],
                'friendly',
                '123',
                1,
                {},
                DateTime.now(),
                false,
                1,
                {},
                {},
                {},
              )
                  .then((_) {
                SnackBar snackbar =
                    SnackBar(content: Text('Uploaded Successfully'));
                _globalKey.currentState.showSnackBar(snackbar);
              });
            },
            active: _toggle,
          ),
        ));
  }
}
