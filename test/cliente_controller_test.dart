import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fichas_clientes/controllers/cliente_controller.dart';
import 'package:fichas_clientes/models/cliente.dart';
import 'package:fichas_clientes/repositories/cliente_repository.dart';

Cliente _cliente(String id, String nome) =>
    Cliente(id: id, nome: nome, telefone: '16999990000');

void main() {
  late ClienteController ctrl;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ctrl = ClienteController(ClienteRepository());
  });

  test('CT01 - cadastra cliente', () async {
    await ctrl.salvarCliente(_cliente('1', 'Maria Silva'));
    expect(ctrl.total, 1);
  });

  test('CT02 - salvar com mesmo id atualiza a ficha', () async {
    await ctrl.salvarCliente(_cliente('1', 'Maria'));
    await ctrl.salvarCliente(_cliente('1', 'Maria Souza'));
    expect(ctrl.total, 1);
    expect(ctrl.porId('1')!.nome, 'Maria Souza');
  });

  test('CT03 - remove cliente', () async {
    await ctrl.salvarCliente(_cliente('1', 'Maria'));
    await ctrl.remover('1');
    expect(ctrl.total, 0);
  });

  test('CT04 - adiciona atendimento ao histórico e soma o total', () async {
    await ctrl.salvarCliente(_cliente('1', 'Maria'));
    await ctrl.adicionarAtendimento('1', Atendimento(id: 'a', data: DateTime(2026, 9, 1), descricao: 'Corte', valor: 50));
    await ctrl.adicionarAtendimento('1', Atendimento(id: 'b', data: DateTime(2026, 9, 10), descricao: 'Coloração', valor: 120.5));
    final c = ctrl.porId('1')!;
    expect(c.historico.length, 2);
    expect(c.totalGasto, 170.5);
    expect(c.ultimoAtendimento!.descricao, 'Coloração');
  });

  test('CT05 - atendimento em cliente inexistente lança erro', () async {
    expect(
        () => ctrl.adicionarAtendimento('x', Atendimento(id: 'a', data: DateTime.now(), descricao: 'Teste')),
        throwsStateError);
  });

  test('CT06 - remove atendimento', () async {
    await ctrl.salvarCliente(_cliente('1', 'Maria'));
    await ctrl.adicionarAtendimento('1', Atendimento(id: 'a', data: DateTime.now(), descricao: 'Corte', valor: 30));
    await ctrl.removerAtendimento('1', 'a');
    expect(ctrl.porId('1')!.historico, isEmpty);
  });

  test('CT07 - busca por nome ignora maiúsculas e ordena A-Z', () async {
    await ctrl.salvarCliente(_cliente('1', 'Carlos'));
    await ctrl.salvarCliente(_cliente('2', 'Ana'));
    expect(ctrl.clientes.first.nome, 'Ana');
    ctrl.buscar('carl');
    expect(ctrl.clientes.length, 1);
    expect(ctrl.clientes.first.nome, 'Carlos');
  });

  test('CT08 - dados persistem após recarregar', () async {
    await ctrl.salvarCliente(_cliente('1', 'Maria'));
    await ctrl.adicionarAtendimento('1', Atendimento(id: 'a', data: DateTime(2026, 9, 1), descricao: 'Corte', valor: 40));
    final novo = ClienteController(ClienteRepository());
    await novo.carregar();
    expect(novo.porId('1')!.historico.single.valor, 40);
  });
}
