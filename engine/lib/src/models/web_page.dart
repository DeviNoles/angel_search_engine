import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:meta/meta.dart';
part 'web_page.g.dart';
part 'web_page.serializer.g.dart';

@serializable
abstract class _WebPage extends Model {
  @required
  String get title;

  String get description;

  String get url;

  @required
  String get contents;

  String get decodedContents => Uri.decodeFull(contents);

  String get lowercaseContents => decodedContents.toLowerCase();

  String get author;

  @required
  String get keywordString;

  List<String> get keywords => keywordString.split(',');

  Uri get uri => Uri.parse(url);
}
