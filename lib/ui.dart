library which_film.ui;

import 'dart:async';

import 'package:angular2/angular2.dart';

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
      var movieFutures = users.map(traktClient.watchlist);
      Future.wait(movieFutures)
        .then((movieData) {
          var data = {};
          for (var i = 0; i < users.length; i++) {
            data[users[i]] = movieData[i];
          }
          movies = findMovies(data);
      });
  }
}
