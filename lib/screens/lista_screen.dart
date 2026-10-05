import 'package:flutter/material.dart';
import '../controllers/cliente_controller.dart';
import 'cliente_form_screen.dart';
import 'detalhe_screen.dart';

class ListaScreen extends StatelessWidget {
  final ClienteController controller;
  const ListaScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ficha de cadastro de clientes e serviços')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Novo cliente',
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => ClienteFormScreen(controller: controller))),
        child: const Icon(Icons.add),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            key: const Key('campoBusca'),
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar por nome ou telefone',
                border: OutlineInputBorder()),
            onChanged: controller.buscar,
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final lista = controller.clientes;
              if (lista.isEmpty) {
                return const Center(child: Text('Nenhum cliente encontrado'));
              }
              return ListView.separated(
                itemCount: lista.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final c = lista[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text(c.nome[0].toUpperCase())),
                    title: Text(c.nome),
                    subtitle: Text('${c.telefone} • ${c.historico.length} Serviço(s)'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                DetalheScreen(controller: controller, clienteId: c.id))),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
