import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nino_web/models/marker_model.dart';

import '/core/services/location_service.dart';
import '/core/constants/constants.dart';
import '/views/widgets/side_panel_widget.dart';
import '../../controllers/marker_controller.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final LocationService locationService = LocationService();
  final MarkerController markerController = MarkerController(); 
  final Set<Marker> _markers = {}; 

  late GoogleMapController googleMapController;

  LatLng? _center;
  bool _isLoading = true;
  bool _showSidePanel = false;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMarkers(context);
    });
  }

  Future<void> _fetchLocation() async {
    try {
      Position position = await locationService.getCurrentLocation();
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _center = LatLng(
          LocationConstants.defaultLatitude,
          LocationConstants.defaultLongitude,
        );
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeMarkers(BuildContext context) async {
    markerController.setContext(context);
    
    final exampleMarkers = [
      MarkerModel(
        id: '1',
        position: LatLng(37.7749, -122.4194),
        borderColor: Colors.blue,
      ),
    ];

    for (var markerData in exampleMarkers) {
      final marker = await markerController.createMarker(
        markerData.id,
        markerData.position,
        markerData.borderColor,
        "assets/images/protest.jpg"
      );
      setState(() => _markers.add(marker));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  void _toggleSidePanel() {
    setState(() {
      _showSidePanel = !_showSidePanel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center!,
                    zoom: 11.0,
                  ),
                  markers: _markers
                ),
                if (_showSidePanel)
                  SidePanel(
                    isDesktop: MediaQuery.of(context).size.width >= 600,
                  ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: _toggleSidePanel,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(
                      _showSidePanel
                          ? Icons.close
                          : Icons.view_carousel_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}