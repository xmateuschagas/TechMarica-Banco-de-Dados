# TechMarica-Banco-de-Dados

# 🏭 TechMaricá - Sistema de Controle de Produção

Projeto de Banco de Dados desenvolvido para a disciplina de Banco de dados relacional no curso de Engenharia de Software.
O objetivo é simular o controle de operações de uma fábrica de eletrônicos (sensores, placas, módulos) utilizando MySQL.

## 📋 Objetivos do Projeto
O projeto demonstra domínio prático em SQL, abrangendo:
* **DDL:** Criação de tabelas com relacionamentos (PK/FK) e regras de negócio.
* **DML:** Inserção e manipulação de dados realistas.
* **Procedures:** Automação do cadastro de novas ordens de produção.
* **Triggers:** Atualização automática de status ("Finalizada") ao concluir uma ordem.
* **Views:** Relatórios consolidados para gestão.
* **Joins & Funções:** Consultas complexas para análise de dados.

## 🛠️ Estrutura do Banco
O sistema gerencia:
* **Produtos:** Custo, responsável técnico e cálculo de tempo de mercado.
* **Funcionários:** Controle de ativos/inativos e áreas de atuação.
* **Máquinas:** Registro de equipamentos utilizados na produção.
* **Ordens de Produção:** Histórico completo de quem fez, onde e quando.

## 🚀 Como usar
1. Baixe o arquivo `script_techmarica.sql`.
2. Abra no MySQL Workbench ou ferramenta compatível.
3. Execute o script para criar o banco e popular os dados.
