import 'package:flutter_test/flutter_test.dart';
import 'package:fuzzy_levenshtein_search/src/levenshtein.dart';


void main() {
  final searcher = LevenshteinSearch(
    dataset: ['pomme', 'banane', 'orange', 'raisin', 'pastèque'],
    maxDistance: 2,
    caseSensitive: false,
  );

  group('Base tests', () {
    test('Search with one close match', () {
      final results = searcher.search('pamme');
      expect(results.length, 1);
      expect(results.first.word, 'pomme');
      expect(results.first.distance, 1);
    });

    test('Search with no matches', () {
      final results = searcher.search('xyz');
      expect(results.isEmpty, true);
    });

    test('Search with multiple matches', () {
      final results = searcher.search('bana');
      expect(results.isNotEmpty, true);
      expect(results.first.word, 'banane');
    });

    test('Search with case insensitivity', () {
      final results = searcher.search('POMME');
      expect(results.length, 1);
      expect(results.first.word, 'pomme');
    });

    test('Search with exact match', () {
      final results = searcher.search('orange');
      expect(results.length, 1);
      expect(results.first.word, 'orange');
      expect(results.first.distance, 0);
    });

    test('Search with maxDistance exceeded', () {
      final results = searcher.search('past');
      expect(results.isEmpty, true);
    });
  });

  group('Advanced and edge cases', () {
    test('Search with limit applied', () {
      final results = searcher.search('pamme', limit: 1);
      expect(results.length, 1);
      expect(results.first.word, 'pomme');
    });

    test('Search returns results sorted by distance', () {
      final results = searcher.search('anane');
      for (int i = 1; i < results.length; i++) {
        expect(results[i].distance >= results[i - 1].distance, true);
      }
    });

    test('Search on empty dataset returns empty list', () {
      final emptySearcher = LevenshteinSearch(dataset: []);
      final results = emptySearcher.search('test');
      expect(results.isEmpty, true);
    });

    test('Search with empty query returns distance equal to word length', () {
      final results = searcher.search('');
      for (var result in results) {
        expect(result.distance, result.word.length);
      }
    });

    test('Search respects case sensitivity when enabled', () {
      final caseSearcher = LevenshteinSearch(
        dataset: ['Pomme', 'pomme'],
        caseSensitive: true,
      );
      final results = caseSearcher.search('pomme');
      expect(results.length, 2);
      expect(results.first.word, 'pomme');
    });

    test('Search with accented characters', () {
      final accentedSearcher = LevenshteinSearch(
        dataset: ['café', 'cafes'],
        caseSensitive: false,
      );
      final results = accentedSearcher.search('cafe');
      expect(results.any((r) => r.word == 'café'), true);
    });

    test('Identical words should return distance 0', () {
      final results = searcher.search('pomme');
      expect(results.first.distance, 0);
    });
  });
}
