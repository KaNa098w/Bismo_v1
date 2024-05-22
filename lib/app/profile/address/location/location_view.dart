import 'dart:async';

import 'package:bismo/core/constants/constants.dart';
import 'package:bismo/core/models/location/screens/current_location.dart';
import 'package:bismo/core/models/location/screens/nearby_places.dart';
import 'package:bismo/core/models/location/screens/polyline_screen.dart';
import 'package:bismo/core/models/location/screens/search_places.dart';
import 'package:bismo/core/models/location/screens/simple_map.dart';
import 'package:bismo/core/presentation/components/order_traking_page.dart';
import 'package:flutter/material.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/presentation/components/app_radio.dart';
import 'package:bismo/core/presentation/widgets/app_back_button.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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

  static LatLng sourceLocation = const LatLng(37.33500926, -122.03272188);
  static LatLng destination = const LatLng(37.33429383, -122.06600055);

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Google Maps"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const SimpleMapScreen();
                  }));
                },
                child: const Text("Simple Map")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const CurrentLocationScreen();
                  }));
                },
                child: const Text("User current location")),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.of(context)
            //           .push(MaterialPageRoute(builder: (BuildContext context) {
            //         return const SearchPlacesScreen();
            //       }));
            //     },
            //     child: const Text("Search Places")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const NearByPlacesScreen();
                  }));
                },
                child: const Text("Near by Places")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const PolylineScreen();
                  }));
                },
                child: const Text("Polyline between 2 points"))
          ],
        ),
      ),
    );
  }
}
