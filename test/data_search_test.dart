import "package:test/test.dart";
import "package:which-film/data_search.dart";

void main() {
  group("combinations", () {
    test("for two items", () {
        var options = new Set.from(["A", "B"]);
        var got = combinations(options.toSet(), 2).toSet();
        var want = new Set()
          ..add(new Set.from(["A", "B"]));
        expect(got, equals(want));
    });

    test("for three items", () {
      var options = new Set.from(["A", "B", "C"]);
      var got = combinations(options, 3).toSet();
      var want = new Set()
        ..add(new Set.from(["A", "B", "C"]));
      expect(got, equals(want));

      got = combinations(options, 2).toSet();
      want = new Set()
        ..add(new Set.from(["A", "B"]))
        ..add(new Set.from(["A", "C"]))
        ..add(new Set.from(["B", "C"]));
      expect(got, equals(want));
    });

    test("for four items", () {
      var options = new Set.from(["A", "B", "C", "D"]);
      var got = combinations(options, 4).toSet();
      var want = new Set()
        ..add(new Set.from(["A", "B", "C", "D"]));
      expect(got, equals(want));

      got = combinations(options, 3).toSet();
      want = new Set()
        ..add(new Set.from(["A", "B", "C"]))
        ..add(new Set.from(["A", "B", "D"]))
        ..add(new Set.from(["A", "C", "D"]))
        ..add(new Set.from(["B", "C", "D"]));
      expect(got, equals(want));

      got = combinations(options, 2).toSet();
      want = new Set()
        ..add(new Set.from(["A", "B"]))
        ..add(new Set.from(["A", "C"]))
        ..add(new Set.from(["A", "D"]))
        ..add(new Set.from(["B", "C"]))
        ..add(new Set.from(["B", "D"]))
        ..add(new Set.from(["C", "D"]));
      expect(got, equals(want));
    });
  });

  // XXX findMovies
}
