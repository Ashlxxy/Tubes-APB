import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/app_user.dart';
import '../models/history_entry.dart';
import '../models/song.dart';
import '../models/playlist.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class AuthResult {
  final String token;
  final AppUser user;

  const AuthResult({required this.token, required this.user});
}

class LikeResult {
  final String status;
  final int likes;

  const LikeResult({required this.status, required this.likes});
}

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  String? _token;

  String? get token => _token;

  void setAuthToken(String? token) {
    _token = token;
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final data = await _request(
      method: 'POST',
      path: '/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      requiresAuth: false,
    );

    return _parseAuthResult(data);
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final data = await _request(
      method: 'POST',
      path: '/login',
      body: {'email': email, 'password': password},
      requiresAuth: false,
    );

    return _parseAuthResult(data);
  }

  Future<AppUser> fetchMe() async {
    final data = await _request(method: 'GET', path: '/me');
    return AppUser.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _request(method: 'POST', path: '/logout');
  }

  Future<List<Song>> fetchSongs() async {
    final data = await _request(method: 'GET', path: '/songs');
    final items = data['data'] as List<dynamic>? ?? [];
    return items
        .map((item) => Song.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Playlist>> fetchPlaylists() async {
    final data = await _request(method: 'GET', path: '/playlists');
    final items = data['data'] as List<dynamic>? ?? [];
    return items
        .map((item) => Playlist.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<HistoryEntry>> fetchHistory() async {
    final data = await _request(method: 'GET', path: '/history');
    final items = data['data'] as List<dynamic>? ?? [];
    return items
        .map((item) => HistoryEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> recordPlay(int songId) async {
    await _request(method: 'POST', path: '/songs/$songId/record-play');
  }

  Future<LikeResult> toggleLike(int songId) async {
    final data = await _request(method: 'POST', path: '/songs/$songId/like');
    final payload = data['data'] as Map<String, dynamic>? ?? {};

    return LikeResult(
      status: data['status']?.toString() ?? '',
      likes: payload['likes'] ?? 0,
    );
  }

  Future<List<Map<String, dynamic>>> fetchComments(int songId) async {
    final data = await _request(method: 'GET', path: '/songs/$songId/comments');
    final items = data['data'] as List<dynamic>? ?? [];
    return items.map((item) => item as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>> storeComment({
    required int songId,
    required String content,
    int? parentId,
  }) async {
    final data = await _request(
      method: 'POST',
      path: '/songs/$songId/comments',
      body: {'content': content, 'parent_id': parentId},
    );

    return data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateComment({
    required int commentId,
    required String content,
  }) async {
    final data = await _request(
      method: 'PUT',
      path: '/comments/$commentId',
      body: {'content': content},
    );

    return data['data'] as Map<String, dynamic>;
  }

  Future<void> deleteComment(int commentId) async {
    await _request(method: 'DELETE', path: '/comments/$commentId');
  }

  Future<Map<String, dynamic>> _request({
    required String method,
    required String path,
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    if (requiresAuth && (_token?.isEmpty ?? true)) {
      throw ApiException('Sesi tidak tersedia. Silakan login kembali.');
    }

    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{'Accept': 'application/json'};

    if (_token?.isNotEmpty ?? false) {
      headers['Authorization'] = 'Bearer $_token';
    }

    if (body != null) {
      headers['Content-Type'] = 'application/json';
    }

    http.Response response;

    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw ApiException('Metode request tidak didukung: $method');
      }
    } catch (_) {
      throw ApiException(
        'Tidak dapat terhubung ke server. Pastikan backend berjalan dan URL API benar.',
      );
    }

    final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    }

    var message = 'Terjadi kesalahan pada server.';

    if (decoded is Map<String, dynamic>) {
      if (decoded['message'] is String &&
          decoded['message'].toString().isNotEmpty) {
        message = decoded['message'].toString();
      }

      final errors = decoded['errors'];
      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          message = firstError.first.toString();
        }
      }
    }

    throw ApiException(message, statusCode: response.statusCode);
  }

  AuthResult _parseAuthResult(Map<String, dynamic> data) {
    final token = data['token']?.toString() ?? '';
    final userData = data['data'] as Map<String, dynamic>?;

    if (token.isEmpty || userData == null) {
      throw ApiException('Respons login dari server tidak valid.');
    }

    return AuthResult(token: token, user: AppUser.fromJson(userData));
  }
}
