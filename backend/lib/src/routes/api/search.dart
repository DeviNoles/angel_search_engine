import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_validate/server.dart';
import 'package:charcode/ascii.dart';
import 'package:engine/engine.dart';
import 'stop_words.dart';

final stopWords = wordPartsRaw(stopWordsString);

List<String> wordPartsRaw(String input) {
  return input
      .toLowerCase()
      .split(new RegExp(r'([ \n\r\t]|\W)+'))
      .map((s) {
        // Remove non-alphanumeric text
        var b = new StringBuffer();

        for (var ch in s.codeUnits) {
          if ((ch >= $0 && ch <= $9) ||
              (ch >= $A && ch <= $Z) ||
              (ch >= $a && ch <= $z)) {
            b.writeCharCode(ch);
          }
        }

        return b.toString();
      })
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();
}

List<String> wordParts(String input) {
  return wordPartsRaw(input).where((x) => !stopWords.contains(x)).toList();
}

RequestHandler search(Service<String, WebPage> service) {
  var resolver = searchResolver(service);

  return chain([
    autoParseQuery(['max_results']),
    validateQuery(new Validator({
      'query*': isNonEmptyString,
      'max_results': [isInt, greaterThan(0)],
    })),
    (req, res) async {
      var params = await req.parseQuery();
      return resolver(params);
    },
  ]);
}

Future<SearchResults> Function(Map<String, dynamic>) searchResolver(
    Service<String, WebPage> service) {
  return (params) async {
    var maxResults = params['max_results'] as int ?? 10;
    var sw = new Stopwatch()..start();
    var query = params['query'] as String;
    var queryParts = wordParts(query);
    var pointsPerWord = 1 / queryParts.length;
    var resultss = new Set<SearchResult>();

    for (var webPage in await service.index()) {
      var score = 0.0;

      void doScore(String ref, bool asTitle) {
        var parts = wordParts(ref ?? '');
        var points = asTitle ? pointsPerWord * 2 : pointsPerWord;
        var matches =
            queryParts.where((x) => parts.any((s) => s.contains(x))).length;
        score += matches * points;
      }

      // Apply scoring.
      doScore(webPage.title, true);
      doScore(webPage.author, true);
      doScore(webPage.keywordString, true);
      doScore(webPage.description, true);
      doScore(webPage.decodedContents, false);
      doScore(webPage.url, false);

      // Return the result if there were any match.
      if (score > 0.0) {
        resultss.add(
          new SearchResult(
            author: webPage.author,
            description: webPage.description,
            score: score,
            title: webPage.title,
            url: webPage.url,
          ),
        );
      }
    }

    // Sort the results by score.
    var results = resultss.toList()..sort((a, b) => b.score.compareTo(a.score));

    sw.stop();

    return new SearchResults(
        ms: sw.elapsedMilliseconds, items: results.take(maxResults).toList());
  };
}
