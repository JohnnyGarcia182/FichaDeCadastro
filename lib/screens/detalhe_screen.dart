import 'package:flutter/material.dart';
import '../controllers/cliente_controller.dart';
import '../models/cliente.dart';
import '../services/validators.dart';
import 'cliente_form_screen.dart';

/// Ficha do cliente com o histórico de Serviços.
class DetalheScreen extends StatelessWidget {
  final ClienteController controller;
  final String clienteId;
  const DetalheScreen({super.key, required this.controller, required this.clienteId});

  Future<void> _novoAtendimento(BuildContext context) async {
    final form = GlobalKey<FormState>();
    final desc = TextEditingController();
    final valor = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Serviço'),
        content: Form(
          key: form,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
                controller: desc,
                decoration: const InputDecoration(labelText: 'Descrição *'),
                validator: Validators.descricao),
            TextFormField(
                controller: valor,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                validator: Validators.valor),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              if (!form.currentState!.validate()) return;
              await controller.adicionarAtendimento(
                  clienteId,
                  Atendimento(
                      id: ClienteController.novoId(),
                      data: DateTime.now(),
                      descricao: desc.text.trim(),
                      valor: Validators.parseValor(valor.text) ?? 0));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
    );
  }

  Future<void> _excluir(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir ficha?'),
        content: const Text('O cliente e todo o histórico serão removidos.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (ok == true) {
      await controller.remover(clienteId);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final c = controller.porId(clienteId);
        if (c == null) return const Scaffold(body: Center(child: Text('Cliente removido')));
        final hist = [...c.historico]..sort((a, b) => b.data.compareTo(a.data));
        return Scaffold(
          appBar: AppBar(title: Text(c.nome), actions: [
            IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ClienteFormScreen(controller: controller, cliente: c)))),
            IconButton(
                tooltip: 'Excluir', icon: const Icon(Icons.delete), onPressed: () => _excluir(context)),
          ]),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _novoAtendimento(context),
              icon: const Icon(Icons.add),
              label: const Text('Serviço Realizado')),
          body: ListView(padding: const EdgeInsets.all(16), children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Telefone: ${c.telefone}'),
                  if (c.email.isNotEmpty) Text('E-mail: ${c.email}'),
                  if (c.observacoes.isNotEmpty) Text('Obs.: ${c.observacoes}'),
                  const Divider(),
                  Text('Total gasto: ${formatarValor(c.totalGasto)}',
                      style: Theme.of(context).textTheme.titleMedium),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Text('Histórico', style: Theme.of(context).textTheme.titleLarge),
            if (hist.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(24), child: Center(child: Text('Nenhum Serviço registrado'))),
            for (final a in hist)
              Dismissible(
                key: ValueKey(a.id),
                direction: DismissDirection.endToStart,
                background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white)),
                onDismissed: (_) => controller.removerAtendimento(c.id, a.id),
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(a.descricao),
                  subtitle: Text(formatarData(a.data)),
                  trailing: Text(formatarValor(a.valor)),
                ),
              ),
          ]),
        );
      },
    );
  }
}
