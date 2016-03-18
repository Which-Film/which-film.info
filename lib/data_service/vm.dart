library which_film.vm_data_service;

import "dart:async";

import "package:http/http.dart" as http;

import "package:which_film/data_service/common.dart";

/// Implementation of [TraktService] for use with the Dart VM.
class TraktVmService extends TraktService {
  http.Client _client = new http.Client();

  void close() {
    _client.close();
  }

  @override
  Future<String> fetch(String url) async {
    var response = await _client.get(url, headers: TraktService.requestHeaders);
    if (response.statusCode >= 300) {
      return null;
    }
    return response.body;
  }
}
