import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '/core/services/location_service.dart';
import '/core/constants/constants.dart';
import 'side_panel/side_panel_widget.dart';
import '/controllers/marker_controller.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final LocationService locationService = LocationService();
  final MarkerController markerController = MarkerController();

  late GoogleMapController googleMapController;

  String? mapStyle;
  LatLng? _center;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    _loadMapStyle();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      markerController.setContext(context);
      markerController.initMarkerStream();
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

  Future<void> _loadMapStyle() async {
    mapStyle = await rootBundle.loadString('assets/styles/map_style.json');
    if (mounted) setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  @override
  void dispose() {
    markerController.dispose();
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: markerController,
      builder: (context, _) {
        return Scaffold(
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    GoogleMap(
                      style: mapStyle,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center!,
                        zoom: 11.0,
                      ),
                      markers: markerController.markers,
                      onTap: (_) => markerController.closeSidePanel(),
                    ),
                    if (markerController.showSidePanel &&
                        markerController.selectedMarker != null)
                      SidePanel(
                        isDesktop: MediaQuery.of(context).size.width >= 600,
                        selectedMarker: markerController.selectedMarker!,
                      ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: () {
                          if (markerController.showSidePanel) {
                            markerController.closeSidePanel();
                          }
                        },
                        backgroundColor: markerController.showSidePanel ? Colors.red : Colors.blue,
                        child: Icon(
                          markerController.showSidePanel
                              ? Icons.close
                              : Icons.view_carousel_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: () {
                          if (markerController.showSidePanel) {
                            markerController.closeSidePanel();
                          }
                        },
                        backgroundColor: Colors.deepPurpleAccent,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
