import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MyMap extends StatefulWidget {
  final LatLng? markerLocation;
  final String? markerLabel;

  const MyMap({super.key, this.markerLocation, this.markerLabel});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final LatLng _esquinaSW = const LatLng(24.784875, -107.401350); // Suroeste
  final LatLng _esquinaNE = const LatLng(24.789900, -107.394550); // Noreste

  late final LatLngBounds _limitesDelMapa;
  LatLng? _ubicacionActual;

  @override
  void initState() {
    super.initState();
    _limitesDelMapa = LatLngBounds(_esquinaSW, _esquinaNE);
    _obtenerUbicacionActual();
  }

  Future<void> _obtenerUbicacionActual() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _ubicacionActual = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng _centro = LatLng(
      (_esquinaSW.latitude + _esquinaNE.latitude) / 2,
      (_esquinaSW.longitude + _esquinaNE.longitude) / 2,
    );

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _centro,
          initialZoom: 17.5,
          minZoom: 16.0,
          maxZoom: 18.0,
          cameraConstraint: CameraConstraint.contain(
            bounds: _limitesDelMapa, // Restringe la cámara
          ),
        ),
        children: [
          // 1. Capa base
          TileLayer(
            urlTemplate:
                'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png?api_key=21de99ef-5734-4300-b4c5-1955a10789fa',
            userAgentPackageName: 'com.example.app_mapa_tec',
          ),

          // 2. Imagen superpuesta
          OverlayImageLayer(
            overlayImages: [
              OverlayImage(
                bounds: _limitesDelMapa,
                imageProvider: const AssetImage('assets/images/Mapa_Tec.png'),
                opacity: 1.0,
              ),
            ],
          ),

          // 4. Marcador de ubicación
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
