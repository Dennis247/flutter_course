//import 'package:flutter/material.dart';
//import 'package:map_view/location.dart';
//import 'package:map_view/map_view_type.dart';
//import 'package:map_view/marker.dart';
//import 'package:map_view/static_map_provider.dart';
//
//class LocationInput extends StatefulWidget {
//  @override
//  _LocationInputState createState() => _LocationInputState();
//}
//
//class _LocationInputState extends State<LocationInput> {
//  Uri _staticMapUri;
//  final FocusNode _addressInputFocusNode = FocusNode();
//
//  @override
//  void initState() {
//    _addressInputFocusNode.addListener(_updateLocation);
//    getStaticMap();
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    _addressInputFocusNode.removeListener(_updateLocation);
//    super.dispose();
//  }
//
//  void getStaticMap() {
//    final StaticMapProvider staticMapProvider =
//        StaticMapProvider("AIzaSyDQdISo9BsnlIl6pRZ3SZF30CDs_ZK-3H4");
//    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(
//        [Marker("position", "Position", 41.40338, 2.17403)],
//        center: Location(41.40338, 2.17403),
//        width: 500,
//        height: 300,
//        maptype: StaticMapViewType.roadmap);
//    setState(() {
//      _staticMapUri = staticMapUri;
//    });
//  }
//
//  void _updateLocation() {}
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        TextFormField(
//          focusNode: _addressInputFocusNode,
//        ),
//        SizedBox(
//          height: 10.0,
//        ),
//        Image.network(_staticMapUri.toString()),
//      ],
//    );
//  }
//}
