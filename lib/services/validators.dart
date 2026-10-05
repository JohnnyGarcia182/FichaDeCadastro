/// Regras de validação dos formulários (testáveis sem interface).
class Validators {
  static String? nome(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe o nome';
    if (v.trim().length < 3) return 'Nome muito curto';
    return null;
  }

  static String? telefone(String? v) {
    final d = (v ?? '').replaceAll(RegExp(r'\D'), '');
    if (d.isEmpty) return 'Informe o telefone';
    if (d.length < 10 || d.length > 11) return 'Telefone deve ter 10 ou 11 dígitos';
    return null;
  }

  /// E-mail é opcional, mas se informado deve ser válido.
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'E-mail inválido';
  }

  static String? descricao(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Serviços' : null;

  static double? parseValor(String? v) =>
      double.tryParse((v ?? '').trim().replaceAll(',', '.'));

  static String? valor(String? v) {
    if (v == null || v.trim().isEmpty) return null; // opcional
    final n = parseValor(v);
    if (n == null) return 'Valor inválido';
    if (n < 0) return 'Valor não pode ser negativo';
    return null;
  }
}
