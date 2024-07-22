import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
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
