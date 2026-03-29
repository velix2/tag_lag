import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  List<List<LatLng>> geoData_city = [];
  List geoData_districts = [];

  Future<void> readGeoData() async {
    final String response_full = await rootBundle.loadString('assets/geo_data_full_reprojected.json');
    //final String response = await rootBundle.loadString('assets/geo_data_reprojected.json');
    final Map<String, dynamic> data_full = await json.decode(response_full);
    //final Map<String, dynamic> data = await json.decode(response);
    setState(() {
      List<LatLng> geoData_city_poly = [];
      for (var poly in data_full["geometry"]["coordinates"]) {
        geoData_city.add(
          geoData_city_poly = poly[0].map<LatLng>((e) {
              final lon = (e[0] as num).toDouble();
              final lat = (e[1] as num).toDouble();
              return LatLng(lat, lon);
            }).toList(),
        );
      }
    });
  }

  Position? position;

  @override
  void initState() {
    super.initState();
    loadLocation();
    readGeoData();
  }

  Future<void> loadLocation() async {

    await Geolocator.requestPermission();

    final pos = await Geolocator.getCurrentPosition();

    setState(() {
      position = pos;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (position == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.map,
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
            const SizedBox(width: 15),
            Text(
              "Map",
              style: GoogleFonts.righteous(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              ".",
              style: GoogleFonts.righteous(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(48.138217, 11.574995),
          initialZoom: 10.5,
          cameraConstraint: CameraConstraint.contain(bounds: LatLngBounds(LatLng(47.8, 11.2), LatLng(48.5, 11.9))),
          initialRotation: 0,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.maxmustermann.tag_lag",
          ),
          RichAttributionWidget(attributions: [TextSourceAttribution("OpenStreetMap contributors")]),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(position!.latitude, position!.longitude),
                width: 40,
                height: 40,
                child: Icon(Icons.location_pin, size: 40),
              ),
            ],
          ),
          PolygonLayer(polygons: [
            Polygon(
              points: [LatLng(47.8, 11.2), LatLng(47.8, 11.9), LatLng(48.5, 11.9), LatLng(48.5, 11.2)],
              isFilled: true,
              color: Colors.grey.withAlpha(200),
              holePointsList: geoData_city,
            ),
            for (var poly in geoData_city)
              Polygon(
                points: poly,
                isFilled: false,
                borderStrokeWidth: 2,
                borderColor: Colors.black
              )
          ])
        ]
      )
    );
  }
}
