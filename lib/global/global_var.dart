import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;
String googleMapKey = "AIzaSyCbJ-P-nFNdCYZ4IFhH4Cp2ptnNQeWRAs4";
String serverKeyFCM = "key=AAAAT1Rdc6I:APA91bHOFsIP0uzhQFf3KYBbyuPOzTKy4jTe9tXPZZj3SB2zirEGTys4yDTXBsvSotB_udR-hYpYpDZN40I7DvLd-tVtCwawx8Dd5IDLfCbWLSoo3XbeERyrr_Cn6K3NAf55lpafHYSI";
const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);
