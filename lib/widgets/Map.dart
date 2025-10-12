import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MyMap extends StatefulWidget {
  final LatLng? markerLocation;
  final String? markerLabel;
  final bool showAppBar;

  const MyMap({super.key, this.markerLocation, this.markerLabel, this.showAppBar = false});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final LatLng _esquinaSW = const LatLng(24.784875, -107.401350); // Suroeste
  final LatLng _esquinaNE = const LatLng(24.789900, -107.394550); // Noreste

  late final LatLngBounds _limitesDelMapa;
  LatLng? _ubicacionActual;
  StreamSubscription<Position>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _limitesDelMapa = LatLngBounds(_esquinaSW, _esquinaNE);
    _iniciarStreamUbicacion();
  }

  void _iniciarStreamUbicacion() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.low, // Ahorra batería
        distanceFilter: 20,             // Solo si te mueves 20m
        timeLimit: Duration(seconds: 10), // Actualiza máximo cada 10s
      ),
    ).listen((Position position) {
      if (!mounted) return;
      setState(() {
        _ubicacionActual = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng _centro = LatLng(
      (_esquinaSW.latitude + _esquinaNE.latitude) / 2,
      (_esquinaSW.longitude + _esquinaNE.longitude) / 2,
    );

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.markerLabel ?? ""),
              backgroundColor: const Color(0xff1b3a6b),
              foregroundColor: Colors.white,
              elevation: 4,
            )
          : null,
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _centro,
          initialZoom: 17.5,
          minZoom: 16.0,
          maxZoom: 18.0,
          cameraConstraint: CameraConstraint.contain(
            bounds: _limitesDelMapa,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png?api_key=21de99ef-5734-4300-b4c5-1955a10789fa',
            userAgentPackageName: 'com.example.app_mapa_tec',
          ),
          OverlayImageLayer(
            overlayImages: [
              OverlayImage(
                bounds: _limitesDelMapa,
                imageProvider: const AssetImage('assets/images/Mapa_Tec.png'),
                opacity: 1.0,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              if (_ubicacionActual != null &&
                  _estaDentroDelArea(_ubicacionActual!))
                Marker(
                  width: 50.0,
                  height: 50.0,
                  point: _ubicacionActual!,
                  child: const Icon(
                    Icons.person_pin_circle,
                    color: Color(0xff1b3a6b),
                    size: 40.0,
                  ),
                ),
              if (widget.markerLocation != null &&
                  _estaDentroDelArea(widget.markerLocation!))
                Marker(
                  width: 50.0,
                  height: 50.0,
                  point: widget.markerLocation!,
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red[700],
                        size: 40.0,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _estaDentroDelArea(LatLng ubicacion) {
    return _limitesDelMapa.contains(ubicacion);
  }
}