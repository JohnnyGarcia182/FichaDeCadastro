import 'package:flutter/foundation.dart';
import '../models/cliente.dart';
import '../repositories/cliente_repository.dart';

/// Regras de negócio e estado da aplicação.
class ClienteController extends ChangeNotifier {
  final ClienteRepository _repo;
  List<Cliente> _clientes = [];
  String _busca = '';

  ClienteController(this._repo);

  static String novoId() => DateTime.now().microsecondsSinceEpoch.toString();

  List<Cliente> get clientes {
    final termo = _busca.toLowerCase();
    final lista = _clientes
        .where((c) => c.nome.toLowerCase().contains(termo) || c.telefone.contains(termo))
        .toList();
    lista.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
    return lista;
  }

  int get total => _clientes.length;

  Cliente? porId(String id) {
    for (final c in _clientes) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<void> carregar() async {
    _clientes = await _repo.carregar();
    notifyListeners();
  }

  void buscar(String termo) {
    _busca = termo.trim();
    notifyListeners();
  }

  /// Cria ou atualiza (se o id já existir) uma ficha.
  Future<void> salvarCliente(Cliente c) async {
    final i = _clientes.indexWhere((x) => x.id == c.id);
    i >= 0 ? _clientes[i] = c : _clientes.add(c);
    await _persistir();
  }

  Future<void> remover(String id) async {
    _clientes.removeWhere((c) => c.id == id);
    await _persistir();
  }

  Future<void> adicionarAtendimento(String clienteId, Atendimento a) async {
    final c = porId(clienteId);
    if (c == null) throw StateError('Cliente não encontrado');
    await salvarCliente(c.copyWith(historico: [...c.historico, a]));
  }

  Future<void> removerAtendimento(String clienteId, String atendimentoId) async {
    final c = porId(clienteId);
    if (c == null) return;
    await salvarCliente(
        c.copyWith(historico: c.historico.where((a) => a.id != atendimentoId).toList()));
  }

  Future<void> _persistir() async {
    await _repo.salvar(_clientes);
    notifyListeners();
  }
}
