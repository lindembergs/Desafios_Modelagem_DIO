
-- LIMPEZA DE TABELAS

DROP TABLE IF EXISTS pecasutilizadas;
DROP TABLE IF EXISTS servicorealizado;
DROP TABLE IF EXISTS ordem_servico;
DROP TABLE IF EXISTS funcionario;
DROP TABLE IF EXISTS carro;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS equipe;
DROP TABLE IF EXISTS pecas;
DROP TABLE IF EXISTS servicos;

-- CRIAÇÃO DAS TABELAS

CREATE TABLE cliente (
  idCliente INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(45) NOT NULL,
  CPF VARCHAR(45) NOT NULL,
  PRIMARY KEY (idCliente),
  UNIQUE KEY CPF_UNIQUE (CPF)
);

CREATE TABLE carro (
  idCarro INT NOT NULL AUTO_INCREMENT,
  Placa VARCHAR(45) NOT NULL,
  Modelo VARCHAR(45) NOT NULL,
  Marca VARCHAR(45) NOT NULL,
  IdCliente INT NOT NULL,
  PRIMARY KEY (idCarro),
  UNIQUE KEY Placa_UNIQUE (Placa),
  CONSTRAINT FK_Carro_Cliente FOREIGN KEY (IdCliente) REFERENCES cliente (idCliente)
);

CREATE TABLE equipe (
  idEquipe INT NOT NULL AUTO_INCREMENT,
  Descricao VARCHAR(45) NOT NULL,
  PRIMARY KEY (idEquipe)
);

CREATE TABLE funcionario (
  idFuncionario INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(45) NOT NULL,
  Endereco VARCHAR(45) NOT NULL,
  Especialidade VARCHAR(45) NOT NULL,
  IdEquipe INT NOT NULL,
  PRIMARY KEY (idFuncionario),
  CONSTRAINT FK_Funcionario_Equipe FOREIGN KEY (IdEquipe) REFERENCES equipe (idEquipe)
);

CREATE TABLE ordem_servico (
  idOrdem_Servico INT NOT NULL AUTO_INCREMENT,
  DataEmissao DATETIME NOT NULL,
  DataConclusao DATETIME NOT NULL,
  Status ENUM('Aguardando','Aprovado','Reprovada') NOT NULL DEFAULT 'Aguardando',
  IdCarro INT NOT NULL,
  IdEquipe INT DEFAULT NULL,
  PRIMARY KEY (idOrdem_Servico),
  CONSTRAINT FK_OS_Carro FOREIGN KEY (IdCarro) REFERENCES carro (idCarro),
  CONSTRAINT FK_OS_Equipe FOREIGN KEY (IdEquipe) REFERENCES equipe (idEquipe)
);

CREATE TABLE pecas (
  idPecas INT NOT NULL AUTO_INCREMENT,
  Descricao VARCHAR(45) NOT NULL,
  Valor FLOAT NOT NULL,
  PRIMARY KEY (idPecas)
);

CREATE TABLE pecasutilizadas (
  idPecasUtilizadas INT NOT NULL AUTO_INCREMENT,
  Qtd INT NOT NULL DEFAULT 1,
  IdPecas INT DEFAULT NULL,
  IdOS INT DEFAULT NULL,
  PRIMARY KEY (idPecasUtilizadas),
  CONSTRAINT FK_PecasUtilizadas_Pecas FOREIGN KEY (IdPecas) REFERENCES pecas (idPecas),
  CONSTRAINT FK_PecasUtilizadas_OS FOREIGN KEY (IdOS) REFERENCES ordem_servico (idOrdem_Servico)
);

CREATE TABLE servicos (
  idServicos INT NOT NULL AUTO_INCREMENT,
  Descricao VARCHAR(45) NOT NULL,
  Valor FLOAT NOT NULL,
  PRIMARY KEY (idServicos)
);

CREATE TABLE servicorealizado (
  idServicoRealizado INT NOT NULL AUTO_INCREMENT,
  IdServico INT NOT NULL,
  IdOS INT NOT NULL,
  PRIMARY KEY (idServicoRealizado),
  CONSTRAINT FK_ServicoRealizado_Servico FOREIGN KEY (IdServico) REFERENCES servicos (idServicos),
  CONSTRAINT FK_ServicoRealizado_OS FOREIGN KEY (IdOS) REFERENCES ordem_servico (idOrdem_Servico)
);

-- INSERÇÃO

INSERT INTO cliente VALUES
(3,'Maria','1111111111111111111'),
(4,'Leo','222222222222222');

INSERT INTO carro VALUES
(1,'QSE-1234','LOGAN','RENAULT',3),
(2,'QWW-5685','GOL','WOLKS',4);

INSERT INTO equipe VALUES
(1,'TROCA PNEUS'),
(2,'TROCA OLEO');

INSERT INTO funcionario VALUES
(1,'THAMY','COSMOS','MECANICO',1),
(2,'TAY','SANTA CRUZ','MECANICO',2),
(3,'LARI','BANGU','MECANICO',1),
(4,'MIGUEL','MARGARIDA','MECANICO',2);

INSERT INTO ordem_servico VALUES
(2,'2022-09-23 00:00:00','2022-09-25 00:00:00','Aguardando',1,1),
(3,'2022-09-23 00:00:00','2022-09-25 00:00:00','Aguardando',2,2);

INSERT INTO pecas VALUES
(1,'Pneu',90),
(2,'Oleo',25);

INSERT INTO pecasutilizadas VALUES
(3,4,1,2),
(4,2,2,3);

INSERT INTO servicos VALUES
(1,'Troca Pneu',100),
(2,'Troca Oleo',50);

INSERT INTO servicorealizado VALUES
(1,1,2),
(2,2,3);


-- CONSULTAS

-- 1 Peças utilizadas por ordem de serviço
SELECT c.Marca, c.Placa, os.idOrdem_Servico, os.DataConclusao, os.Status,
       p.idPecas, p.Descricao, pu.Qtd, p.Valor
FROM ordem_servico os
INNER JOIN pecasutilizadas pu ON os.idOrdem_Servico = pu.IdOS
INNER JOIN pecas p ON p.idPecas = pu.IdPecas
INNER JOIN carro c ON c.idCarro = os.IdCarro;

-- 2 Serviços realizados por ordem de serviço
SELECT c.Marca, c.Placa, os.idOrdem_Servico, os.DataConclusao, os.Status,
       s.idServicos, s.Descricao, s.Valor
FROM ordem_servico os
INNER JOIN servicorealizado sr ON os.idOrdem_Servico = sr.IdOS
INNER JOIN servicos s ON sr.IdServico = s.idServicos
INNER JOIN carro c ON c.idCarro = os.IdCarro;

-- 3 Funcionários de uma equipe específica
SELECT f.idFuncionario, f.Nome, f.Especialidade, e.Descricao
FROM funcionario f
INNER JOIN equipe e ON e.idEquipe = f.IdEquipe
WHERE f.IdEquipe = 2;

-- 4 Funcionários mecânicos
SELECT *
FROM funcionario
WHERE Especialidade = 'MECANICO';

-- 5 Quantidade de ordens de serviço aguardando
SELECT os.idOrdem_Servico, os.Status, COUNT(*) AS Total
FROM ordem_servico os
WHERE os.Status = 'Aguardando';
