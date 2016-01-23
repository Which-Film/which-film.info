/**
 * To test locally:
 * > pub serve
 * > open -a "Google Chrome" --args "--disable-web-security"
 */
library which_film.ui;

import 'dart:async';

import 'package:angular2/angular2.dart';

import 'package:which-film/data_service/common.dart';
import 'package:which-film/data_service/web.dart';
import 'package:which-film/data_search.dart';


@Component(selector: 'which-film')
@View(
    template: '''
    <input #username1>
    <input #username2>
    <input #username3>
    <input #username4>
    <button (click)="fetchMovies([username1.value, username2.value, username3.value, username4.value])">Find movies</button>
    <ol>
      <li *ng-for="#movie of movies">
        {{ movie }}
      </li>
    </ol>
''', directives: const [NgFor])
class AppComponent {
  Iterable<Movie> movies = [];

  fetchMovies(List<String> users) {
      var traktClient = new TraktWebService();
      users = users.where((username) => username.isNotEmpty).toList();
      var movieFutures = users.map(traktClient.fetchData);
      Future.wait(movieFutures)
        .then((userDataIterable) {
          var data = {};
          for (UserData userData in userDataIterable) {
            updateMovies(data, userData.watchlist, WhyChosen.watchlist);
            updateMovies(data, userData.ratings[8], WhyChosen.rating08);
            updateMovies(data, userData.ratings[9], WhyChosen.rating09);
            updateMovies(data, userData.ratings[10], WhyChosen.rating10);
            userData.lastWatched.forEach((m, d) {
              if (data.containsKey(m)) {
                var movie = data[m];
                if (movie.lastWatched == null) {
                  movie.lastWatched = d;
                } else if (movie.lastWatched.isBefore(d)) {
                    movie.lastWatched = d;
                }
              }
            });
          }

          var thisYear = (new DateTime.now()).year;
          var acceptableMovies = data.values.where(
            (m) => m.numberOfReasons > 1 && m.year <= thisYear)
            .toList();
          acceptableMovies.sort((x, y) => x.compareTo(y) * -1);
          movies = acceptableMovies;
      });
  }
}
