// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'page.dart';

class MoveCameraPage extends GoogleMapExampleAppPage {
  MoveCameraPage() : super(const Icon(Icons.map), 'Camera control');

  @override
  Widget build(BuildContext context) {
    return const MoveCamera();
  }
}

class MoveCamera extends StatefulWidget {
  const MoveCamera();
  @override
  State createState() => MoveCameraState();
}

class MoveCameraState extends State<MoveCamera> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  initState() {
    super.initState();
    markers = <MarkerId, Marker>{
      MarkerId('Drive Badminton Centre'): Marker(
        markerId: MarkerId('Drive Badminton Centre'),
        position: LatLng(49.18054, -123.1395),
        infoWindow: InfoWindow(title: 'Drive Badminton Centre'),
        onTap: () {
          mapController.moveCamera(
            CameraUpdate.newLatLngZoom(
              const LatLng(49.18054, -123.1395),
              17,
            ),
          );
        },
      ),
      MarkerId('Hollyburn Country Club'): Marker(
        markerId: MarkerId('Hollyburn Country Club'),
        position: LatLng(49.34347495, -123.1436132),
        infoWindow: InfoWindow(title: 'Hollyburn Country Club'),
        onTap: () {
          mapController.moveCamera(
            CameraUpdate.newLatLngZoom(
              const LatLng(49.34347495, -123.1436132),
              17,
            ),
          );
        },
      ),
      MarkerId('Vancouver Racquets Club'): Marker(
        markerId: MarkerId('Vancouver Racquets Club'),
        position: LatLng(49.2410962, -123.10608849),
        infoWindow: InfoWindow(title: 'Vancouver Racquets Club'),
        onTap: () {
          mapController.moveCamera(
            CameraUpdate.newLatLngZoom(
              const LatLng(49.2410962, -123.10608849),
              17,
            ),
          );
        },
      ),
      MarkerId('ClearOne Browngate'): Marker(
        markerId: MarkerId('ClearOne Browngate'),
        position: LatLng(49.18226826, -123.13779556),
        infoWindow: InfoWindow(title: 'ClearOne Browngate'),
        onTap: () {
          mapController.moveCamera(
            CameraUpdate.newLatLngZoom(
              const LatLng(49.18226826, -123.13779556),
              17,
            ),
          );
        },
      ),
    };
  }

  MarkerId selectedMarker;

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC49859), width: 8)),
            width: 300.0,
            height: 300.0,
            child: GoogleMap(
                markers: Set<Marker>.of(markers.values),
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                    zoom: 10,
                    tilt: 30.0,
                    target: LatLng(49.244911, -123.124077)),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  ),
                ].toSet()),
          ),
        ),
        FlatButton(
          onPressed: () {
            mapController.moveCamera(
              CameraUpdate.newCameraPosition(
                const CameraPosition(
                  bearing: 0,
                  target: LatLng(49.244911, -123.124077),
                  tilt: 30.0,
                  zoom: 10,
                ),
              ),
            );
          },
          child: const Text('Reset', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
