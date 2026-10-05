# Fichas de Clientes com Histórico

Aplicativo Flutter para cadastro de clientes e registro do histórico de atendimentos.
Projeto Integrado – Desenvolvimento Mobile – UNIFEOB (3º trimestre 2026).

## Funcionalidades
- RF01 Cadastrar, editar e excluir fichas de clientes
- RF02 Registrar atendimentos (data, descrição, valor) no histórico
- RF03 Excluir atendimento (deslizar para a esquerda)
- RF04 Buscar clientes por nome ou telefone
- RF05 Exibir total gasto e atendimentos por cliente
- RF06 Validar formulários
- RNF01 Funciona offline (armazenamento local) | RNF02 Interface simples e responsiva

## Como rodar
```bash
flutter create . --platforms=android,ios   # gera as pastas de plataforma
flutter pub get
flutter run
```
## Testes
```bash
flutter test
```
## Estrutura
`models/` entidades · `services/` validações · `repositories/` persistência · `controllers/` regras de negócio · `screens/` interface
