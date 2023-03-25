import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quit_force/screens/body/searchpage.dart';
import 'package:quit_force/screens/home/Search.dart';
//import 'package:quit_force/screens/body/searchservice.dart';

final firestoreInstance = Firestore.instance;

class MapUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Map UI",
      home: MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool mapToggle = false;

  var currentLocation;

  List<Marker> _markers = <Marker>[];
  var clients = [];

  GoogleMapController mapController;

  void _onPressed() async {
    print("enter1234");

    QuerySnapshot qs =
        await firestoreInstance.collection("markers").getDocuments();
    List elements = [];
    qs.documents.forEach((element) {
      elements.add(element.data);
      print(element.data['location']);

      _markers.add(Marker(
          markerId: MarkerId(element.data['tel no.']),
          position: LatLng(element.data['location'].latitude,
              element.data['location'].longitude),
          infoWindow: InfoWindow(
              title: element.data['quit centre name'],
              snippet: ("Tel: +65 ") + element.data['tel no.'])));
    });
  }

  void initState() {
    super.initState();
    _onPressed();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;

        print(_markers);
        mapToggle = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 160.0,
                width: double.infinity,
                child: mapToggle
                    ? GoogleMap(
                        onMapCreated: onMapCreated,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(currentLocation.latitude,
                                currentLocation.longitude),
                            zoom: 12.0),
                        markers: Set<Marker>.of(_markers),
                        scrollGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        compassEnabled: true,
                        zoomGesturesEnabled: true,
                      )
                    : Center(
                        child: Text(
                        'Loading .. Please wait ..',
                        style: TextStyle(fontSize: 20.0),
                      )),
              ),
            ],
          )
        ],
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
