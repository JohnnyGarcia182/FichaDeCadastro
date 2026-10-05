import 'package:flutter_test/flutter_test.dart';
import 'package:fichas_clientes/services/validators.dart';

void main() {
  test('CT09 - nome vazio e curto são inválidos', () {
    expect(Validators.nome(''), isNotNull);
    expect(Validators.nome('Al'), isNotNull);
    expect(Validators.nome('Ana Lima'), isNull);
  });

  test('CT10 - telefone aceita 10 ou 11 dígitos com máscara', () {
    expect(Validators.telefone('(16) 99999-0000'), isNull);
    expect(Validators.telefone('1633334444'), isNull);
    expect(Validators.telefone('12345'), isNotNull);
    expect(Validators.telefone(''), isNotNull);
  });

  test('CT11 - e-mail é opcional, mas deve ser válido se informado', () {
    expect(Validators.email(''), isNull);
    expect(Validators.email('a@b.com'), isNull);
    expect(Validators.email('abc'), isNotNull);
  });

  test('CT12 - valor aceita vírgula e rejeita negativo/texto', () {
    expect(Validators.valor('12,50'), isNull);
    expect(Validators.parseValor('12,50'), 12.5);
    expect(Validators.valor('-5'), isNotNull);
    expect(Validators.valor('abc'), isNotNull);
  });
}
