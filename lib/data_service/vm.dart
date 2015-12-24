library which_film.vm_data_service;

import "dart:async";

import "package:http/http.dart" as http;

import "package:which-film/data_service/common.dart";

/// Implementation of [TraktService] for use with the Dart VM.
class TraktVmService extends TraktService {
  http.Client _client = new http.Client();

  void close() {
    _client.close();
  }

  Future<String> _fetch(String url) async {
    var response = await _client.get(url, headers: TraktService.requestHeaders);
    // TODO: check for error cases.
    return response.body;
  }

  @override
  Future<String> fetchWatchlist(String username) async {
    return _fetch(watchlistUrl(username));
  }

  @override
  Future<String> fetchRatings(String username) async {
    return _fetch(ratingsUrl(username));
  }

  @override
  Future<String> fetchLastWatched(String username) async {
    return _fetch(lastWatchedUrl(username));
  }
}
