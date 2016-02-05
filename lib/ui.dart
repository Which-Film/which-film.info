/**
 * To test locally:
 * > pub serve
 * > open -a "Google Chrome" --args "--disable-web-security"
 */
library which_film.ui;

import 'package:angular2/angular2.dart';

import 'package:which_film/data_service/web.dart';
import 'package:which_film/data_search.dart';
import 'package:which_film/main.dart';


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
      var client = new TraktWebService();
      users = users.where((username) => username.isNotEmpty).toList();
      void process(Iterable<ChosenMovie> acceptableMovies) {
        movies = acceptableMovies;
      }

      driver(client, users, process);
    }
}
