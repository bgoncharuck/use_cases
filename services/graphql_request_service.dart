import 'dart:convert';
import 'package:http/http.dart' as http;

late RawGraphQLService rawGraphQLService;

class RawGraphQLService {
  final String baseUrl;
  final Map<String, String>? headers;

  RawGraphQLService({required this.baseUrl, this.headers = const {}});

  Future<dynamic> query({
    required String query,
    Map<String, dynamic>? variables,
    Map<String, String>? headers,
  }) async {
    final mergedHeaders = {...this.headers ?? {}, ...headers ?? {}};
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: mergedHeaders,
      body: json.encode({'query': query, 'variables': variables}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to execute GraphQL query: ${response.body}');
    }
    return json.decode(response.body);
  }

  Future<dynamic> mutation({
    required String mutation,
    Map<String, dynamic>? variables,
    Map<String, String>? headers,
  }) async {
    final mergedHeaders = {...this.headers ?? {}, ...headers ?? {}};
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: mergedHeaders,
      body: json.encode({'mutation': mutation, 'variables': variables}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to execute GraphQL mutation: ${response.body}');
    }
    return json.decode(response.body);
  }
}
