import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:quit_force/screens/body/searchservice.dart';
//import 'searchservice.dart';

class SearchUI extends StatefulWidget {
  @override
  _SearchUIState createState() => _SearchUIState();
}

class _SearchUIState extends State<SearchUI> {
  @override
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['quit centre name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        /*appBar: new AppBar(
          title: Text('Firestore search'),
        ),*/
        body: ListView(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          onChanged: (val) {
            initiateSearch(val);
          },
          decoration: InputDecoration(
              prefixIcon: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                iconSize: 20.0,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              contentPadding: EdgeInsets.only(left: 25.0),
              hintText: 'Search by name',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
        ),
      ),
      Column(
          children: tempSearchStore.map((element) {
        return buildResultCard(element);
      }).toList())
    ]));
  }
}

Widget buildResultCard(data) {
  return SizedBox(
    height: 115.0,
    child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.0)),
        elevation: 2.0,
        child: Container(
            color: Colors.lightGreen[300],
            child: Center(
                child: Column(
              children: [
                Text(
                  data['quit centre name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  ("Address: ") + data['address'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  ("Postcode: ") + data['postcode'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  ("Tel: +65") + data['tel no.'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15.0,
                  ),
                ),
              ],
            )))),
  );
}

class SearchService {
  searchByName(String searchField) {
    return Firestore.instance
        .collection('markers')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}
