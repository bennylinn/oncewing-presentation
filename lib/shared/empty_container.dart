import 'package:OnceWing/services/cache_manager.dart';
import 'package:OnceWing/shared/multi_exp.dart';
import 'package:OnceWing/shared/multi_image_uploader.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Temple',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center());
  }
}
