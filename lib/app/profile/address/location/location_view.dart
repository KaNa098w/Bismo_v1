import 'dart:async';

import 'package:bismo/core/presentation/components/order_traking_page.dart';
import 'package:flutter/material.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/presentation/components/app_radio.dart';
import 'package:bismo/core/presentation/widgets/app_back_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationView extends StatefulWidget {
  final String? title;
  const LocationView({Key? key, this.title}) : super(key: key);

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  final Completer<GoogleMapController> _controller = Completer();

  static  LatLng sourceLocation = const LatLng(37.33500926, -122.03272188);
  static  LatLng destination = const LatLng(37.33429383, -122.06600055);

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Tracker'),
      ),
      body: GoogleMap(
        initialCameraPosition:  CameraPosition(target: sourceLocation, zoom: 14.5),
        markers: {
           Marker(markerId: const MarkerId("source"), position: sourceLocation),
           Marker(markerId: const MarkerId("destination"), position: destination),
        },
      ),
    );
}
}