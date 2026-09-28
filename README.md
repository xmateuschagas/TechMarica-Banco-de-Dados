# TechMaricá: Banco de Dados de Controle de Produção

Modelagem relacional em MySQL para o chão de fábrica de uma indústria de eletrônicos (sensores, placas e módulos). O banco registra quem produziu, em qual máquina, qual produto e quando, e entrega à gerência uma visão consolidada da produção.

Desenvolvido por **Mateus Chagas** ([LinkedIn](https://www.linkedin.com/in/mateusbchagas) · [GitHub](https://github.com/xmateuschagas)).

---

## Problema e proposta de valor

Sem rastreabilidade, uma fábrica não sabe responder perguntas simples: qual ordem está parada, quem é o responsável, quanto tempo cada produto está no mercado. Este banco resolve isso com integridade referencial e automações no próprio SGBD, reduzindo erro manual:

- **Trigger** fecha a ordem automaticamente quando a data de conclusão é preenchida.
- **Stored procedure** padroniza a abertura de novas ordens.
- **View** entrega um relatório gerencial pronto, sem que o usuário precise escrever JOINs.

---

## Stack

- MySQL 8
- SQL (DDL, DML, JOINs, agregações, funções de data)
- MySQL Workbench (ou qualquer cliente compatível)

---

## Modelo de dados

```
Funcionarios (id_funcionario PK, nome, area_atuacao, ativo)
Maquinas     (id_maquina PK, nome_modelo, fabricante)
Produtos     (id_produto PK, nome_comercial, responsavel_tecnico, custo_producao, data_lancamento)

OrdensProducao
  id_ordem PK
  id_produto      FK → Produtos
  id_maquina      FK → Maquinas
  id_funcionario  FK → Funcionarios
  data_inicio, data_conclusao, status_ordem
```

```
Funcionarios 1 ──< OrdensProducao >── 1 Produtos
                         │
                         └──── 1 Maquinas
```

---

## Objetos do banco

| Objeto | Nome | O que faz |
|---|---|---|
| Trigger | `trg_AtualizaStatusFinalizado` | `BEFORE UPDATE`: ao preencher `data_conclusao`, muda o status para `FINALIZADA` |
| Procedure | `sp_NovaOrdemProducao(produto, funcionario, maquina)` | Cria ordem com data atual e status `EM PRODUÇÃO` |
| View | `vw_RelatorioGerencial` | Une ordens, produtos, máquinas e funcionários em um relatório único |

**Consultas analíticas incluídas**

- Detalhamento de ordens com JOINs entre as quatro tabelas
- Funcionários inativos
- Total de produtos por responsável técnico (`GROUP BY`)
- Busca por prefixo (`LIKE`)
- Tempo de mercado de cada produto (`TIMESTAMPDIFF`)

---

## Como executar

```bash
git clone https://github.com/xmateuschagas/TechMarica-Banco-de-Dados.git
cd TechMarica-Banco-de-Dados
mysql -u <usuario> -p < script_techmarica.sql
```

Ou abra `script_techmarica.sql` no MySQL Workbench e execute. O script cria o banco `TechMarica`, as tabelas, popula dados de exemplo, cria trigger, procedure e view e roda as consultas de validação.

---

## Autor

**Mateus Chagas**, Engenheiro de Software
[LinkedIn](https://www.linkedin.com/in/mateusbchagas) · [GitHub](https://github.com/xmateuschagas)
