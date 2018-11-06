// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class SearchResultSerializer {
  static SearchResult fromMap(Map map) {
    if (map['title'] == null) {
      throw new FormatException(
          "Missing required field 'title' on SearchResult.");
    }

    if (map['description'] == null) {
      throw new FormatException(
          "Missing required field 'description' on SearchResult.");
    }

    if (map['author'] == null) {
      throw new FormatException(
          "Missing required field 'author' on SearchResult.");
    }

    if (map['url'] == null) {
      throw new FormatException(
          "Missing required field 'url' on SearchResult.");
    }

    if (map['score'] == null) {
      throw new FormatException(
          "Missing required field 'score' on SearchResult.");
    }

    return new SearchResult(
        title: map['title'] as String,
        description: map['description'] as String,
        author: map['author'] as String,
        url: map['url'] as String,
        score: map['score'] as double);
  }

  static Map<String, dynamic> toMap(SearchResult model) {
    if (model == null) {
      return null;
    }
    if (model.title == null) {
      throw new FormatException(
          "Missing required field 'title' on SearchResult.");
    }

    if (model.description == null) {
      throw new FormatException(
          "Missing required field 'description' on SearchResult.");
    }

    if (model.author == null) {
      throw new FormatException(
          "Missing required field 'author' on SearchResult.");
    }

    if (model.url == null) {
      throw new FormatException(
          "Missing required field 'url' on SearchResult.");
    }

    if (model.score == null) {
      throw new FormatException(
          "Missing required field 'score' on SearchResult.");
    }

    return {
      'title': model.title,
      'description': model.description,
      'author': model.author,
      'url': model.url,
      'score': model.score
    };
  }
}

abstract class SearchResultFields {
  static const List<String> allFields = const <String>[
    title,
    description,
    author,
    url,
    score
  ];

  static const String title = 'title';

  static const String description = 'description';

  static const String author = 'author';

  static const String url = 'url';

  static const String score = 'score';
}
