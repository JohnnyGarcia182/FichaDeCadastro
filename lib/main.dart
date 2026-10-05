import 'package:flutter/material.dart';
import 'controllers/cliente_controller.dart';
import 'repositories/cliente_repository.dart';
import 'screens/lista_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = ClienteController(ClienteRepository());
  await controller.carregar();
  runApp(FichasApp(controller: controller));
}

class FichasApp extends StatelessWidget {
  final ClienteController controller;
  const FichasApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Ficha de cadastro de clientes e serviços',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: ListaScreen(controller: controller),
      );
}
