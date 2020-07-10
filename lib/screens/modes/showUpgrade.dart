import 'package:flutter/material.dart';

showUpgrade(BuildContext parentContext, String transition) {
    showGeneralDialog(
      barrierDismissible: false,
      barrierColor: Colors.black,
      transitionDuration: Duration(milliseconds: 300),
      context: parentContext,
      pageBuilder: (BuildContext context, Animation animation, Animation secondAnimation) {
      // player.play("silverToGold.mp3");
      Future.delayed(Duration(seconds: 8), () {
        
        Navigator.of(context).pop(true);
      });
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/$transition.gif'),
            fit: BoxFit.fitWidth
            )
          ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FlatButton(
            child: Container(height: 0,),
            onPressed: () {Navigator.pop(context);},
          ),
        )
        );
      }
    );
  }