import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../utils/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  final StorageService _storage = StorageService();

  // Helper method to handle network errors with user-friendly messages
  String _getNetworkErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection. Please check your network settings.';
    } else if (error is TimeoutException) {
      return 'Connection timeout. Please try again.';
    } else if (error is http.ClientException) {
      return 'Network error. Please check your connection.';
    } else if (error is FormatException) {
      return 'Invalid response from server.';
    }
    return 'Network error: ${error.toString()}';
  }

  Future<AuthResponse> login(String login, String password) async {
    try {
      final endpoint = '${ApiConstants.peanutBaseUrl}${ApiConstants.authEndpoint}';
      print('🔐 Attempting login to: $endpoint');
      print('📝 Login: $login');

      final response = await http.post(
        Uri.parse(endpoint),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({
          'login': int.parse(login), // API expects integer
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Connection timeout after 30 seconds');
        },
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Parse according to API spec: result, token
        String? token = data['token'] as String?;
        bool result = data['result'] as bool? ?? false;

        final authResponse = AuthResponse(
          token: token,
          success: result,
          message: result ? null : 'Invalid credentials',
        );

        if (authResponse.success && authResponse.token != null && authResponse.token!.isNotEmpty) {
          print('✅ Login successful! Token: ${authResponse.token}');
          await _storage.saveToken(authResponse.token!);
          await _storage.saveCredentials(login, password);
        } else {
          print('❌ Login failed: Invalid credentials');
        }

        return authResponse;
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized (401)');
        return const AuthResponse(
          success: false,
          message: 'Invalid login or password',
        );
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        return AuthResponse(
          success: false,
          message: 'Server error (Status: ${response.statusCode})',
        );
      }
    } on SocketException catch (e) {
      print('❌ Socket Exception: $e');
      return AuthResponse(
        success: false,
        message: 'No internet connection. Please check your network.',
      );
    } on TimeoutException catch (e) {
      print('❌ Timeout Exception: $e');
      return const AuthResponse(
        success: false,
        message: 'Connection timeout. Please try again.',
      );
    } on FormatException catch (e) {
      print('❌ Format Exception: $e');
      return const AuthResponse(
        success: false,
        message: 'Invalid server response.',
      );
    } catch (e) {
      print('❌ Exception during login: $e');
      return AuthResponse(
        success: false,
        message: _getNetworkErrorMessage(e),
      );
    }
  }

  Future<AccountInfo?> getAccountInfo(String login) async {
    try {
      final token = await _storage.getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('${ApiConstants.peanutBaseUrl}${ApiConstants.accountInfoEndpoint}'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({
          'login': int.parse(login),
          'token': token,
        }),
      ).timeout(const Duration(seconds: 30));

      print('📋 Account Info Response: ${response.statusCode}');
      print('📦 Account Info Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AccountInfo.fromJson(data, login);
      } else if (response.statusCode == 401) {
        await _handleTokenExpiration();
        return null;
      }
    } on SocketException catch (e) {
      print('❌ Network error fetching account info: $e');
      rethrow;
    } catch (e) {
      print('Error fetching account info: $e');
    }
    return null;
  }

  Future<String?> getLastFourPhone(String login) async {
    try {
      final token = await _storage.getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('${ApiConstants.peanutBaseUrl}${ApiConstants.phoneEndpoint}'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({
          'login': int.parse(login),
          'token': token,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Handle different response formats
        if (data is Map<String, dynamic>) {
          return data['phone']?.toString() ??
              data['lastFourPhone']?.toString() ??
              data['lastFourNumbers']?.toString();
        } else if (data is String) {
          return data;
        }
        return null;
      } else if (response.statusCode == 401) {
        await _handleTokenExpiration();
      }
    } on SocketException catch (e) {
      print('❌ Network error fetching phone: $e');
    } catch (e) {
      print('Error fetching phone: $e');
    }
    return null;
  }

  Future<List<Trade>> getOpenTrades(String login) async {
    try {
      final token = await _storage.getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('${ApiConstants.peanutBaseUrl}${ApiConstants.tradesEndpoint}'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({
          'login': int.parse(login),
          'token': token,
        }),
      ).timeout(const Duration(seconds: 30));

      print('📊 Trades Response Status: ${response.statusCode}');
      print('📦 Trades Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle different response formats
        List<Trade> trades = [];

        if (data is Map<String, dynamic>) {
          // Response is an object with trades array
          final tradesData = data['trades'] ?? data['Trades'] ?? data['openTrades'];
          if (tradesData is List) {
            trades = tradesData.map((item) => Trade.fromJson(item)).toList();
          }
        } else if (data is List) {
          // Response is directly an array
          trades = data.map((item) => Trade.fromJson(item)).toList();
        }

        print('✅ Loaded ${trades.length} trades');
        return trades;
      } else if (response.statusCode == 401) {
        await _handleTokenExpiration();
      }
    } on SocketException catch (e) {
      print('❌ Network error fetching trades: $e');
      rethrow;
    } catch (e) {
      print('Error fetching trades: $e');
    }
    return [];
  }

  Future<List<PromoItem>> getPromos() async {
    try {
      // SOAP request body
      final soapBody = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
  <soap:Header/>
  <soap:Body>
    <tem:GetCCPromo>
      <tem:lang>en</tem:lang>
    </tem:GetCCPromo>
  </soap:Body>
</soap:Envelope>''';

      final response = await http.post(
        Uri.parse(ApiConstants.promoServiceUrl),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': 'http://tempuri.org/ICabinetMicroService/GetCCPromo',
        },
        body: soapBody,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final promos = _parsePromoResponse(response.body);
        return promos;
      }
    } on SocketException catch (e) {
      // Silently fall back to mock data (API may be unreachable)
      print('ℹ️ Network unavailable for promos, using offline data: $e');
    } catch (e) {
      // Silently fall back to mock data (API may be unreachable)
      print('ℹ️ Using offline promo data: $e');
    }

    // Return mock data as fallback (always available)
    return _getMockPromos();
  }

  List<PromoItem> _getMockPromos() {
    return [
      const PromoItem(
        title: 'Welcome Bonus',
        description: 'Get 30% bonus on your first deposit',
        imageUrl: 'https://forex-images.ifxdb.com/promo1.jpg',
        link: 'https://peanut.ifxdb.com/promo/welcome',
      ),
      const PromoItem(
        title: 'Trading Contest',
        description: 'Win prizes up to \$10,000',
        imageUrl: 'https://forex-images.ifxdb.com/promo2.jpg',
        link: 'https://peanut.ifxdb.com/promo/contest',
      ),
    ];
  }

  List<PromoItem> _parsePromoResponse(String xmlBody) {
    // Simplified XML parsing - in production, use xml package
    // For now, return mock data
    return _getMockPromos();
  }

  Future<void> _handleTokenExpiration() async {
    final credentials = await _storage.getCredentials();
    if (credentials != null) {
      await login(credentials['login']!, credentials['password']!);
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }
}