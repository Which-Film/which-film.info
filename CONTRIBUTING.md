# Contributing to Which Film
## Code of Conduct
This project follows the latest code of conduct found at
http://contributor-covenant.org/.

## Testing
### Unit tests
`pub run test` (you can specify individual test files if you want).

### Manual testing
If you are simply testing networking code, you can use
`pub run -c bin/which-film.dart` and follow it with a list of Trakt
usernames (e.g.,
`pub run -c bin/which-film.dart brettcannon kschmidt`).

If you need to test the web UI, then use `pub serve` to start a local
web server (make sure to use the non-test URL!).
Then use a web browser where the same origin policy has been turned
off, e.g., `open -a "Google Chrome" --args "--disable-web-security"`
on OS X.

## Deployment
Run `surge.sh`.

## Coding in Dart
### Style enforcement
The [`dart_style` tool](https://pub.dartlang.org/packages/dart_style)
from the Dart team helps enforce style usage.

### Editors
#### Visual Studio Code
There is a
[third-party extension](https://marketplace.visualstudio.com/items?itemName=kevinplatel.dart),
but it seemed buggy on last use (this was VS Code 0.10.10 w/
0.0.6 of the plugin).

#### Atom
Use the [dartlang package](https://atom.io/packages/dartlang) which
comes from the Dart team.

#### Sublime Text
There is a very good
[third-party package](https://packagecontrol.io/packages/Dart)
available through [Package Control](https://packagecontrol.io/). Do
make sure to follow the
[configuration instructions](https://github.com/guillermooo/dart-sublime-bundle/wiki/Installation%20and%20Basic%20Configuration)
as they tell you how to set your package settings to point to the
installation of the Dart SDK (**not** your personal settings and
**not** the Dart binary).

