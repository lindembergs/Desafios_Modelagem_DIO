
-- ENDEREÇO
DROP TABLE IF EXISTS endereco;
CREATE TABLE endereco (
    CEP INT NOT NULL,
    Valor_Frete FLOAT NOT NULL,
    PRIMARY KEY (CEP)
);

INSERT INTO endereco (CEP, Valor_Frete) VALUES
    (12345678, 25.50),
    (87654321, 40.00);

-- CLIENTE
DROP TABLE IF EXISTS cliente;
CREATE TABLE cliente (
    idCliente INT NOT NULL AUTO_INCREMENT,
    Minit CHAR(3) DEFAULT NULL,
    CEP INT NOT NULL,
    PRIMARY KEY (idCliente),
    KEY CEP_idx (CEP),
    CONSTRAINT FK_Cliente_CEP FOREIGN KEY (CEP) REFERENCES endereco (CEP)
);

INSERT INTO cliente (Minit, CEP) VALUES
    (NULL, 12345678),
    ('ABC', 87654321);

-- CLIENTE FÍSICO
DROP TABLE IF EXISTS cliente_fisico;
CREATE TABLE cliente_fisico (
    idCliente_Fisico INT NOT NULL AUTO_INCREMENT,
    CPF VARCHAR(11) NOT NULL,
    Pnome VARCHAR(45) NOT NULL,
    Unome VARCHAR(45) NOT NULL,
    IdCliente INT NOT NULL,
    PRIMARY KEY (idCliente_Fisico),
    UNIQUE KEY CPF_UNIQUE (CPF),
    KEY IdCliente_idx (IdCliente),
    CONSTRAINT FK_ClienteFisico_Cliente FOREIGN KEY (IdCliente) REFERENCES cliente (idCliente)
);

INSERT INTO cliente_fisico (CPF, Pnome, Unome, IdCliente) VALUES
    ('12345678901', 'Maria', 'Silva', 1);

