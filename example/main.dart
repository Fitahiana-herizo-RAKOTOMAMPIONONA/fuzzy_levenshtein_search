import 'package:fuzzy_levenshtein_search/src/levenshtein.dart';

void main() {
  final searcher = LevenshteinSearch(
    dataset: ['pomme', 'banane', 'orange', 'raisin', 'pastèque'],
    maxDistance: 2,
    caseSensitive: false
  );

  final results = searcher.search('pamme');

  for (var result in results) {
    // ignore: avoid_print
    print('Suggestion: ${result.word} (distance: ${result.distance})');
  }
}
