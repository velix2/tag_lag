

import 'dart:convert';
import 'package:http/http.dart' as http;

class MVGApiHandler {
  List<Station> stations_u_bahn = [];
  List<Station> stations_s_bahn = [];
  List<Station> stations_bus = [];
  List<Station> stations_tram = [];
  List<Station> stations_bahn = [];

  Future<List<Station>> fetchStationsCloseBy(double latitude, double longitude) async {
    final response = await http.get(Uri.parse("https://www.mvg.de/api/fib/v2/station/nearby?latitude=$latitude&longitude=$longitude"));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      final List<Station> list = jsonData.map<Station>((e) => Station.fromJson(e)).toList();
      return list;
    } else {
      throw Exception("Failed to load data - Status Code ${response.statusCode}");
    }
  }

  List<Station> getAllStations(TransportType transportType) {
    switch (transportType) {
      case TransportType.U_BAHN:
        return stations_u_bahn;
      case TransportType.S_BAHN:
        return stations_s_bahn;
      case TransportType.BUS:
        return stations_bus;
      case TransportType.TRAM:
        return stations_tram;
      case TransportType.BAHN:
        return stations_bahn;
    }
  }

  static void test() {
  print("starting");
  MVGApiHandler().fetchStationsCloseBy(48.11001119152642, 11.598830690656754).then((value) => value.where((element) => element.transportTypes.contains(TransportType.U_BAHN)).forEach((element) {
    print(element);
  }));
}

}

class Station {
  final double latitude;
  final double longitude;
  final String name;
  late final List<TransportType> transportTypes;
  final int distanceInMeters;

  Station(
    this.latitude,
    this.longitude,
    this.name,
    this.transportTypes,
    this.distanceInMeters,
  );

  factory Station.fromJson(Map<String, dynamic> json) {
    var transportTypes = <TransportType>[];
    for (var type in json['transportTypes']) {
      switch (type) {
        case 'UBAHN':
          transportTypes.add(TransportType.U_BAHN);
          break;
        case 'SBAHN':
          transportTypes.add(TransportType.S_BAHN);
          break;
        case 'BUS':
          transportTypes.add(TransportType.BUS);
          break;
        case 'TRAM':
          transportTypes.add(TransportType.TRAM);
          break;
        case 'BAHN':
          transportTypes.add(TransportType.BAHN);
          break;
      }
    }

    return Station(
      json['latitude'] as double,
      json['longitude'] as double,
      json['name'] as String,
      transportTypes,
      json['distanceInMeters'] as int,
    );
  }

  @override
  String toString() {
    return '[Station: $name\n'
        'Latitude: $latitude\n'
        'Longitude: $longitude\n'
        'Transport Types: $transportTypes\n'
        'Distance: $distanceInMeters meters]';
  }
}

enum TransportType {
  U_BAHN,
  S_BAHN,
  BUS,
  TRAM,
  BAHN,
}

void main(List<String> args) {
  MVGApiHandler.test();
}