-- CLIENTE JURÍDICO
DROP TABLE IF EXISTS cliente_juridico;
CREATE TABLE cliente_juridico (
    idCliente_Juridico INT NOT NULL AUTO_INCREMENT,
    CNPJ VARCHAR(14) NOT NULL,
    Razao_Social VARCHAR(45) DEFAULT NULL,
    IdCliente INT NOT NULL,
    PRIMARY KEY (idCliente_Juridico),
    UNIQUE KEY CNPJ_UNIQUE (CNPJ),
    KEY IdCliente_idx (IdCliente),
    CONSTRAINT FK_ClienteJuridico_Cliente FOREIGN KEY (IdCliente) REFERENCES cliente (idCliente) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO cliente_juridico (CNPJ, Razao_Social, IdCliente) VALUES
    ('11222333000144', 'Tech Solutions LTDA', 2);

-- FORMA DE PAGAMENTO
DROP TABLE IF EXISTS formapagamento;
CREATE TABLE formapagamento (
    idFormaPagamento INT NOT NULL AUTO_INCREMENT,
    Descricao VARCHAR(45) NOT NULL,
    PRIMARY KEY (idFormaPagamento)
);

INSERT INTO formapagamento (Descricao) VALUES
    ('Cartão de Crédito'),
    ('Boleto Bancário'),
    ('Pix');

-- PEDIDO
DROP TABLE IF EXISTS pedido;
CREATE TABLE pedido (
    IdPedido INT NOT NULL AUTO_INCREMENT,
    Descricao VARCHAR(45) NOT NULL,
    Status_Pedido ENUM('Cancelado','Confirmado','Em Processamento') NOT NULL,
    IdCliente INT NOT NULL,
    IdPgto INT NOT NULL,
    PRIMARY KEY (IdPedido),
    KEY IdCliente_idx (IdCliente),
    KEY IdPgto_idx (IdPgto),
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (IdCliente) REFERENCES cliente (idCliente) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Pedido_Pgto FOREIGN KEY (IdPgto) REFERENCES formapagamento (idFormaPagamento)
);

INSERT INTO pedido (Descricao, Status_Pedido, IdCliente, IdPgto) VALUES
    ('Compra Online #001', 'Confirmado', 1, 1),
    ('Compra Online #002', 'Em Processamento', 2, 3);

-- ENTREGA
DROP TABLE IF EXISTS entrega;
CREATE TABLE entrega (
    idEntrega INT NOT NULL AUTO_INCREMENT,
    StatusEntrega ENUM('Aguardando Envio','Enviado','Entregue','Não Recebido') NOT NULL DEFAULT 'Aguardando Envio',
    Codigo_Rastreio VARCHAR(45) DEFAULT NULL,
    IdPedido INT NOT NULL,
    PRIMARY KEY (idEntrega),
    KEY idPedido_idx (IdPedido),
    CONSTRAINT FK_Entrega_Pedido FOREIGN KEY (IdPedido) REFERENCES pedido (IdPedido)
);

INSERT INTO entrega (StatusEntrega, Codigo_Rastreio, IdPedido) VALUES
    ('Enviado', 'BR123456789SP', 1),
    ('Aguardando Envio', NULL, 2);

-- ESTOQUE
DROP TABLE IF EXISTS estoque;
CREATE TABLE estoque (
    idEstoque INT NOT NULL AUTO_INCREMENT,
    Localizacao VARCHAR(45) NOT NULL,
    PRIMARY KEY (idEstoque)
);

INSERT INTO estoque (Localizacao) VALUES
    ('Centro'),
    ('Zona Norte'),
    ('Zona Sul');

-- PRODUTO
DROP TABLE IF EXISTS produto;
CREATE TABLE produto (
    Idproduto INT NOT NULL AUTO_INCREMENT,
    Pnome VARCHAR(45) NOT NULL,
    Classificacao_infantil TINYINT DEFAULT 0,
    Categoria ENUM('Eletronico','Vestimenta','Brinquedos','Alimentos','Moveis') NOT NULL,
    Avaliacao FLOAT DEFAULT 0,
    Tamanho VARCHAR(10) DEFAULT NULL,
    PRIMARY KEY (Idproduto)
);

INSERT INTO produto (Pnome, Classificacao_infantil, Categoria, Avaliacao, Tamanho) VALUES
    ('Camiseta Polo', 1, 'Vestimenta', 4.5, 'M'),
    ('Headset Gamer', 0, 'Eletronico', 9.0, NULL);

-- QTD ESTOQUE
DROP TABLE IF EXISTS qtd_estoque;
CREATE TABLE qtd_estoque (
    idQtd_Estoque INT NOT NULL AUTO_INCREMENT,
    Qtd INT NOT NULL,
    IdProduto INT NOT NULL,
    IdEstoque INT NOT NULL,
    PRIMARY KEY (idQtd_Estoque),
    KEY IdProduto_idx (IdProduto),
    KEY IdEstoque_idx (IdEstoque),
    CONSTRAINT FK_QtdEstoque_Produto FOREIGN KEY (IdProduto) REFERENCES produto (Idproduto) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_QtdEstoque_Estoque FOREIGN KEY (IdEstoque) REFERENCES estoque (idEstoque) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO qtd_estoque (Qtd, IdProduto, IdEstoque) VALUES
    (50, 1, 2),
    (20, 2, 1),
    (10, 2, 3);

-- FORNECEDOR
DROP TABLE IF EXISTS fornecedor;
CREATE TABLE fornecedor (
    idFornecedor INT NOT NULL AUTO_INCREMENT,
    Razao_Social VARCHAR(45) NOT NULL,
    CNPJ VARCHAR(14) NOT NULL,
    Contato CHAR(11) NOT NULL,
    PRIMARY KEY (idFornecedor),
    UNIQUE KEY CNPJ_UNIQUE (CNPJ)
);

INSERT INTO fornecedor (Razao_Social, CNPJ, Contato) VALUES
    ('Comercial ABC', '33445566000177', '21999998888'),
    ('Distribuidora XYZ', '44556677000188', '21988887777');

-- FORNECIMENTO PRODUTO
DROP TABLE IF EXISTS fornecxproduto;
CREATE TABLE fornecxproduto (
    idfornecimento INT NOT NULL AUTO_INCREMENT,
    IdFornecedor INT NOT NULL,
    IdProduto INT NOT NULL,
    PRIMARY KEY (idfornecimento),
    KEY IdFornecedor_idx (IdFornecedor),
    KEY IdProduto_idx (IdProduto),
    CONSTRAINT FK_Fornecimento_Fornecedor FOREIGN KEY (IdFornecedor) REFERENCES fornecedor (idFornecedor),
    CONSTRAINT FK_Fornecimento_Produto FOREIGN KEY (IdProduto) REFERENCES produto (Idproduto)
);

INSERT INTO fornecxproduto (IdFornecedor, IdProduto) VALUES
    (1, 1),
    (2, 2);

-- ITENS DO PEDIDO
DROP TABLE IF EXISTS itens_pedido;
CREATE TABLE itens_pedido (
    IdItem_Pedido INT NOT NULL AUTO_INCREMENT,
    IdPedido INT NOT NULL,
    IdProduto INT NOT NULL,
    Qtd INT NOT NULL DEFAULT 1,
    PRIMARY KEY (IdItem_Pedido),
    KEY IdPedido_idx (IdPedido),
    KEY IdProduto_idx (IdProduto),
    CONSTRAINT FK_ItemPedido_Pedido FOREIGN KEY (IdPedido) REFERENCES pedido (IdPedido),
    CONSTRAINT FK_ItemPedido_Produto FOREIGN KEY (IdProduto) REFERENCES produto (Idproduto)
);

INSERT INTO itens_pedido (IdPedido, IdProduto, Qtd) VALUES
    (1, 1, 5),
    (2, 2, 2);

-- TERCEIROS
DROP TABLE IF EXISTS terceiros;
CREATE TABLE terceiros (
    idTerceiro INT NOT NULL AUTO_INCREMENT,
    Razao_Social VARCHAR(45) NOT NULL,
    Local VARCHAR(45) NOT NULL,
    PRIMARY KEY (idTerceiro),
    UNIQUE KEY Razao_Social_UNIQUE (Razao_Social)
);

INSERT INTO terceiros (Razao_Social, Local) VALUES
    ('Serviços Rápidos', 'São Paulo'),
    ('Entregas Express', 'Rio de Janeiro');

-- TERCEIRO X PRODUTO
DROP TABLE IF EXISTS tercxprodut;
CREATE TABLE tercxprodut (
    idTercxProdut INT NOT NULL AUTO_INCREMENT,
    IdTerceiro INT NOT NULL,
    IdProduto INT NOT NULL,
    Qtd INT NOT NULL,
    PRIMARY KEY (idTercxProdut),
    KEY IdTerceiro_idx (IdTerceiro),
    KEY IdProduto_idx (IdProduto),
    CONSTRAINT FK_TercProd_Produto FOREIGN KEY (IdProduto) REFERENCES produto (Idproduto) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_TercProd_Terceiro FOREIGN KEY (IdTerceiro) REFERENCES terceiros (idTerceiro) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO tercxprodut (IdTerceiro, IdProduto, Qtd) VALUES
    (1, 1, 50),
    (2, 2, 60);

-- 1. Recuperação simples
SELECT Pnome, Unome, CPF FROM cliente_fisico;

-- 2. Filtro com WHERE
SELECT IdPedido, Descricao, Status_Pedido
FROM pedido
WHERE Status_Pedido = 'Confirmado';

-- 3. Atributo derivado
SELECT ip.IdItem_Pedido, p.Pnome, ip.Qtd, (ip.Qtd * 50.00) AS Valor_Total
FROM itens_pedido ip
JOIN produto p ON p.Idproduto = ip.IdProduto;

-- 4. Ordenação
SELECT c.idCliente, COALESCE(cf.Pnome, cj.Razao_Social) AS Nome, c.CEP
FROM cliente c
LEFT JOIN cliente_fisico cf ON cf.IdCliente = c.idCliente
LEFT JOIN cliente_juridico cj ON cj.IdCliente = c.idCliente
ORDER BY c.CEP ASC;

-- 5. Agrupamento com HAVING
SELECT IdCliente, COUNT(*) AS TotalPedidos
FROM pedido
GROUP BY IdCliente
HAVING COUNT(*) > 1;

-- 6. Junção simples
SELECT f.Razao_Social AS Fornecedor, p.Pnome AS Produto
FROM fornecxproduto fp
JOIN fornecedor f ON f.idFornecedor = fp.IdFornecedor
JOIN produto p ON p.Idproduto = fp.IdProduto;

-- 7. Junção complexa
SELECT p.Pnome AS Produto, f.Razao_Social AS Fornecedor, e.Localizacao AS Estoque, qe.Qtd
FROM qtd_estoque qe
JOIN produto p ON p.Idproduto = qe.IdProduto
JOIN estoque e ON e.idEstoque = qe.IdEstoque
JOIN fornecxproduto fp ON fp.IdProduto = p.Idproduto
JOIN fornecedor f ON f.idFornecedor = fp.IdFornecedor;

-- 8. Algum vendedor também é fornecedor?
SELECT t.Razao_Social AS Nome, 'Sim' AS EhFornecedor
FROM terceiros t
JOIN fornecedor f ON f.Razao_Social = t.Razao_Social;

