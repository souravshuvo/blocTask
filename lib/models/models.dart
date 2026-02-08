import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String? token;
  final bool success;
  final String? message;

  const AuthResponse({
    this.token,
    required this.success,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String?,
      success: json['result'] as bool? ?? json['success'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }

  @override
  List<Object?> get props => [token, success, message];
}

class AccountInfo extends Equatable {
  final String login;
  final String name;
  final String email;
  final double balance;
  final String currency;
  final String? lastFourPhone;

  const AccountInfo({
    required this.login,
    required this.name,
    required this.email,
    required this.balance,
    required this.currency,
    this.lastFourPhone,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json, String userLogin) {
    // Currency mapping: 0=USD, 1=EUR, etc.
    final currencyCode = json['currency'] as int? ?? 0;
    final currencyMap = {0: 'USD', 1: 'EUR', 2: 'GBP', 3: 'JPY'};

    return AccountInfo(
      login: userLogin, // Pass from parameter since API doesn't return it
      name: json['name']?.toString() ?? 'N/A',
      email: json['email']?.toString() ?? '', // API doesn't provide email
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: currencyMap[currencyCode] ?? 'USD',
      lastFourPhone: json['phone']?.toString(),
    );
  }

  AccountInfo copyWith({String? lastFourPhone}) {
    return AccountInfo(
      login: login,
      name: name,
      email: email,
      balance: balance,
      currency: currency,
      lastFourPhone: lastFourPhone ?? this.lastFourPhone,
    );
  }

  @override
  List<Object?> get props => [login, name, email, balance, currency, lastFourPhone];
}

class Trade extends Equatable {
  final String id;
  final String symbol;
  final String type;
  final double volume;
  final double openPrice;
  final double currentPrice;
  final double profit;
  final DateTime openTime;

  const Trade({
    required this.id,
    required this.symbol,
    required this.type,
    required this.volume,
    required this.openPrice,
    required this.currentPrice,
    required this.profit,
    required this.openTime,
  });

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      id: json['id']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      volume: (json['volume'] as num?)?.toDouble() ?? 0.0,
      openPrice: (json['openPrice'] as num?)?.toDouble() ?? 0.0,
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
      profit: (json['profit'] as num?)?.toDouble() ?? 0.0,
      openTime: DateTime.tryParse(json['openTime']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, symbol, type, volume, openPrice, currentPrice, profit, openTime];
}

class PromoItem extends Equatable {
  final String title;
  final String description;
  final String imageUrl;
  final String link;

  const PromoItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.link,
  });

  factory PromoItem.fromXml(Map<String, dynamic> json) {
    return PromoItem(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [title, description, imageUrl, link];
}