import 'package:angel_serialize/angel_serialize.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'search_result.dart';
part 'search_results.g.dart';
part 'search_results.serializer.g.dart';

@Serializable(autoIdAndDateFields: false)
abstract class _SearchResults {
  @required
  int get ms;

  Duration get duration => new Duration(milliseconds: ms);

  @required
  List<SearchResult> get items;
}
