import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class QR extends StatefulWidget {
  Function callback;
  String uid;
  QR({this.callback, this.uid});

  @override
  _QRState createState() => _QRState();
}

class _QRState extends State<QR> {
  String result;

  @override
  initState() {
    super.initState();
    result = "No Data";
  }

  Future _scanQR() async {
    try {
      var qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult.rawContent;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: 150,
      child: Column(
        children: [
          Center(
            child: PrettyQr(
                elementColor: Colors.black,
                image: AssetImage('assets/logo.png'),
                typeNumber: 3,
                size: 150,
                data: widget.uid,
                errorCorrectLevel: QrErrorCorrectLevel.M,
                roundEdges: true),
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Scan"),
            onPressed: () {
              _scanQR().then((value) => widget.callback(value));
            },
          )
        ],
      ),
    );
  }
}
