import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

class AppData {
  static Map<String, dynamic>? _data;

  static Future<void> load() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/app_data.json');
    _data = json.decode(jsonString);
  }

  static UserModel get user =>
      UserModel.fromJson(_data?['user'] ?? {});

  static List<ContactModel> get recentContacts =>
      (_data?['recent_contacts'] as List? ?? [])
          .map((e) => ContactModel.fromJson(e))
          .toList();

  static List<ContactModel> get allContacts =>
      (_data?['all_contacts'] as List? ?? [])
          .map((e) => ContactModel.fromJson(e))
          .toList();

  static List<TransactionModel> get transactions =>
      (_data?['transactions'] as List? ?? [])
          .map((e) => TransactionModel.fromJson(e))
          .toList();

  static List<ServiceModel> get mainServices =>
      (_data?['services'] as List? ?? [])
          .map((e) => ServiceModel.fromJson(e))
          .where((s) => s.category == 'main')
          .toList();

  static List<ServiceModel> get extraServices =>
      (_data?['services'] as List? ?? [])
          .map((e) => ServiceModel.fromJson(e))
          .where((s) => s.category == 'extra')
          .toList();

  static List<BillModel> get bills =>
      (_data?['pay_bills'] as List? ?? [])
          .map((e) => BillModel.fromJson(e))
          .toList();

  static List<PartnerBankModel> get partnerBanks =>
      (_data?['partner_banks'] as List? ?? [])
          .map((e) => PartnerBankModel.fromJson(e))
          .toList();

  static List<Map<String, dynamic>> get onboarding =>
      (_data?['onboarding'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .toList();
}
