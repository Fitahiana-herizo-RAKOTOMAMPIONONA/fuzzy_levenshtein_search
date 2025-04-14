class LevenshteinResult {
  final String word;
  final int distance;

  LevenshteinResult({required this.word, required this.distance});
}

class LevenshteinSearch {
  final List<String> dataset;
  final bool caseSensitive;
  final int maxDistance;

  LevenshteinSearch({
    required this.dataset,
    this.caseSensitive = false,
    this.maxDistance = 3,
  });

  List<LevenshteinResult> search(String query, {int? limit}) {
    String normalizedQuery = _normalize(query);

    final results = <LevenshteinResult>[];

    for (var item in dataset) {
      final normalizedItem = _normalize(item);
      final distance = _levenshteinDistance(normalizedQuery, normalizedItem);

      if (distance <= maxDistance) {
        results.add(LevenshteinResult(word: item, distance: distance));
      }
    }

    results.sort((a, b) => a.distance.compareTo(b.distance));
    return limit != null ? results.take(limit).toList() : results;
  }

  String _normalize(String input) {
    return caseSensitive ? input : input.toLowerCase();
  }

  int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<List<int>> matrix = List.generate(
      s1.length + 1,
      (_) => List.filled(s2.length + 1, 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        int cost = s1[i - 1] == s2[j - 1] ? 0 : 1;

        matrix[i][j] = [
          matrix[i - 1][j] + 1,      // suppression
          matrix[i][j - 1] + 1,      // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[s1.length][s2.length];
  }
}
