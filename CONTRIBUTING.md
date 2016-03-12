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
