import 'package:flutter/material.dart';
import '../controllers/cliente_controller.dart';
import '../models/cliente.dart';
import '../services/validators.dart';

/// Cadastro e edição da ficha (edita se [cliente] for informado).
class ClienteFormScreen extends StatefulWidget {
  final ClienteController controller;
  final Cliente? cliente;
  const ClienteFormScreen({super.key, required this.controller, this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _form = GlobalKey<FormState>();
  late final _nome = TextEditingController(text: widget.cliente?.nome);
  late final _tel = TextEditingController(text: widget.cliente?.telefone);
  late final _email = TextEditingController(text: widget.cliente?.email);
  late final _obs = TextEditingController(text: widget.cliente?.observacoes);

  Future<void> _salvar() async {
    if (!_form.currentState!.validate()) return;
    final base = widget.cliente;
    final novo = Cliente(
      id: base?.id ?? ClienteController.novoId(),
      nome: _nome.text.trim(),
      telefone: _tel.text.trim(),
      email: _email.text.trim(),
      observacoes: _obs.text.trim(),
      historico: base?.historico,
    );
    await widget.controller.salvarCliente(novo);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cliente == null ? 'Novo cliente' : 'Editar cliente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(children: [
            TextFormField(
                controller: _nome,
                decoration: const InputDecoration(labelText: 'Nome *', border: OutlineInputBorder()),
                validator: Validators.nome),
            const SizedBox(height: 12),
            TextFormField(
                controller: _tel,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone *', border: OutlineInputBorder()),
                validator: Validators.telefone),
            const SizedBox(height: 12),
            TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                validator: Validators.email),
            const SizedBox(height: 12),
            TextFormField(
                controller: _obs,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Observações', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: _salvar, child: const Text('Salvar'))),
          ]),
        ),
      ),
    );
  }
}
