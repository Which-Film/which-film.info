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


@Component(
  selector: 'which-film',
  template: '''
    <div class="mdl-grid">
      <div class="mdl-cell mdl-cell--3-col">
        <div class="mdl-textfield mdl-js-textfield">
          <input class="mdl-textfield__input" type="text" #username1 id="username1">
          <label class="mdl-textfield__label" for="username1">Trakt.tv username</label>
        </div>
      </div>
      <div class="mdl-cell mdl-cell--3-col">
        <div class="mdl-textfield mdl-js-textfield">
          <input class="mdl-textfield__input" type="text" #username2 id="username2">
          <label class="mdl-textfield__label" for="username2">Another username</label>
        </div>
      </div>
      <div class="mdl-cell mdl-cell--3-col">
        <div class="mdl-textfield mdl-js-textfield">
          <input class="mdl-textfield__input" type="text" #username3 id="username3">
          <label class="mdl-textfield__label" for="username3">Another (optional) username</label>
        </div>
      </div>
      <div class="mdl-cell mdl-cell--3-col">
        <div class="mdl-textfield mdl-js-textfield">
          <input class="mdl-textfield__input" type="text" #username4 id="username4">
          <label class="mdl-textfield__label" for="username4">Yet another (optional) username</label>
        </div>
      </div>
    </div>

    <div class="mdl-grid">
      <div class="mdl-cell mdl-call--12-col">
        <button
              class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect"
              (click)="fetchMovies([username1.value, username2.value, username3.value, username4.value])">
            Find movies
        </button>
      </div>
    </div>

    <div class="mdl-grid">
      <div class="mdl-cell mdl-call--12-col">
        <ol>
          <li *ngFor="#movie of movies">
            {{ movie }}
          </li>
        </ol>
      </div>
    </div>
''')
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
