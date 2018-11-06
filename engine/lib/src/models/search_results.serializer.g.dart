// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_results.dart';

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class SearchResultsSerializer {
  static SearchResults fromMap(Map map) {
    if (map['ms'] == null) {
      throw new FormatException(
          "Missing required field 'ms' on SearchResults.");
    }

    if (map['items'] == null) {
      throw new FormatException(
          "Missing required field 'items' on SearchResults.");
    }

    return new SearchResults(
        ms: map['ms'] as int,
        items: map['items'] is Iterable
            ? new List.unmodifiable(((map['items'] as Iterable)
                    .where((x) => x is Map) as Iterable<Map>)
                .map(SearchResultSerializer.fromMap))
            : null);
  }

  static Map<String, dynamic> toMap(SearchResults model) {
    if (model == null) {
      return null;
    }
    if (model.ms == null) {
      throw new FormatException(
          "Missing required field 'ms' on SearchResults.");
    }

    if (model.items == null) {
      throw new FormatException(
          "Missing required field 'items' on SearchResults.");
    }

    return {
      'ms': model.ms,
      'items': model.items?.map((m) => m.toJson())?.toList()
    };
  }
}

abstract class SearchResultsFields {
  static const List<String> allFields = const <String>[ms, items];

  static const String ms = 'ms';

  static const String items = 'items';
}
