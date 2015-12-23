// pub run test test/data_search_test.dart

import "package:which-film/data_service/vm.dart";

import "package:test/test.dart";

void main() {
  group("Trakt VM data service", () {
    test("live network request", () async {
      var client = new TraktVmService();
      var movies = await client.watchlist("brettcannon");

      expect(movies.length, greaterThan(0));
    });
  });
}
