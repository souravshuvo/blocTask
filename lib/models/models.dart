class UserModel {
  final String name;
  final String phone;
  final double balance;
  final int points;
  final String avatar;

  UserModel({
    required this.name,
    required this.phone,
    required this.balance,
    required this.points,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      points: json['points'] ?? 0,
      avatar: json['avatar'] ?? '',
    );
  }
}

class ContactModel {
  final String id;
  final String name;
  final String phone;
  final String type;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class TransactionModel {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final double amount;
  final String date;
  final String status;

  TransactionModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date'] ?? '',
      status: json['status'] ?? '',
    );
  }

  bool get isCredit => amount > 0;
}

class ServiceModel {
  final String id;
  final String name;
  final String icon;
  final String category;

  ServiceModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class BillModel {
  final String id;
  final String name;
  final String icon;

  BillModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class PartnerBankModel {
  final String id;
  final String name;
  final String branch;

  PartnerBankModel({
    required this.id,
    required this.name,
    required this.branch,
  });

  factory PartnerBankModel.fromJson(Map<String, dynamic> json) {
    return PartnerBankModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      branch: json['branch'] ?? '',
    );
  }
}
