library;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class Scrapper
{
  final Duration _timeout = const Duration(seconds: 10);

  Future<Map<String, String>> fetchAppDetails(String packageName) async
  {
    final client = http.Client();
    try
    {
      final response = await client.get(Uri.parse("https://play.google.com/store/apps/details?id=$packageName"),
        headers:
        {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.9,es-MX;q=0.8',
        },
      ).timeout(_timeout);

      if (response.statusCode != 200)
      {
        return {'error': 'HTTP ${response.statusCode}: Unable to fetch app data'};
      }

      var document = parse(response.body);

      String? appName = document.querySelector('span[itemprop="name"]')?.text.trim();
      String? author = document.querySelector('a[href^="/store/apps/developer?id="] span, a[href^="/store/apps/dev?id="] span')?.text.trim();
      String? genre = document.querySelector('[itemprop="genre"] span')?.text.trim();
      String? iconPath = document.querySelector('.RhBWnf img, img[alt="Icon"]')?.attributes['src'];

      if (appName == null || appName.isEmpty)
      {
        return {'error': 'App not found or invalid response'};
      }

      return
        {
        'appName': appName,
        'author': author ?? 'Unknown',
        'genre': genre ?? 'Unknown',
        'iconPath': iconPath ?? '',
      };
    }
    on TimeoutException
    {
      return {'error': 'Request timeout after ${_timeout.inSeconds} seconds'};
    }
    on http.ClientException catch (e)
    {
      return {'error': 'Network error: ${e.message}'};
    }
    catch (e)
    {
      return {'error': 'Unexpected error: $e'};
    }
    finally
    {
      client.close();
    }
  }
}