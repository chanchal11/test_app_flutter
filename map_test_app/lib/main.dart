import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
 @override
 _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 GoogleMapController mapController;

  LatLng _center =  LatLng(22.6018382,88.3808768);
  var stop=true;
  var lat=0.0;
  var i=20;
  var start_button_text = "Start";
 void _onMapCreated(GoogleMapController controller) {
   mapController = controller;

 }

  void updateCarLoc(LatLng loc) async {
      var lat = loc.latitude;
      i=20;
      for(;i>=0;i--) {
        setState(() {
          start_button_text = i.toString();
        });
        await Future.delayed(Duration(milliseconds: 500), () {
          lat = lat + 0.0000999;

          mapController.clearMarkers();
          mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: 270.0,
              target: LatLng(lat, loc.longitude),
              tilt: 30.0,
              zoom: 17.0,
            ),
          ));
        mapController.addMarker(
              MarkerOptions(
              position: LatLng(lat, loc.longitude),
              icon: BitmapDescriptor.fromAsset("assets/images/automobile.png",),draggable: true, infoWindowText: InfoWindowText( i.toString(), "Hiii"))
          );
        });
      }
       stop = true;
      setState(() {
        start_button_text = "Start";
      });
 }

 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     home: Scaffold(
       appBar: AppBar(
         title: Text('Car Tracker'),
       ),
       body: GoogleMap(
         onMapCreated: _onMapCreated,
         options: GoogleMapOptions(
           cameraPosition: CameraPosition(
             target: _center,
             zoom: 11.0,
           ),
         ),
       ),
       floatingActionButton: FloatingActionButton.extended(label: Text(start_button_text) ,icon: Icon(Icons.arrow_forward),onPressed: (){

         if(stop)
         {
           stop=false;
         }
         else{
           return;
         }

         var location = new Location();
          location.hasPermission().then( (value){
            try {
              location.getLocation().then((currentLocation) async {
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                    bearing: 270.0,
                    target: LatLng(currentLocation['latitude'], currentLocation['longitude']),
                    tilt: 30.0,
                    zoom: 17.0,
                  ),
                ));

                await Future.delayed(Duration(seconds: 1),(){});
                updateCarLoc(LatLng(currentLocation['latitude'], currentLocation['longitude']));
              });
            } on Exception {
              print("unable to getLocation");
            }
          } );

        } ,),
     ),
   );
 }
}
