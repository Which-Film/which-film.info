# Contributing to Which Film
## Code of Conduct
This project follows the latest code of conduct found at
http://contributor-covenant.org/.

## Proposing changes
Please open an issue for discussing any UX changes prior to sending a
pull request. This allows for proper discussion before any coding work
begins in case the idea is ultimately rejected.

## Testing
### Unit tests
`grind test`.

### In-browser, manual testing
`grind browser`.

### Code coverage
If you run the test suite under
[Observatory](https://dart-lang.github.io/observatory/), you can get
code coverage: `grind observe_tests`. This will launch Chrome
with the Observatory page open. You will find a link called
`all.dart$main`. If you click on it you will see at the bottom of the
next page the source code for `test/all.dart`. You can then click
through the import lines to look at the source code of the various
Dart source files that were executed. This view of the source code
includes colour-coded line numbers denoting code coverage.

When you're done viewing using Observatory, just Ctrl-C the test
process/isolate.


## Deployment
Run `grind deploy`.

## Coding in Dart
### Style enforcement
`grind format`.

### Static analysis
`grind analyze`.

### Editors
#### Visual Studio Code
There is a
[Dart extension](https://marketplace.visualstudio.com/items?itemName=kevinplatel.dart).

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

