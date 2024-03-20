// ignore_for_file: constant_identifier_names

class DevEnvironment {
  final receiveTimeout = 2 * 60 * 1000;
  final connectTimeout = 2 * 60 * 1000;
}

// class LocationApi {
//   // ignore: non_constant_identifier_names
//   static String BASE_URL =
//       "https://www.googleapis.com/geolocation/v1/geolocate?key=";
// }

class WordApi {
  static String BASE_URL = "https://api.dictionaryapi.dev/api/v2/entries/en/<word>";
}

final environment = DevEnvironment();

enum MethodType { GET, POST }
