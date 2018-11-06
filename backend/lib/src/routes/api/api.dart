import 'dart:async';
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_sembast/angel_sembast.dart';
import 'package:engine/engine.dart';
import 'package:path/path.dart' as p;
import 'package:sembast/sembast_io.dart';
import 'search.dart';

Future configureServer(Angel app) async {
  // Open the database
  var searchDbPath = p.canonicalize(
      p.join(p.fromUri(Platform.script), '..', '..', '..', 'search.db'));
  var database = await databaseFactoryIo.openDatabase(searchDbPath);

  // Create a service - we'll use this as a sort of ORM.
  var service = new SembastService(database, store: 'spider');
  var mappedService =
      service.map<WebPage>(WebPageSerializer.fromMap, WebPageSerializer.toMap);
  app.shutdownHooks.add((_) => service.close());

  // Mount an HTTP /api/search endpoint.
  app.get('/api/search', search(mappedService));
}
