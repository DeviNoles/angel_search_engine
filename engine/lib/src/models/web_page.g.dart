// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_page.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class WebPage extends _WebPage {
  WebPage(
      {this.id,
      @required this.title,
      this.description,
      this.url,
      @required this.contents,
      this.author,
      @required this.keywordString,
      this.createdAt,
      this.updatedAt});

  @override
  final String id;

  @override
  final String title;

  @override
  final String description;

  @override
  final String url;

  @override
  final String contents;

  @override
  final String author;

  @override
  final String keywordString;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  WebPage copyWith(
      {String id,
      String title,
      String description,
      String url,
      String contents,
      String author,
      String keywordString,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new WebPage(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        url: url ?? this.url,
        contents: contents ?? this.contents,
        author: author ?? this.author,
        keywordString: keywordString ?? this.keywordString,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _WebPage &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.url == url &&
        other.contents == contents &&
        other.author == author &&
        other.keywordString == keywordString &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      title,
      description,
      url,
      contents,
      author,
      keywordString,
      createdAt,
      updatedAt
    ]);
  }

  Map<String, dynamic> toJson() {
    return WebPageSerializer.toMap(this);
  }
}
