
-- PROJETO: TechMaricá Indústria Eletrônica S.A.
-- OBJETIVO: Controle de Produção (DDL, DML, JOINS, VIEWS, PROCS, TRIGGERS)

-- 1. CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE IF NOT EXISTS TechMarica;
USE TechMarica;

-- =====================================================
-- 2. DDL - CRIAÇÃO DAS TABELAS
-- =====================================================

-- Tabela de Funcionários
CREATE TABLE Funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    area_atuacao VARCHAR(50),
    ativo BOOLEAN DEFAULT TRUE -- 1 = Ativo, 0 = Inativo
);

-- Tabela de Máquinas
CREATE TABLE Maquinas (
    id_maquina INT AUTO_INCREMENT PRIMARY KEY,
    nome_modelo VARCHAR(100) NOT NULL,
    fabricante VARCHAR(50)
);

-- Tabela de Produtos
CREATE TABLE Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_comercial VARCHAR(100) NOT NULL,
    responsavel_tecnico VARCHAR(100),
    custo_producao DECIMAL(10, 2) NOT NULL,
    data_lancamento DATE NOT NULL -- Necessário para o cálculo de "idade"
);

-- Tabela de Ordens de Produção
CREATE TABLE OrdensProducao (
    id_ordem INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    id_maquina INT NOT NULL,
    id_funcionario INT NOT NULL,
    data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_conclusao DATETIME NULL,
    status_ordem VARCHAR(20) DEFAULT 'AGUARDANDO',
    
    -- Chaves Estrangeiras (FK)
    CONSTRAINT fk_produto FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto),
    CONSTRAINT fk_maquina FOREIGN KEY (id_maquina) REFERENCES Maquinas(id_maquina),
    CONSTRAINT fk_funcionario FOREIGN KEY (id_funcionario) REFERENCES Funcionarios(id_funcionario)
);

-- =====================================================
-- 3. DML - INSERÇÃO DE DADOS (POPULANDO O BANCO)
-- =====================================================

-- Inserindo Funcionários (5 registros)
INSERT INTO Funcionarios (nome, area_atuacao, ativo) VALUES
('Carlos Mendes', 'Montagem', 1),
('Ana Pereira', 'Supervisão', 1),
('Roberto Costa', 'Manutenção', 0), -- Inativo
('Fernanda Lima', 'Qualidade', 1),
('João Silva', 'Montagem', 1);

-- Inserindo Máquinas (3 registros)
INSERT INTO Maquinas (nome_modelo, fabricante) VALUES
('Insersora SMD S10', 'Panasonic'),
('Forno de Refusão X200', 'Heller'),
('Bancada de Teste Digital', 'TechBench');

-- Inserindo Produtos (5 registros)
INSERT INTO Produtos (nome_comercial, responsavel_tecnico, custo_producao, data_lancamento) VALUES
('Sensor de Presença IoT', 'Eng. Roberto', 45.00, '2020-01-15'),
('Módulo Wi-Fi Industrial', 'Eng. Patricia', 120.50, '2021-05-10'),
('Placa Controladora V3', 'Eng. Roberto', 85.00, '2019-11-20'),
('Display LCD Touch', 'Eng. Lucas', 200.00, '2022-02-01'),
('Fonte Chaveada 12V', 'Eng. Patricia', 30.00, '2023-08-15');

-- Inserindo Ordens de Produção Iniciais
INSERT INTO OrdensProducao (id_produto, id_maquina, id_funcionario, data_inicio, status_ordem) VALUES
(1, 1, 1, '2023-10-01 08:00:00', 'EM PRODUÇÃO'),
(2, 2, 2, '2023-10-02 09:00:00', 'AGUARDANDO'),
(3, 3, 4, '2023-10-03 10:00:00', 'EM PRODUÇÃO');

-- =====================================================
-- 4. TRIGGER (Gatilho Automático)
-- Enunciado: Quando data_conclusao for atualizada, mudar status para FINALIZADA
-- =====================================================
DELIMITER $$

CREATE TRIGGER trg_AtualizaStatusFinalizado
BEFORE UPDATE ON OrdensProducao
FOR EACH ROW
BEGIN
    -- Se a data de conclusão foi preenchida agora (antes era NULL)
    IF NEW.data_conclusao IS NOT NULL AND OLD.data_conclusao IS NULL THEN
        SET NEW.status_ordem = 'FINALIZADA';
    END IF;
END$$

DELIMITER ;

-- Testando o Trigger (Vamos finalizar a ordem 1)
UPDATE OrdensProducao SET data_conclusao = NOW() WHERE id_ordem = 1;

-- =====================================================
-- 5. STORED PROCEDURE (Automação de Cadastro)
-- Enunciado: Recebe IDs, cria ordem com data atual e status "EM PRODUÇÃO"
-- =====================================================
DELIMITER $$

CREATE PROCEDURE sp_NovaOrdemProducao(
    IN p_id_produto INT,
    IN p_id_funcionario INT,
    IN p_id_maquina INT
)
BEGIN
    INSERT INTO OrdensProducao (id_produto, id_funcionario, id_maquina, data_inicio, status_ordem)
    VALUES (p_id_produto, p_id_funcionario, p_id_maquina, NOW(), 'EM PRODUÇÃO');
    
    SELECT 'Ordem de produção registrada com sucesso!' AS Mensagem;
END$$

DELIMITER ;

-- Testando a Procedure
CALL sp_NovaOrdemProducao(4, 2, 1);


-- 6. VIEW (Visão Consolidada para Gerente)
-- Enunciado: Unificar dados de produtos, máquinas e funcionários
CREATE VIEW vw_RelatorioGerencial AS
SELECT 
    op.id_ordem,
    p.nome_comercial AS Produto,
    m.nome_modelo AS Maquina,
    f.nome AS Funcionario,
    op.data_inicio,
    op.status_ordem
FROM OrdensProducao op
INNER JOIN Produtos p ON op.id_produto = p.id_produto
INNER JOIN Maquinas m ON op.id_maquina = m.id_maquina
INNER JOIN Funcionarios f ON op.id_funcionario = f.id_funcionario;

-- 7. CONSULTAS AVANÇADAS (SELECTS)

-- A) Listagem completa com JOINS (Detalhes da ordem)
SELECT 
    op.id_ordem, 
    p.nome_comercial, 
    m.nome_modelo, 
    f.nome AS responsavel,
    op.status_ordem 
FROM OrdensProducao op
JOIN Produtos p ON op.id_produto = p.id_produto
JOIN Maquinas m ON op.id_maquina = m.id_maquina
JOIN Funcionarios f ON op.id_funcionario = f.id_funcionario;

-- B) Filtragem de funcionários inativos
SELECT * FROM Funcionarios WHERE ativo = 0;

-- C) Contagem total de produtos por responsável técnico
SELECT responsavel_tecnico, COUNT(*) AS total_produtos
FROM Produtos
GROUP BY responsavel_tecnico;

-- D) Seleção de produtos que começam com a letra 'S'
SELECT * FROM Produtos WHERE nome_comercial LIKE 'S%';

-- E) Cálculo automático da "idade" do produto (em anos)
SELECT 
    nome_comercial, 
    data_lancamento,
    TIMESTAMPDIFF(YEAR, data_lancamento, NOW()) AS anos_de_mercado
FROM Produtos;

-- F) Consulta na View criada anteriormente
SELECT * FROM vw_RelatorioGerencial;