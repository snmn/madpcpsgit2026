import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(27.68476419482367, 85.31625997815242),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              markers: {
                Marker(
                  markerId: MarkerId("pcps"),
                  position: LatLng(27.68476419482367, 85.31625997815242),
                  infoWindow: InfoWindow(
                    title: "PCPS"
                  )
                )
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

              },
            ),
          ),

          Positioned(
            bottom: 50,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  height: size.height/4,
                  width: size.width/1.5,
                  color: Colors.grey,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  height: size.height/4,
                  width: size.width/1.5,
                  color: Colors.grey,
                )
              ],
            ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}