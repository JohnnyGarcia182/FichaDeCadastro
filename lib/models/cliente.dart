String formatarData(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

String formatarValor(double v) => 'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

/// Registro de um atendimento no histórico do cliente.
class Atendimento {
  final String id;
  final DateTime data;
  final String descricao;
  final double valor;

  Atendimento({required this.id, required this.data, required this.descricao, this.valor = 0});

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data.toIso8601String(),
        'descricao': descricao,
        'valor': valor,
      };

  factory Atendimento.fromJson(Map<String, dynamic> j) => Atendimento(
        id: j['id'],
        data: DateTime.parse(j['data']),
        descricao: j['descricao'],
        valor: (j['valor'] as num).toDouble(),
      );
}

/// Ficha cadastral do cliente com seu histórico.
class Cliente {
  final String id;
  final String nome;
  final String telefone;
  final String email;
  final String observacoes;
  final List<Atendimento> historico;

  Cliente({
    required this.id,
    required this.nome,
    required this.telefone,
    this.email = '',
    this.observacoes = '',
    List<Atendimento>? historico,
  }) : historico = historico ?? [];

  double get totalGasto => historico.fold(0.0, (soma, a) => soma + a.valor);

  Atendimento? get ultimoAtendimento {
    if (historico.isEmpty) return null;
    return ([...historico]..sort((a, b) => b.data.compareTo(a.data))).first;
  }

  Cliente copyWith({String? nome, String? telefone, String? email, String? observacoes, List<Atendimento>? historico}) =>
      Cliente(
        id: id,
        nome: nome ?? this.nome,
        telefone: telefone ?? this.telefone,
        email: email ?? this.email,
        observacoes: observacoes ?? this.observacoes,
        historico: historico ?? this.historico,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'telefone': telefone,
        'email': email,
        'observacoes': observacoes,
        'historico': historico.map((a) => a.toJson()).toList(),
      };

  factory Cliente.fromJson(Map<String, dynamic> j) => Cliente(
        id: j['id'],
        nome: j['nome'],
        telefone: j['telefone'],
        email: j['email'] ?? '',
        observacoes: j['observacoes'] ?? '',
        historico: (j['historico'] as List).map((e) => Atendimento.fromJson(e)).toList(),
      );
}
