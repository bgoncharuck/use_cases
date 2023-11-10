import 'package:http/http.dart' as http;

Future<bool> checkInternetConnection() async {
  const urls = [
    'http://example.com/',
    'http://google.com',
    'http://yahoo.com/',
  ];

  for (final url in urls) {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {
      continue;
    }
  }

  return false;
}
