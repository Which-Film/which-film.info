// pub run test test/data_search_test.dart

import "package:which-film/data_service/vm.dart";

import "package:test/test.dart";

void main() {
  group("Trakt VM data service", () {
    test("watchlist network request", () async {
      var client = new TraktVmService();
      var movies = await client.watchlist("brettcannon");
      client.close();

      expect(movies.length, greaterThan(0));
      var movie = movies.first;
      expect(movie.title.length, greaterThan(0));
      expect(movie.year, greaterThan(1900));
      var uri = Uri.parse(movie.url);
      expect(uri.isAbsolute, isTrue);
    });

    test("rating network request", () async {
      var client = new TraktVmService();
      var ratings = await client.ratings("brettcannon");
      client.close();

      expect(ratings.length, greaterThan(0));
      ratings.forEach((m, r) {
        expect(r, greaterThanOrEqualTo(1));
        expect(r, lessThanOrEqualTo(10));
      });
    });
  });
}
