import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    target: LatLng(27.68449167191457, 85.31691690915865),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  var maptheme;
  Future<void> setstyles() async{
    maptheme = await rootBundle.loadString('raw/maps.json');
  }
  var showmaps =false;
  delayfunction(){
    Future.delayed(Duration(seconds: 2)).whenComplete((){
      setState(() {
        showmaps =true;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    delayfunction();
    setstyles();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          showmaps == false ?Container(
            child: CircularProgressIndicator(),
          ):GoogleMap(
            mapType: MapType.normal,
            style: maptheme,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {
              Marker(
                infoWindow: InfoWindow(title: "PCPS",
                snippet: "This is us"),
                markerId: MarkerId("1"),
                onTap: (){
                 //
                },
                position: LatLng(27.68449167191457, 85.31691690915865)
              )
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the pcps!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}