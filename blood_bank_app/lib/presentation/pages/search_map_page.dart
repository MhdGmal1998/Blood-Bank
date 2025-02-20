// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math' as math;

import 'package:blood_bank_app/domain/entities/donor_point.dart';
import 'package:blood_bank_app/domain/usecases/send_notfication_.dart';
import 'package:blood_bank_app/presentation/cubit/maps_cubit/maps_cubit.dart';
import 'package:blood_bank_app/presentation/cubit/send_notfication/send_notfication_cubit.dart';
import 'package:blood_bank_app/presentation/resources/constatns.dart';

import '../../domain/entities/blood_types.dart';
import '../../domain/entities/donor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../cubit/search_cubit/search_cubit.dart';
import 'package:location/location.dart' as loc;

import '../widgets/home/home_drawer/home_drawer.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class SearchMapPage extends StatefulWidget {
  const SearchMapPage({Key? key}) : super(key: key);
  static const String routeName = "search_map";

  @override
  State<SearchMapPage> createState() => _SearchMapPageState();
}

class _SearchMapPageState extends State<SearchMapPage> {
  final Completer<GoogleMapController> _mapcontroller = Completer();
  final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;
  final List<Marker> _marker = [];
  // bool hasCurrentLocation = false;
  // bool servicestatus = false;
  // bool haspermission = false;
  // late LocationPermission permission;
  // late Position position;
  // String long = "", lat = "";
  // late StreamSubscription<Position> positionStream;
  // var location = loc.Location();
  // static const LatLng sourcelocation = LatLng(13.9585005, 44.1709885);
  // static const LatLng destination = LatLng(13.9672166, 44.1635721);
  // List<LatLng> polylinCoordinates = [];
  // DonorPoint me = DonorPoint(
  //   lat: 13.9585005,
  //   lon: 44.1709885,
  //   name: "أنا",
  //   bloodType: "",
  //   phone: "",
  //   token: "",
  // );

  @override
  void initState() {
    // checkGps();
    // refreshDeviceLocation();
    super.initState();
  }

  // checkGps() async {
  //   servicestatus = await location.serviceEnabled();
  //   if (servicestatus) {
  //     permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         if (kDebugMode) {
  //           print('Location permissions are denied');
  //         }
  //       } else if (permission == LocationPermission.deniedForever) {
  //         if (kDebugMode) {
  //           print("'Location permissions are permanently denied");
  //         }
  //       } else {
  //         haspermission = true;
  //       }
  //     } else {
  //       haspermission = true;
  //     }
  //     if (haspermission) {
  //       getLocation();
  //     }
  //   } else {
  //     if (!await location.serviceEnabled()) {
  //       await location.requestService();
  //       checkGps();
  //     }
  //     if (kDebugMode) {
  //       print("GPS Service is not enabled, turn on GPS location");
  //     }
  //   }
  // }

  // getLocation() async {
  //   position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   if (kDebugMode) {
  //     print(position.longitude); //Output: 80.24599079
  //     print(position.latitude); //Output: 29.6593457
  //   }
  //   long = position.longitude.toString();
  //   lat = position.latitude.toString();
  //   setState(() {
  //     hasCurrentLocation = true;
  //   });
  //   LocationSettings locationSettings = const LocationSettings(
  //     accuracy: LocationAccuracy.high, //accuracy of the location data
  //     distanceFilter: 100, //minimum distance (measured in meters) a
  //   );
  //   StreamSubscription<Position> positionStream =
  //       Geolocator.getPositionStream(locationSettings: locationSettings)
  //           .listen((Position position) {
  //     long = position.longitude.toString();
  //     lat = position.latitude.toString();
  //   });
  // }

  // refreshDeviceLocation() async {
  //   location.getLocation().then(
  //     (location) {
  //       location = location;
  //     },
  //   );
  //   GoogleMapController googleMapController = await _mapcontroller.future;
  //   location.onLocationChanged.listen(
  //     (newLoc) {
  //       final currentLocation = newLoc;
  //       googleMapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             zoom: 13.5,
  //             target: LatLng(
  //               newLoc.latitude!,
  //               newLoc.longitude!,
  //             ),
  //           ),
  //         ),
  //       );
  //       setState(() {});
  //     },
  //   );
  // }

  // List<DonorPoint> getDonorPoints(SearchSuccess state) {
  //   List<DonorPoint> points = [];
  //   String selectedBloodType =
  //       BlocProvider.of<SearchCubit>(context).selectedBloodType!;
  //   List<Donor> suitableDonors = state.donorsInState
  //       .where((donor) =>
  //           BloodTypes.canReceiveFrom(bloodType: selectedBloodType)
  //               .contains(donor.bloodType))
  //       .toList();
  //   for (var donor in suitableDonors) {
  //     points.add(DonorPoint(
  //       lat: double.tryParse(donor.lat) ?? 0.0,
  //       lon: double.tryParse(donor.lon) ?? 0.0,
  //       name: donor.name,
  //       phone: donor.phone,
  //       bloodType: donor.bloodType,
  //       token: donor.token,
  //     ));
  //   }
  //   return points;
  // }

