import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fichas_clientes/controllers/cliente_controller.dart';
import 'package:fichas_clientes/models/cliente.dart';
import 'package:fichas_clientes/repositories/cliente_repository.dart';
import 'package:fichas_clientes/screens/cliente_form_screen.dart';
import 'package:fichas_clientes/screens/lista_screen.dart';

void main() {
  late ClienteController ctrl;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ctrl = ClienteController(ClienteRepository());
  });

  testWidgets('CT13 - lista vazia mostra mensagem e botão de adicionar', (t) async {
    await t.pumpWidget(MaterialApp(home: ListaScreen(controller: ctrl)));
    expect(find.text('Ficha de cadastro de clientes e serviços'), findsOneWidget);
    expect(find.text('Nenhum cliente encontrado'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('CT14 - lista exibe cliente cadastrado', (t) async {
    await t.runAsync(() => ctrl.salvarCliente(
        Cliente(id: '1', nome: 'Maria Silva', telefone: '16999990000')));
    await t.pumpWidget(MaterialApp(home: ListaScreen(controller: ctrl)));
    expect(find.text('Maria Silva'), findsOneWidget);
  });

  testWidgets('CT15 - formulário vazio exibe mensagens de validação', (t) async {
    await t.pumpWidget(MaterialApp(home: ClienteFormScreen(controller: ctrl)));
    await t.tap(find.text('Salvar'));
    await t.pump();
    expect(find.text('Informe o nome'), findsOneWidget);
    expect(find.text('Informe o telefone'), findsOneWidget);
  });
}
