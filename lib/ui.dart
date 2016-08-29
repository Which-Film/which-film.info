library which_film.ui;

import "dart:async";

import 'package:angular2/angular2.dart';
import 'package:usage/usage.dart';

import 'package:which_film/data_service/common.dart';
import 'package:which_film/data_service/web.dart';
import 'package:which_film/data_search.dart';
import 'package:which_film/processing.dart';

@Component(
    selector: 'which-film',
    template: '''
    <div class="mdl-grid">
      <div class="mdl-cell mdl-cell--3-col">
        <div class="mdl-textfield mdl-js-textfield">
          <input
                class="mdl-textfield__input" type="text" #username id="username"
                (keypress)="handleUsernameInput(\$event, username);" autofocus>
          <label class="mdl-textfield__label" for="username">Trakt.tv username</label>
        </div>
        <button
              class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect"
              (click)="addUser(username.value); username.value='' ">
            Add user
        </button>
        <ul class="mdl-list">
          <li *ngFor="let user of users" class="mdl-list__item">
            <span class="mdl-list__item-primary-content" [style.color]="getLoadingStateColor(user)">
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
          <li *ngFor="let movie of movies">
            {{ movie }}
          </li>
        </ol>
      </div>
    </div>
''')
class AppComponent {
  TraktService _client = new TraktWebService();
  Set<UserData> data = new Set();
  List<Movie> movies = [];
  List<String> users = [];
  Analytics ga;

  AppComponent() {
    analytics().then((ga) => ga.sendScreenView('home'));
  }

  Future<Analytics> analytics() async {
    bool isChecked = false;
    assert((isChecked = true));
    if (ga == null && !isChecked) {
      ga = await Analytics.create('UA-303429-25', 'which-film', '0.1');
    } else {
      ga = new AnalyticsMock();
    }

    return ga;
  }

  addUser(userName) {
    users.add(userName);
    analytics().then((ga) => ga.sendEvent('Username', 'add'));
    _client.fetchData(userName).then((userData) {
      data.add(userData);
      if (users.length > 1) {
        movies = processMovies(data);
      }
    });
  }

  removeUser(userName) {
    users = users.where((f) => f != userName).toList();
    data.removeWhere((x) => x.username == userName);
    analytics().then((ga) => ga.sendEvent('Username', 'remove'));
    if (users.length < 1) {
      movies = [];
    } else {
      movies = processMovies(data);
    }
  }

  handleUsernameInput(event, userName) {
    if (event.keyCode == 13) {
      addUser(userName.value);
      userName.value = '';
    }
  }

  String getLoadingStateColor(user) {
    Iterable<UserData> userDataResult = data.where((x) => x.username == user);
    if (userDataResult.isEmpty) {
      return 'grey';
    } else if (userDataResult.first.watchlist == null) {
      return 'red';
    } else {
      return 'black';
    }
  }
}
