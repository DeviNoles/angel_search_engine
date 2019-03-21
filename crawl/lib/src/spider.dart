import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'package:canonical_url/canonical_url.dart';
import 'package:engine/engine.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:http2_client/http2_client.dart';
import 'package:path/path.dart' as p;
import 'package:isolate/load_balancer.dart';
import 'package:isolate/isolate_runner.dart';

final _client = http.IOClient();
// final _client = Http2Client(maxOpenConnections: Platform.numberOfProcessors);

Future crawl(
    String entryPoint, List<String> existing, void Function(WebPage) callback,
    {int concurrency}) async {
  concurrency ??= Platform.numberOfProcessors;
  var loadBalancer =
      await LoadBalancer.create(concurrency, IsolateRunner.spawn);
  var crawled = new Set<String>.from(existing);
  var queue = new Queue<String>()..addFirst(entryPoint);
  var recv = new ReceivePort();
  var canonicalizer = new UrlCanonicalizer(removeFragment: true);
  entryPoint = canonicalizer.canonicalize(entryPoint);

  recv.listen((url) {
    if (url is String) {
      var canonical =
          canonicalizer.canonicalize(Uri.parse(url)).replace(query: '');
      var u = canonical.toString().replaceAll(new RegExp(r'\?$'), '');
      const allowedExtensions = const ['', '.html', '.php', '.aspx'];

      if (allowedExtensions.contains(p.extension(u)) && crawled.add(u)) {
        queue.addFirst(u);
      }
    }
  });

  while (queue.isNotEmpty) {
    var data =
        await loadBalancer.run(visitPage, [queue.removeFirst(), recv.sendPort]);
    if (data != null) callback(WebPageSerializer.fromMap(data));
  }
}

String findMeta(html.Document doc, String name) {
  return (doc.head?.querySelector('meta[name="$name"]')?.attributes ??
              <dynamic, String>{})['content']
          ?.trim() ??
      '';
}

Future<Map<String, dynamic>> visitPage(List args) async {
  var page = args[0] as String, sendPort = args[1] as SendPort;
  var currentUri = Uri.parse(page);

  if (!currentUri.hasScheme) currentUri = currentUri.replace(scheme: 'http');

  print('Now crawling $currentUri...');

  http.Response rs;

  try {
    rs = await _client.get(currentUri, headers: {
      HttpHeaders.acceptHeader: ContentType.html.mimeType,
      HttpHeaders.userAgentHeader:
          'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)',
    });
  } catch (_) {
    // Some failure... Just keep going...
    return null;
  }

  // Ignore non-200 codes
  if (rs.statusCode < 200 || rs.statusCode >= 400) return null;

  var doc = html.parse(rs.body);

  // Scrape the contents
  var now = new DateTime.now();
  var webPage = new WebPage(
      url: currentUri.toString(),
      contents: Uri.encodeFull(
          (doc.body?.text ?? '').replaceAll(new RegExp(r'\s\s+'), ' ')),
      keywordString: findMeta(doc, 'keywords'),
      author: findMeta(doc, 'author'),
      description: findMeta(doc, 'description'),
      title: doc.head?.querySelector('title')?.text ?? '(untitled)',
      createdAt: now,
      updatedAt: now);

  // We also want to find the pages that this webpage links to.
  var links = doc
      .querySelectorAll('a')
      .where((e) => e.attributes['href']?.trim()?.isNotEmpty == true);

  var hrefs = <Uri>[];

  for (var link in links) {
    var href = Uri.parse(link.attributes['href'].trim());

    // If they are in the same domain.
    if (!href.hasScheme || href.authority == currentUri.authority) {
      href = href.replace(
        path: p.join(currentUri.path, href.path),
      );
    } else {
      // Otherwise, this URL has a scheme, or is just from a different domain.
      if (!href.hasScheme) href = href.replace(scheme: 'http');
    }

    if (!href.hasAuthority) {
      href = href.replace(
          userInfo: currentUri.userInfo,
          host: currentUri.host,
          port: const [80, 443].contains(currentUri.port)
              ? null
              : currentUri.port);
    }

    // Enqueue the crawling of this link.
    hrefs.add(href);
  }

  // Crawl local links first
  var local = hrefs.where((h) => h.authority == currentUri.authority);
  var foreign = hrefs.where((h) => !local.contains(h));
  [local, foreign]
      .forEach((l) => l.forEach((h) => sendPort.send(h.toString())));

  return webPage.toJson();
}
