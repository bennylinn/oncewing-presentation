import 'package:OnceWing/components/element_disc.dart';
import 'package:OnceWing/models/user.dart';
import 'package:flutter/material.dart';

class ProfileCard2 extends StatelessWidget {
  final UserData userData;
  ProfileCard2({this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 300,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                  colors: [Color(0xff142A3D), Color(0xff464C56)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
              image: DecorationImage(
                image: AssetImage('assets/WindWing.png'),
                colorFilter: ColorFilter.mode(
                    Color(0xff24333D).withOpacity(0.2), BlendMode.dstATop),
              )),
          child: Container(
            height: 100,
            width: 100,
            child: ElementDisc(
              earthCount: 5,
              fireCount: 3,
              windCount: 2,
              waterCount: 4,
              level: 5,
            ),
          )),
    );
  }
}
