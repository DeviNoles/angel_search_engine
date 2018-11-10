# search
A snappy search engine built with Angel and Dart.

This consists of three parts:
* `backend/` - Angel server, contains an `/api/search` API.
* `crawl/` - (Inefficient) Web crawler (ideally would be a daemon)
* `engine/` - Common model files

## Installation
Make sure you have `package:mono_repo` globally installed.
Then, just run `mono_repo pub get`, and all the dependencies will be downloaded.

## Running the Server
To run the actual search engine, run:

```bash
cd backend
dart bin/prod.dart
```

## Crawling the Web
Be warned that the database *quickly* grows in size.

```bash
cd crawl
dart bin/crawl.dart <some url here>
```

## Speed improvements
The engine is no longer slow, which is nice. The reasons are mostly
related to `package:angel_cache`:
* Caching of database lookups
* Caching of search results
* No longer splits up the page text, and prefers a simple `String.contains` for large strings.
This was the main bottleneck. Now that it's resolved, the algorithm is much faster.

## Why WAS it so slow before?
Several reasons:
* All entries are saved to a single file, so scalability is limited.
* Also, I/O is expensive.
* The crawler uses an in-memory queue, rather than Redis or a similar store, so horizontal
scalability is extremely limited, if not totally impossible.
* The search algorithm is very naively implemented, and runs in larger than exponential
time. There are optimizations possible, but making a *fast* search engine was not the point here.
* The `/api/search` endpoint searches the *entire* database every time. You can imagine why this is slow.