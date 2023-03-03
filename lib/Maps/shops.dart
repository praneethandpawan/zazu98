import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maptest/Maps/Models/style.dart';

class FindFriends extends StatefulWidget {
  const FindFriends({ Key? key }) : super(key: key);

  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {
  static const CameraPosition _kGooglePlex =   CameraPosition(
    target:  LatLng(17.6868, 83.2185),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {};
  late GoogleMapController _controller;

  final List<dynamic> _contacts = [
    {
      "name": "Me",
      "position": const LatLng(17.6868, 83.2185),
      "marker": 'assets/markers/marker-1.png',
      "image": 'assets/images/avatar-1.png',
    },
    {
      "name": "Samantha",
      "position": const LatLng(37.42484642575639, -122.08309359848501),
      "marker": 'assets/markers/marker-2.png',
      "image": 'assets/images/avatar-2.png',
    },
    {
      "name": "Malte",
      "position": const LatLng(37.42381625902441, -122.0928531512618),
      "marker": 'assets/markers/marker-3.png',
      "image": 'assets/images/avatar-3.png',
    },
    {
      "name": "Julia",
      "position": const LatLng(37.41994095849639, -122.08159055560827),
      "marker": 'assets/markers/marker-4.png',
      "image": 'assets/images/avatar-4.png',
    },
    {
      "name": "Tim",
      "position": const LatLng(37.413175077529935, -122.10101041942836),
      "marker": 'assets/markers/marker-5.png',
      "image": 'assets/images/avatar-5.png',
    },
    {
      "name": "Sara",
      "position": const LatLng(37.419013242401576, -122.11134664714336),
      "marker": 'assets/markers/marker-6.png',
      "image": 'assets/images/avatar-6.png',
    },
    {
      "name": "Ronaldo",
      "position": const LatLng(37.40260962243491, -122.0976958796382),
      "marker": 'assets/markers/marker-7.png',
      "image": 'assets/images/avatar-7.png',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    createMarkers(context);

    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: FittedBox(
            fit: BoxFit.cover,
            child: Text("Choose Your location", style: TextStyle(color: Colors.black),)),
      ),
        body: Stack(
          children: [
            GoogleMap(
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              initialCameraPosition: _kGooglePlex,
              markers: _markers,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                controller.setMapStyle(MapStyle().aubergine);
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,

              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.0),
                            topLeft: Radius.circular(40.0)),
                      color: Colors.white,
                    ),

                  child: Column(
                    children: [
                      Text("data"),
                      Text("Confirm Location"),
                    ],
                  ),
                  // child: ListView.builder(
                  //   scrollDirection: Axis.horizontal,
                  //   itemCount: _contacts.length,
                  //   itemBuilder: (context, index) {
                  //     return GestureDetector(
                  //       onTap: () {
                  //         _controller.moveCamera(CameraUpdate.newLatLng(_contacts[index]["position"]));
                  //       },
                  //       child: Container(
                  //         width: 100,
                  //         height: 100,
                  //         margin: const EdgeInsets.only(right: 10),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Image.asset(_contacts[index]['image'], width: 60,),
                  //             const SizedBox(height: 10,),
                  //             Text(_contacts[index]["name"], style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),)
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
              ),
            )
          ],
        )
    );
  }

  createMarkers(BuildContext context) {
    Marker marker;

    _contacts.forEach((contact) async {
      marker = Marker(
        markerId: MarkerId(contact['name']),
        position: contact['position'],
        icon: await _getAssetIcon(context, contact['marker']).then((value) => value),
        infoWindow: InfoWindow(
          title: contact['name'],
          snippet: 'Street 6 . 2min ago',
        ),
      );

      setState(() {
        _markers.add(marker);
      });
    });
  }

  Future<BitmapDescriptor> _getAssetIcon(BuildContext context, String icon) async {
    final Completer<BitmapDescriptor> bitmapIcon = Completer<BitmapDescriptor>();
    final ImageConfiguration config = createLocalImageConfiguration(context, size: const Size(5, 5));

    AssetImage(icon)
        .resolve(config)
        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData? bytes = await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    })
    );
    return await bitmapIcon.future;
  }
}

