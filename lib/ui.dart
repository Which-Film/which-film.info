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
              (click)="addUser(username.value); username.value='' ">
            Add user
        </button>
        <ul class="mdl-list">
          <li *ngFor="#user of users" class="mdl-list__item">
            <span class="mdl-list__item-primary-content">
            {{ user }}
            </span>
            <button
                class="mdl-button mdl-js-button mdl-button--icon"
                (click)="removeUser(user)">
              <i class="material-icons">remove</i>
            </button>
          </li>
        </ul>
      </div>
      <div class="mdl-cell mdl-cell--9-col">
        <ol>
          <li *ngFor="#movie of movies">
            {{ movie }}
          </li>
        </ol>
      </div>
    </div>
''')
class AppComponent {
  List<Movie> movies = [];
  List<String> users = [];

  fetchMovies(List<String> users) {
    var client = new TraktWebService();
    users = users.where((username) => username.isNotEmpty).toList();
    void process(Iterable<ChosenMovie> acceptableMovies) {
      movies = acceptableMovies.toList();
    }

    driver(client, users, process);
  }

  addUser(userName) {
    users.add(userName);
    if (users.length > 1) {
      fetchMovies(users);
    }
  }

  removeUser(userName) {
    users = users.where((f) => f != userName);
    users.length > 1 ? fetchMovies(users) : movies = [];
  }
}
