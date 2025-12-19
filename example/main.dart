import 'package:gplay_store_scrapper/gplay_store_scrapper.dart';

void main() async
{
  final scrapper = Scrapper();

  final result = await scrapper.fetchAppDetails('com.spotify.music');

  print('App Name: ${result['appName']}');
  print('Author: ${result['author']}');
  print('Genre: ${result['genre']}');
  print('Icon Path: ${result['iconPath']}');

  if (result.containsKey('error'))
  {
    print(result['error']);
  }
}