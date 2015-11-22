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
  var usernames = new List.from(options.keys);
  for (var i = usernames.length; i >= 2; i--) {
    // Find all username combinations, from larget combinations to smallest
    // (where "smallest" is two usernames).
    for (var combo in combinations(usernames, i)) {
      var movies = combo.map((username) => options[username]);
      var matches = movies.reduce((x, y) => x.intersection(y));
      yield* matches.where((m) => m.year <= thisYear);
      options.values.forEach((s) => s.removeAll(matches));
    }
  }
}
