library which_film.web_data_service;

import "dart:async";
import "dart:html";

import "package:which-film/data_service/common.dart";


/// Implementation of [TraktService] for the web.
class TraktWebService extends TraktService {
  Future<String> fetchWatchlist(String username) async {
    var url = watchlistUrl(username);
    var response = await HttpRequest.request(
      url,
      requestHeaders: TraktService.requestHeaders
    );
    // TODO: check for errors.
    return response.responseText;
  }
}
