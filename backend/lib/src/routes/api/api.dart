import 'dart:async';
import 'package:angel_cache/angel_cache.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:engine/engine.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'search.dart';

Future configureServer(Angel app) async {
  // Open the database
  // var searchDbPath = p.canonicalize(
  //     p.join(p.fromUri(Platform.script), '..', '..', '..', 'search.db'));
  // var database = await databaseFactoryIo.openDatabase(searchDbPath);
  // // Create a service - we'll use this as a sort of ORM.
  // var service = SembastService(database, store: 'spider');

  var db = Db('mongodb://localhost:27017/angel_search_engine');
  var service = MongoService(db.collection('spider'));
  await db.open();

  var cacheDuration = const Duration(hours: 24);

  // File I/O is slow, though, so we'll keep an in-memory cache.
  var cached = CacheService(
    database: service,
    cache: MapService(),
    timeout: cacheDuration,
    ignoreParams: true,
  );

  // Pre-fetch the current index, so user requests are fast.
  await cached.index();

  var mappedService =
      cached.map<WebPage>(WebPageSerializer.fromMap, WebPageSerializer.toMap);
  app.shutdownHooks.add((_) => service.close());

  // Mount an HTTP /api/search endpoint.
  //
  // Regardless of the changes to search algorithm, this is still a pretty
  // expensive computation.
  //
  // Searches can, and should be, cached.
  var cache = ResponseCache(timeout: cacheDuration)
    ..patterns.add('/api/search');

  app
    ..fallback(cache.handleRequest)
    ..get('/api/search', search(mappedService))
    ..responseFinalizers.add(cache.responseFinalizer);
}
