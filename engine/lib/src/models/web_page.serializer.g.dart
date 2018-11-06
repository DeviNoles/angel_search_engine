// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_page.dart';

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class WebPageSerializer {
  static WebPage fromMap(Map map) {
    if (map['title'] == null) {
      throw new FormatException("Missing required field 'title' on WebPage.");
    }

    if (map['contents'] == null) {
      throw new FormatException(
          "Missing required field 'contents' on WebPage.");
    }

    if (map['keyword_string'] == null) {
      throw new FormatException(
          "Missing required field 'keyword_string' on WebPage.");
    }

    return new WebPage(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        url: map['url'] as String,
        contents: map['contents'] as String,
        author: map['author'] as String,
        keywordString: map['keyword_string'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null);
  }

  static Map<String, dynamic> toMap(WebPage model) {
    if (model == null) {
      return null;
    }
    if (model.title == null) {
      throw new FormatException("Missing required field 'title' on WebPage.");
    }

    if (model.contents == null) {
      throw new FormatException(
          "Missing required field 'contents' on WebPage.");
    }

    if (model.keywordString == null) {
      throw new FormatException(
          "Missing required field 'keyword_string' on WebPage.");
    }

    return {
      'id': model.id,
      'title': model.title,
      'description': model.description,
      'url': model.url,
      'contents': model.contents,
      'author': model.author,
      'keyword_string': model.keywordString,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class WebPageFields {
  static const List<String> allFields = const <String>[
    id,
    title,
    description,
    url,
    contents,
    author,
    keywordString,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String title = 'title';

  static const String description = 'description';

  static const String url = 'url';

  static const String contents = 'contents';

  static const String author = 'author';

  static const String keywordString = 'keyword_string';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
