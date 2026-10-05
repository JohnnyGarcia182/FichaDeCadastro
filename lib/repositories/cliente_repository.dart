import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cliente.dart';

/// Persistência local (offline) em JSON via SharedPreferences.
class ClienteRepository {
  static const _chave = 'clientes_v1';

  Future<List<Cliente>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_chave);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).map((e) => Cliente.fromJson(e)).toList();
  }

  Future<void> salvar(List<Cliente> clientes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chave, jsonEncode(clientes.map((c) => c.toJson()).toList()));
  }
}
