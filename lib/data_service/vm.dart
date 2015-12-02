library which_film.data_service;

import "dart:async";

import "package:http/http.dart" as http;

import "package:which-film/data_service/common.dart";

/// Implementation of [TraktService] for use with the Dart VM.
class TraktVmService extends TraktService {
  http.Client _client = new http.Client();

  void close() {
    _client.close();
  }

  Future<String> fetchWatchlist(String username) async {
    var url = watchlistUrl(username);
    var response = await _client.get(url, headers: TraktService.requestHeaders);
    // TODO: check for error cases.
    return response.body;
  }
}
