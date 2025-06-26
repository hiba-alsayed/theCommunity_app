import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart ' as loc ;
import 'package:geocoding/geocoding.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  GoogleMapController? _mapController;
  LatLng? _pickedLocation; // 	Stores the selected latitude/longitude
  // String? _placeName = ''; //Stores the reverse-geocoded address
  late loc.Location _location;

  @override
  void initState() {
    super.initState();
    _location = loc.Location();
    _location.requestPermission();
  }

  Future<void> _onMapTap(LatLng position) async {
    setState(() {
      _pickedLocation = position;
      // _placeName = 'Loading...';
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // if (placemarks.isNotEmpty) {
      //   Placemark place = placemarks.first;
      //   setState(() {
      //     _placeName =
      //     "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      //   });
      // } else {
      //   setState(() {
      //     _placeName = "Unknown location";
      //   });
      // }
    } catch (e) {
      setState(() {
        // _pickedLocation = "Failed to get place name";
      });
    }
  }

  void _submitLocation() {
    if (_pickedLocation != null) {
      Navigator.pop(context, {
        'location': _pickedLocation,
        // 'placeName': _placeName ?? '',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'اختيار الموقع',
          style: TextStyle(
            color: Color(0xFF0172B2),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Color(0xFF0172B2),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(33.5138, 36.2765),
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onMapTap,
            markers: _pickedLocation != null
                ? {
              Marker(
                markerId: const MarkerId('picked-location'),
                position: _pickedLocation!,
              ),
            }
                : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            color: Color(0xFF0172B2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FloatingActionButton.extended(
          onPressed: _submitLocation,
          label: const Text('اختر هذا الموقع'),
          icon: const Icon(Icons.check),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
