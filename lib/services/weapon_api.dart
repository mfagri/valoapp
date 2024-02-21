import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weapon/weapon.dart';

class WeaponApi {
  static Future<List<Weapon>> fetchWeapons() async {
    const url = 'https://valorant-api.com/v1/weapons';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['data'] as List<dynamic>;
    final weapons = results.map((weapon) {
      return Weapon.fromJson(weapon);
    }).toList();
    return weapons;
  }
}
