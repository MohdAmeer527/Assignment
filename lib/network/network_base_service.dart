import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

/// A service class for handling network requests.
///
/// Provides methods for interacting with APIs, such as GET requests.
/// The base URL is defined at the time of instantiation.
class NetworkBaseService {
  // Base URL for API requests
  final String baseUrl;

  // Constructor to initialize the base URL
  NetworkBaseService({required this.baseUrl});

  /// Sends a GET request to the specified endpoint.
  ///
  /// Combines the `baseUrl` and `endpoint` to form the full API URL.
  /// Returns the parsed JSON response if the request is successful.
  /// Throws exceptions for errors such as timeouts or HTTP status code issues.
  Future<dynamic> get(String endpoint) async {
    try {
      // Construct the full URI from the base URL and endpoint
      final uri = Uri.parse('$baseUrl$endpoint');

      // Make the GET request with a timeout of 10 seconds
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        return json.decode(response.body); // Decode and return JSON response
      } else {
        // Throw an exception for non-200 status codes
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      // Handle timeout errors
      throw Exception('Request timed out ');
    } on Exception catch (e) {
      // Handle all other exceptions
      throw Exception('Network error: $e');
    }
  }
}