  // // Filtering Points
  // List<DonorPoint> getNearbyPoints({
  //   required DonorPoint base,
  //   required List<DonorPoint> points,
  //   required double distanceKm,
  // }) {
  //   List<DonorPoint> nearPoints = [];
  //   print(distanceKm);
  //   for (var point in points) {
  //     double far = getDistanceFromLatLonInKM(point1: base, point2: point);
  //     print("========far====distanceKm=====");
  //     print(far);
  //     if (far < distanceKm) {
  //       nearPoints.add(point);
  //     }
  //   }
  //   return nearPoints;
  // }

  // getDistanceFromLatLonInKM({
  //   required DonorPoint point1,
  //   required DonorPoint point2,
  // }) {
  //   var R = 6371; // Radius of the earth in km
  //   var dLat = deg2rad(point2.lat - point1.lat); // deg2rad below
  //   var dLon = deg2rad(point2.lon - point1.lon);
  //   var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
  //       math.cos(deg2rad(point1.lat)) *
  //           math.cos(deg2rad(point2.lat)) *
  //           math.sin(dLon / 2) *
  //           math.sin(dLon / 2);
  //   var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  //   var d = R * c; // Distance in km
  //   return d;
  // }

  // deg2rad(deg) {
  //   return deg * (math.pi / 180);
  // }

  List<Marker> _generateMarkers(List<DonorPoint> listPoints) {
    return List<Marker>.generate(listPoints.length, (index) {
      return Marker(
        markerId: MarkerId("$index"),
        position: LatLng(listPoints[index].lat, listPoints[index].lon),
        infoWindow: InfoWindow(
          onTap: () async {
            final Uri launchUri = Uri(
              scheme: 'tel',
              path: listPoints[index].phone,
            );
            await launcher.launch(
              launchUri.toString(),
              useSafariVC: false,
              useWebView: false,
              enableJavaScript: false,
              enableDomStorage: false,
              universalLinksOnly: true,
              headers: <String, String>{},
            );
          },
          title: listPoints[index].bloodType,
          snippet: "${listPoints[index].name} • 📞 ${listPoints[index].phone}",
        ),
      );
    });
  }

  // void getPolyPoints() async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyCl1B3ibzOgquh5yV9lRRmYd1Yf4uE1Yf8",
  //     PointLatLng(sourcelocation.latitude, sourcelocation.longitude),
  //     PointLatLng(destination.latitude, destination.longitude),
  //   );
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylinCoordinates.add(LatLng(point.latitude, point.longitude));
  //       setState(() {});
  //     });
  //   } else {
  //     if (kDebugMode) {
  //       print("----------------------------");
  //       print(result.errorMessage);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("مواقع المتبرعين"),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          // BlocConsumer<SearchCubit, SearchState>(
          //   listener: (context, state) {},
          //   builder: (context, state) {
          // if (state is SearchSuccess) {
          // return
          MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
        child: SafeArea(
          child: BlocConsumer<MapsCubit, MapsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is MapsSuccess) {
                List<String> nearbyTokens = state.nearbyDonors
                    .map((donorPoint) => donorPoint.token)
                    .toList();
                SendNotificationData notificationMessage = SendNotificationData(
                  listToken: nearbyTokens,
                  title: "title",
                  body: "body",
                );
                BlocProvider.of<SendNotficationCubit>(context)
                    .sendNotficationUseCase(
                        sendNotficationData: notificationMessage);
                List<DonorPoint> listPoints = state.nearbyDonors;
                // if (state is SearchSuccess) listPoints = getDonorPoints(state);
                // listPoints = getNearbyPoints(
                //   base: me,
                //   points: listPoints,
                //   distanceKm: 5.0,
                // );
                final List<Marker> markBrach = _generateMarkers(listPoints);
                _marker.addAll(markBrach);
                Position position = state.position;
                return GoogleMap(
                  markers: Set<Marker>.of(_marker),
                  initialCameraPosition: CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 13.5),
                  // polylines: {
                  //   Polyline(
                  //       polylineId: const PolylineId("route"),
                  //       points: polylinCoordinates,
                  //       color: Colors.black,)
                  // },
                );
              } else {
                return const Center(child: Text("not map success"));
              }
            },
          ),
        ),
      ),
      // } else {
      //   return const Center(child: Text("not search success"));
      // }
      //   },
      // ),
      drawer: const HomeDrower(),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.search_rounded),
      //   onPressed: () async {
      //     position = await Geolocator.getCurrentPosition(
      //         desiredAccuracy: LocationAccuracy.high);
      //     if (kDebugMode) {
      //       print(position.longitude);
      //       print(position.latitude);
      //     }

      //     // // get the current location
      //     // await LocationManager().getCurrentLocation();
      //     // // start listen to location updates
      //     // StreamSubscription<LocationDto> locationSubscription =
      //     //     LocationManager().locationStream.listen((LocationDto dto) {
      //     //   print('======================');
      //     //   print(dto.altitude);
      //     //   print(dto.longitude);
      //     // });
      //     // // cancel listening and stop the location manager
      //     // locationSubscription.cancel();
      //     // LocationManager().stop();
      //     // // Navigator.of(context).pushNamed(SearchPage.routeName);
      //   },
      // ),
    );
  }
}
// listPorin = [
//   RecivePoint(latitude: "13.9585003", longitude: '44.1709884'),
//   RecivePoint(latitude: "13.9585003", longitude: '44.1709884'),
//   RecivePoint(latitude: "13.9556008", longitude: '44.1708603'),
//   RecivePoint(latitude: "13.9556071", longitude: '44.1708585'),
// ];
