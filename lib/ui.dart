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
          <input class="mdl-textfield__input" type="text" #username id="username">
          <label class="mdl-textfield__label" for="username">Trakt.tv username</label>
        </div>
        <button
              class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect"
              (click)="addUser(username)">
            Find movies
        </button>
        <ul class="mdl-list">
          <li *ngFor="#user of users" class="mdl-list__item">
            <span class="mdl-list__item-primary-content">
            {{ user }}
            </span>
          </li>
        </ul>
      </div>
      <div class="mdl-cell mdl-cell--3-col">
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
  Iterable<String> users = [];

  fetchMovies(List<String> users) {
    var client = new TraktWebService();
    users = users.where((username) => username.isNotEmpty).toList();
    void process(Iterable<ChosenMovie> acceptableMovies) {
      movies = acceptableMovies;
    }

    driver(client, users, process);
  }

  addUser(userName) {
    users = []..addAll(users)..add(userName.value);
    userName.value = "";
    if( users.length > 1 ) {
      fetchMovies(users);
    }
  }
}
