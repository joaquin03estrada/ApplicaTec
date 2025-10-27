import 'dart:async';
import 'package:applicatec/Helpers/salon_sidebar_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MyMap extends StatefulWidget {
  final LatLng? markerLocation;
  final String? markerLabel;
  final bool showDrawerBackButton;

  const MyMap({
    Key? key,
    this.markerLocation,
    this.markerLabel,
    this.showDrawerBackButton = false,
  }) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> with AutomaticKeepAliveClientMixin {
  final LatLng _esquinaSW = const LatLng(24.784875, -107.401350);
  final LatLng _esquinaNE = const LatLng(24.789900, -107.394550);
  final MapController _mapController = MapController();
  
  late final LatLngBounds _limitesDelMapa;
  LatLng? _ubicacionActual;
  StreamSubscription<Position>? _positionSubscription;
  bool _mounted = true;

  final Map<String, LatLng> salonesUbicaciones = {
    "EA01": LatLng(24.788967, -107.398021),
    "EA02": LatLng(24.788967, -107.398021),
    "EA03": LatLng(24.788967, -107.398021),
    "EB01": LatLng(24.788691, -107.398094),
    "EB02": LatLng(24.788691, -107.398094),
    // ... más salones
  };

  LatLng? _selectedSalonLocation;
  String? _selectedSalonLabel;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    _limitesDelMapa = LatLngBounds(_esquinaSW, _esquinaNE);
    _iniciarStreamUbicacion();
    
    // Usar un delay más corto para evitar problemas de timing
    if (widget.markerLocation != null) {
      // Retrasar el zoom inicial para evitar problemas
      Future.delayed(Duration(milliseconds: 500), () {
        if (_mounted) _hacerZoom(widget.markerLocation!);
      });
    }
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
        accuracy: LocationAccuracy.low,
        distanceFilter: 20,
        timeLimit: Duration(seconds: 10),
      ),
    ).listen((Position position) {
      if (!_mounted) return;
      
      setState(() {
        _ubicacionActual = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  void deactivate() {
    _mounted = false;
    super.deactivate();
  }

  @override
  void dispose() {
    _mounted = false;
    _positionSubscription?.cancel();
    super.dispose();
  }

  void _seleccionarSalon(String salon) {
    if (!_mounted) return;
    
    setState(() {
      _selectedSalonLocation = salonesUbicaciones[salon];
      _selectedSalonLabel = salon;
    });
    
    //Zoom Salon
    if (_selectedSalonLocation != null) {
      _hacerZoom(_selectedSalonLocation!);
    }
  }

  //Zoom
  void _hacerZoom(LatLng location) {
    if (!_mounted) return;
    
    try {
      _mapController.move(location, 18.0);
    } catch (e) {
      print("Error al hacer zoom: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    
    final LatLng _centro = LatLng(
      (_esquinaSW.latitude + _esquinaNE.latitude) / 2,
      (_esquinaSW.longitude + _esquinaNE.longitude) / 2,
    );

    return WillPopScope(
      onWillPop: () async {
        _mounted = false;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.markerLabel ?? ""),
          backgroundColor: const Color(0xff1b3a6b),
          foregroundColor: Colors.white,
          elevation: 4,
          leading: widget.showDrawerBackButton
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _mounted = false; // Marcar como desmontado antes de navegar
                    Navigator.pop(context);
                  },
                )
              : Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
        ),
        drawer: widget.showDrawerBackButton
            ? null
            : SalonSidebarDrawer(
                salonesUbicaciones: salonesUbicaciones,
                onSalonSelected: _seleccionarSalon,
              ),
        body: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _selectedSalonLocation ?? widget.markerLocation ?? _centro,
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
                if (_ubicacionActual != null && _estaDentroDelArea(_ubicacionActual!))
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
                if ((_selectedSalonLocation != null && _estaDentroDelArea(_selectedSalonLocation!)))
                  Marker(
                    width: 50.0,
                    height: 50.0,
                    point: _selectedSalonLocation!,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red[700],
                      size: 40.0,
                    ),
                  ),
                if (widget.markerLocation != null && _estaDentroDelArea(widget.markerLocation!))
                  Marker(
                    width: 50.0,
                    height: 50.0,
                    point: widget.markerLocation!,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red[700],
                      size: 40.0,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _estaDentroDelArea(LatLng ubicacion) {
    return _limitesDelMapa.contains(ubicacion);
  }
}