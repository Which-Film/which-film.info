library which_film.web_data_service;

import "dart:async";
import "dart:html";

import "package:which_film/data_service/common.dart";


/// Implementation of [TraktService] for the web.
class TraktWebService extends TraktService {
  @override
  Future<String> fetch(String url) async {
    var response = await HttpRequest.request(
      url,
      requestHeaders: TraktService.requestHeaders
    );
    // TODO: check for errors.
    return response.responseText;
  }
}
