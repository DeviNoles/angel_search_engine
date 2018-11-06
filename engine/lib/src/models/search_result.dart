import 'package:angel_serialize/angel_serialize.dart';
import 'package:meta/meta.dart';
part 'search_result.g.dart';
part 'search_result.serializer.g.dart';

@Serializable(autoIdAndDateFields: false)
abstract class _SearchResult {
  @required
  String get title;

  @required
  String get description;

  @required
  String get author;

  @required
  String get url;

  @required
  double get score;
}
