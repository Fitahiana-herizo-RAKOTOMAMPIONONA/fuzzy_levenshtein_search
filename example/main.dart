import 'package:recherche_lenveistein/recherche_lenveistein.dart';

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
