import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';







class mappage1 extends StatefulWidget {
  const mappage1({Key? key}) : super(key: key);

  @override
  _mappage1State createState() => _mappage1State();
}

class _mappage1State extends State<mappage1> {
  Completer<GoogleMapController> _controller = Completer();
// on below line we have specified camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

// on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(20.42796133580664, 75.885749655962),
      infoWindow: InfoWindow(
        title: 'My Position',
      ),
    ),
  ];

// created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0F9D58),
          // on below line we have given title of app
          title: Text("GFG"),
        ),
        body: Column(
          children: [
            SafeArea(
              // on below line creating google maps
              child: GoogleMap(
                // on below line setting camera position
                initialCameraPosition: _kGoogle,
                // on below line we are setting markers on the map
                markers: Set<Marker>.of(_markers),
                // on below line specifying map type.
                mapType: MapType.normal,
                // on below line setting user location enabled.
                myLocationEnabled: true,
                // on below line setting compass enabled.
                compassEnabled: true,
                // on below line specifying controller on map complete.
                onMapCreated: (GoogleMapController controller){
                  _controller.complete(controller);
                },
              ),
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width * 0.32,
              // height: MediaQuery.of(context).size.height * 0.2,
              child: OutlinedButton(
                onPressed: () async{
                  getUserCurrentLocation().then((value) async {
                    print(value.latitude.toString() +" "+value.longitude.toString());
                    // marker added for current users location
                    _markers.add(
                        Marker(
                          markerId: MarkerId("2"),
                          position: LatLng(value.latitude, value.longitude),
                          infoWindow: InfoWindow(
                            title: 'My Current Location',
                          ),
                        )
                    );

                    // specified current users location
                    CameraPosition cameraPosition = new CameraPosition(
                      target: LatLng(value.latitude, value.longitude),
                      zoom: 14,
                    );

                    final GoogleMapController controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
                    setState(() {
                    });
                  });
                },
                child: Text('Some Other location', style: TextStyle(color: Colors.black, fontSize: 19 ),),
              ),
              decoration:BoxDecoration(
                border: Border.all(color:Color(0xFF0672CB)),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                // color: Color(0xFF0672CB),
              ),
            ),
            Container(
              height: 200,
              //width: 500,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}







// class mappage1 extends StatefulWidget {
//   const mappage1({Key? key}) : super(key: key);
//
//   @override
//   _mappage1State createState() => _mappage1State();
// }
//
// class _mappage1State extends State<mappage1> {
//   Completer<GoogleMapController> _controller = Completer();
// // on below line we have specified camera position
//   static final CameraPosition _kGoogle = const CameraPosition(
//     target: LatLng(20.42796133580664, 80.885749655962),
//     zoom: 14.4746,
//   );
//
// // on below line we have created the list of markers
//   final List<Marker> _markers = <Marker>[
//     Marker(
//         markerId: MarkerId('1'),
//         position: LatLng(20.42796133580664, 75.885749655962),
//         infoWindow: InfoWindow(
//           title: 'My Position',
//         ),
//     ),
//   ];
//
// // created method for getting user current location
//   Future<Position> getUserCurrentLocation() async {
//     await Geolocator.requestPermission().then((value){
//     }).onError((error, stackTrace) async {
//       await Geolocator.requestPermission();
//       print("ERROR"+error.toString());
//     });
//     return await Geolocator.getCurrentPosition();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF0F9D58),
//         // on below line we have given title of app
//         title: Text("GFG"),
//       ),
//       body: Container(
//         child: SafeArea(
//           // on below line creating google maps
//           child: GoogleMap(
//             // on below line setting camera position
//             initialCameraPosition: _kGoogle,
//             // on below line we are setting markers on the map
//             markers: Set<Marker>.of(_markers),
//             // on below line specifying map type.
//             mapType: MapType.normal,
//             // on below line setting user location enabled.
//             myLocationEnabled: true,
//             // on below line setting compass enabled.
//             compassEnabled: true,
//             // on below line specifying controller on map complete.
//             onMapCreated: (GoogleMapController controller){
//               _controller.complete(controller);
//             },
//           ),
//         ),
//       ),
//       // on pressing floating action button the camera will take to user current location
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async{
//           getUserCurrentLocation().then((value) async {
//             print(value.latitude.toString() +" "+value.longitude.toString());
//
//             // marker added for current users location
//             _markers.add(
//                 Marker(
//                   markerId: MarkerId("2"),
//                   position: LatLng(value.latitude, value.longitude),
//                   infoWindow: InfoWindow(
//                     title: 'My Current Location',
//                   ),
//                 )
//             );
//
//             // specified current users location
//             CameraPosition cameraPosition = new CameraPosition(
//               target: LatLng(value.latitude, value.longitude),
//               zoom: 14,
//             );
//
//             final GoogleMapController controller = await _controller.future;
//             controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//             setState(() {
//             });
//           });
//         },
//         child: Icon(Icons.local_activity),
//       ),
//     );
//   }
// }
