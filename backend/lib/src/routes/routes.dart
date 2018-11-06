library backend.src.routes;

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_static/angel_static.dart';
import 'package:file/file.dart';
import 'api/api.dart' as api;
import 'controllers/controllers.dart' as controllers;

/// Put your app routes here!
///
/// See the wiki for information about routing, requests, and responses:
/// * https://github.com/angel-dart/angel/wiki/Basic-Routing
/// * https://github.com/angel-dart/angel/wiki/Requests-&-Responses
AngelConfigurer configureServer(FileSystem fileSystem) {
  return (Angel app) async {
    // Typically, you want to mount controllers first, after any global middleware.
    await app.configure(controllers.configureServer);

    // Mount our GraphQL API.
    await app.configure(api.configureServer);

    // Mount static server at web in development.
    // The `CachingVirtualDirectory` variant of `VirtualDirectory` also sends `Cache-Control` headers.

    var vDir = new VirtualDirectory(
      app,
      fileSystem,
      source: fileSystem.directory('web'),
    );
    app.fallback(vDir.handleRequest);

    // Throw a 404 if no route matched the request.
    app.fallback((req, res) => throw new AngelHttpException.notFound());
  };
}
