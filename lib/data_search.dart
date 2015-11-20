/// Metadata for a movie.
class Movie {
  final String title;
  final int year;
  final String url;

  const Movie(this.title, this.year, this.url);

  String toString() => "${title} (${year})";

  bool operator ==(other) {
    return other is Movie && title == other.title && year == other.year;
  }

  int get hashCode => toString().hashCode;
}


Iterable<Set<String>> combinations(Iterable<String> iterable, r) sync* {
  // Code ported from
  // https://docs.python.org/3/library/itertools.html#itertools.combinations
  final pool = new List.from(iterable);  // pool = tuple(iterable)
  final n = pool.length;  // n = len(pool)
  if (r > n) {  // if r > n:
    return;  // return
  }
  var indices = new List.generate(r, (index) => index);  // indices = list(range(r))
  final countDown = new List.from(indices.reversed);
  yield new Set.from(indices.map((index) => pool[index]));  // yield tuple(pool[i] for i in indices)
  while (true) {  // while True:
    var ok = false;
    var i;
    for (i in countDown) {  // for i in reversed(range(r)):
      if (indices[i] != i + n - r) {  // if indices[i] != i + n - r:
        ok = true;
        break;  // break
      }
    }
    if (!ok) {
      return;  // return
    }

    indices[i] += 1;  // indices[i] += 1
    for (var j = i + 1; j < r; j++) {  // for j in range(i+1, r):
      indices[j] = indices[j-1] + 1; // indices[j] = indices[j-1] + 1
    }
    yield new Set.from(indices.map((i) => pool[i]));  // yield tuple(pool[i] for i in indices)
  }
}


Iterable<Movie> findMovies(Map<String, Set<Movie>> options) sync* {
  final thisYear = new DateTime.now().year;
  var seen = new Set<String>();
  var usernames = new List.from(options.keys);
  for (var i = usernames.length; i >= 2; i--) {
    for (var combo in combinations(usernames, i)) {
      combo = combo.toList();
      var matches = options[combo.removeLast()];
      for (var username in combo) {
        matches = matches.intersection(options[username]);
      }
      for (var match in matches) {
        if (match.year > thisYear) {
          // Don't bother with movies that are only available in the future.
          seen.add(match.toString());
        }
        if (!seen.contains(match.toString())) {
          yield match;
          seen.add(match.toString());
        }
      }
    }
  }
}
