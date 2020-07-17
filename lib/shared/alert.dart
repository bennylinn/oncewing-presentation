import 'package:flutter/material.dart';

showAlertDialog(
    BuildContext context, String title, String message, Function fn, value) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      fn(value);
      Navigator.pop(context);
    },
  );

  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () => Navigator.pop(context),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
