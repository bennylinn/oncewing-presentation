import 'package:flutter/material.dart';

class Shop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: EdgeInsets.only(top: 30),
        children: <Widget>[
          Container(
            alignment: Alignment(5.0, 5.0),
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/wind_crewneck.png'),
                fit: BoxFit.fitWidth,
              )
            ),
          ),
          SizedBox(height: 15,),
          Text(
            'Coming Soon!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 30.0,
              color: Colors.white,
              ),
          )
        ],
      ),
    );
  }
}