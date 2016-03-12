import "package:which_film/data_service/common.dart";
import "package:which_film/data_service/vm.dart";

import "package:test/test.dart";

void main() {
  var client = new TraktVmService();
  tearDownAll(client.close);
  group("UserData", () {
      test("all possible ratings have a set to begin with", () {
        var userData = new UserData(new Set(), new Map(), new Map());
        for (var x = 1; x <= 10; x++) {
          expect(userData.ratings, contains(x));
        }
      });
  });

  group("Trakt VM data service", () {
    test("watchlist network request", () async {
      var movies = await client.watchlist("brettcannon");

      expect(movies.length, greaterThan(0));
      var movie = movies.first;
      expect(movie.title.length, greaterThan(0));
      expect(movie.year, greaterThan(1900));
      var uri = Uri.parse(movie.url);
      expect(uri.isAbsolute, isTrue);
    });

    test("rating network request", () async {
      var ratings = await client.ratings("brettcannon");

      expect(ratings.length, greaterThan(0));
      ratings.forEach((r, movieSet) {
        expect(r, greaterThanOrEqualTo(1));
        expect(r, lessThanOrEqualTo(10));
      });
    });

    test("last watched network request", () async {
      var lastWatched = await client.lastWatched("brettcannon");
      expect(lastWatched.length, greaterThan(0));
    });
  });
}
