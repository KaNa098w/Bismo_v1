// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';


// class SearchPlacesScreen extends StatefulWidget {
//   const SearchPlacesScreen({Key? key}) : super(key: key);

//   @override
//   State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
// }

// const kGoogleApiKey = 'AIzaSyBgFpvjSqARzz-wipDKoM9xcjkgTV4X-N4';
// final homeScaffoldKey = GlobalKey<ScaffoldState>();

// class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
//   static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(37.42796, -122.08574), zoom: 14.0);

//   late GoogleMapController googleMapController;
//   Set<Marker> markersList = {};

//   final Mode _mode = Mode.overlay;

//   void onError(PlacesAutocompleteResponse response, BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       elevation: 0,
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: Colors.transparent,
//       content: Text('Сообщение: ${response.errorMessage}'),
//     ));
//   }

//   Future<void> displayPrediction(Prediction p, BuildContext context) async {
//     GoogleMapsPlaces places = GoogleMapsPlaces(
//       apiKey: kGoogleApiKey,
//       apiHeaders: await const GoogleApiHeaders().getHeaders(),
//     );

//     PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

//     final lat = detail.result.geometry!.location.lat;
//     final lng = detail.result.geometry!.location.lng;

//     markersList.clear();
//     markersList.add(Marker(markerId: const MarkerId("0"), position: LatLng(lat, lng), infoWindow: InfoWindow(title: detail.result.name)));

//     setState(() {});

//     googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
//   }

//   Future<void> _handlePressButton(BuildContext context) async {
//     Prediction? p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       onError: (response) => onError(response, context),
//       mode: _mode,
//       language: 'ru', // Язык запроса на русский
//       strictbounds: false,
//       types: [],
//       components: [Component(Component.country, "pk"), Component(Component.country, "usa")],
//     );

//     if (p != null) {
//       displayPrediction(p, context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: homeScaffoldKey,
//       appBar: AppBar(
//         title: const Text("Поиск мест в Google"),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: initialCameraPosition,
//             markers: markersList,
//             mapType: MapType.normal,
//             onMapCreated: (GoogleMapController controller) {
//               googleMapController = controller;
//             },
//           ),
//           ElevatedButton(
//             onPressed: () => _handlePressButton(context),
//             child: const Text("Найти место"),
//           )
//         ],
//       ),
//     );
//   }
// }
