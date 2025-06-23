import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String locationName;

  const LocationMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(locationName,
        style: TextStyle(color: Color(0xFF0172B2),fontWeight:FontWeight.bold),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('suggestion_location'),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: locationName),
          ),
        },
      ),
    );
  }
}

//عرض خريطة صغيرة
class LocationPreview extends StatelessWidget {
  final double latitude;
  final double longitude;

  const LocationPreview({required this.latitude, required this.longitude, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 150,
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: {
            Marker(
              markerId: MarkerId('preview_marker'),
              position: LatLng(latitude, longitude),
            ),
          },
          zoomControlsEnabled: false,
          zoomGesturesEnabled: false,
          scrollGesturesEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          myLocationButtonEnabled: false,
          liteModeEnabled: true,
          onMapCreated: (GoogleMapController controller) {},
        ),
      ),
    );
  }
}