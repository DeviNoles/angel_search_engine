import 'dart:async';
import 'dart:io';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:args/args.dart';
import 'package:crawl/crawl.dart';
import 'package:engine/engine.dart';
import 'package:mongo_dart/mongo_dart.dart';

final argParser = new ArgParser()
  ..addOption('concurrency',
      abbr: 'j',
      defaultsTo: Platform.numberOfProcessors.toString(),
      help: 'The number of concurrent workers to run.');

main(List<String> args) async {
  try {
    var argResults = argParser.parse(args);

    if (argResults.rest.isEmpty) {
      throw new ArgParserException('Missing input URL.');
    }

    var entryPoint = argResults.rest[0];

    // // Find the path to search.db
    // var searchDbPath = p.canonicalize(
    //     p.join(p.fromUri(Platform.script), '..', '..', '..', 'search.db'));
    // var database = await databaseFactoryIo.openDatabase(searchDbPath);
    // print('Loaded database at $searchDbPath');

    // // Create a service - we'll use this store our crawled pages.
    // var service = new SembastService(database, store: 'spider');
    var db = Db('mongodb://localhost:27017/angel_search_engine');
    var service = MongoService(db.collection('spider'));
    await db.open();

    // Object mapping.
    var mappedService = service.map<WebPage>(
        WebPageSerializer.fromMap, WebPageSerializer.toMap);

    // Fetch the already-crawled URL's.
    var existing = await mappedService
        .index()
        .then((pages) => pages.map((p) => p.url).toList());

    // Every time we crawl a web page, store it in the database.
    callback(WebPage page) async {
      await mappedService.create(page);
      print('Saved crawl info from ${page.url}');
    }

    // Next, just crawl...
    doIt(String entryPoint) {
      return runZoned(
        () => crawl(entryPoint, existing, callback,
            concurrency: int.parse(argResults['concurrency'] as String)),
        onError: (e, st) async {
          print('Crawler crashed. Picking a random page to continue from...');
          print(e);
          print(st);

          // When an error occurs, just pick a random page, and crawl from there.
          var pages = await mappedService.index();
          pages.shuffle();

          if (pages.isNotEmpty) {
            return await doIt(pages.first.url);
          }
        },
      );
    }

    await doIt(entryPoint);
  } on ArgParserException catch (e) {
    print(e.message);
    print('usage: bin/crawl.dart [options...] <entrypoint url>\n\nOptions:\n');
    print(argParser.usage);
  }
}
