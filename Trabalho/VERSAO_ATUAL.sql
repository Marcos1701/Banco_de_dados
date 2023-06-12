-- ESTA É A VERSÃO MAIS ATUAL DO TRABALHO..

-- Tabela FORNECEDOR
CREATE TABLE FORNECEDOR (
  COD_FORNECEDOR SERIAL PRIMARY KEY,
  NOME_FOR VARCHAR(100) NOT NULL,
  CONTATO VARCHAR(100) NOT NULL,
  CEP CHAR(8) NOT NULL
);

-- Tabela CATEGORIA
CREATE TABLE CATEGORIA (
  COD_CATEGORIA SERIAL PRIMARY KEY,
  NOME_CAT VARCHAR(50)
);

-- Tabela PRODUTO
CREATE TABLE PRODUTO (
  COD_PRODUTO SERIAL PRIMARY KEY,
  NOME_PROD VARCHAR(50),
  COD_CATEGORIA INT,
  VALOR_UNITARIO REAL,
  QUANT_ESTOQUE INT,
  STATUS CHAR(1), -- V = Vendável, N = Não Vendável
  FOREIGN KEY (COD_CATEGORIA) REFERENCES CATEGORIA(COD_CATEGORIA)
);

-- Tabela INGREDIENTE
CREATE TABLE INGREDIENTE (
  COD_INGREDIENTE INT REFERENCES PRODUTO(COD_PRODUTO) PRIMARY KEY, -- INGREDIENTE É UM PRODUTO, PODENDO SER VENDÁVEL OU NÃO..
  COD_PRODUTO INT NOT NULL, -- PRODUTO EM QUE O INGREDIENTE É UTILIZADO
  QUANTIDADE_NECESSARIA INT NOT NULL,
  FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTO(COD_PRODUTO)
);

-- Tabela MESA
CREATE TABLE MESA (
  COD_MESA INT PRIMARY KEY,
  CAPACIDADE INT
);

-- Tabela ATENDENTE
CREATE TABLE ATENDENTE (
  COD_ATENDENTE SERIAL PRIMARY KEY,
  NOME_ATEND VARCHAR(50)
);

-- Tabela COMPRA
CREATE TABLE COMPRA (
  COD_COMPRA SERIAL PRIMARY KEY,
  VALOR_TOTAL_COMPRA INT NOT NULL,
  DATA_COMPRA TIMESTAMP DEFAULT NOW()
);

-- Tabela COTACAO_ATUAL
CREATE TABLE COTACAO_ATUAL (
  COD_COT SERIAL PRIMARY KEY,
  COD_PRODUTO INT NOT NULL,
  COD_FORNECEDOR INT NOT NULL,
  PRECO_PRODUTO REAL NOT NULL,
  FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTO (COD_PRODUTO),
  FOREIGN KEY (COD_FORNECEDOR) REFERENCES FORNECEDOR (COD_FORNECEDOR)
);

-- Tabela PEDIDO
CREATE TABLE PEDIDO (
  COD_PEDIDO SERIAL PRIMARY KEY,
  COD_MESA INT,
  COD_ATENDENTE INT,
  DATA_PEDIDO TIMESTAMP DEFAULT NOW(),
  VALOR_TOTAL_PEDIDO REAL,
  STATUS CHAR(1), -- F => FECHADO (PAGO), A => ABERTO (AINDA NÃO HOUVE O PAGAMENTO)
  FOREIGN KEY (COD_MESA) REFERENCES MESA(COD_MESA),
  FOREIGN KEY (COD_ATENDENTE) REFERENCES ATENDENTE(COD_ATENDENTE)
);

-- Tabela PRODUTO_PEDIDO
CREATE TABLE PRODUTO_PEDIDO (
  COD PROD_PED SERIAL PRIMARY KEY,
  COD_PEDIDO INT,
  COD_PRODUTO INT,
  QUANTIDADE_ITEMP INT,
  VALOR_TOTAL_ITEMP REAL
  FOREIGN KEY (COD_PEDIDO) REFERENCES PEDIDO(COD_PEDIDO),
  FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTO(COD_PRODUTO)
);

-- Tabela PRODUTO_COMPRA
CREATE TABLE PRODUTO_COMPRA (
  COD_PROD_COMP SERIAL PRIMARY KEY,
  COD_COMPRA INT,
  COD_PRODUTO INT,
  COD_FORNECEDOR INT,
  QUANTIDADE_ITEMC INT,
  VALOR_TOTAL_ITEMC REAL,
  FOREIGN KEY (COD_COMPRA) REFERENCES COMPRA(COD_COMPRA),
  FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTO(COD_PRODUTO),
  FOREIGN KEY (COD_FORNECEDOR) REFERENCES FORNECEDOR (COD_FORNECEDOR)
);


-- Execute o resultado do SELECT acima para deletar as tabelas

CREATE FUNCTION ADICIONA_VALORES(INICIAL_TABLE VARCHAR,PARAMETRO_1 VARCHAR)
RETURNS VOID as $$
BEGIN

IF(INICIAL_TABLE ilike 'ATENDENTE') then
  insert into atendente values(DEFAULT,PARAMETRO_1);
  RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela ATENDENTE';
elsif (INICIAL_TABLE ilike 'CATEGORIA') then
  insert into categoria values(DEFAULT, PARAMETRO_1);
  RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela CATEGORIA';
else
 raise exception 'Ops, nenhuma tabela foi encontrada, revise os parametros passados..';
end if;
END;
$$
LANGUAGE PLPGSQL;

CREATE FUNCTION ADICIONA_VALORES(NAME_TABLE VARCHAR,COD INT,PARAMETRO_1 INT) -- Param_1 => CAPACIDADE
RETURNS VOID as $$
BEGIN

IF(NAME_TABLE ilike 'MESA') then
  insert into atendente values(COD,PARAMETRO_1);
  RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela MESA';
else
 raise exception 'Ops, nenhuma tabela foi encontrada, revise os parametros passados..';
end if;
END;
$$
LANGUAGE PLPGSQL;

CREATE FUNCTION ADICIONA_VALORES(NAME_TABLE VARCHAR,PARAMETRO_1 VARCHAR(100),  -- P1 -> NOME_FOR, P2 ->CONTATO
								 PARAMETRO_2 varchar(100), PARAMETRO_3 char(8)) -- P3 -> CEP
RETURNS VOID as $$
BEGIN

IF(NAME_TABLE ilike 'FORNECEDOR') then
  insert into FORNECEDOR values(DEFAULT,PARAMETRO_1,  PARAMETRO_2, PARAMETRO_3);
  RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela FORNECEDOR';
else
 raise exception 'Ops, nenhuma tabela foi encontrada, revise os parametros passados..';
end if;
END;
$$
LANGUAGE PLPGSQL;


CREATE FUNCTION ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 VARCHAR(50), -- P1 -> NOME_PROD, P2 -> COD_CATEGORIA
                                 PARAMETRO_2 INT, PARAMETRO_3 REAL, -- P3 -> REAL, P4 -> QUANT_ESTOQUE
                                 PARAMETRO_4 INT, PARAMETRO_5 CHAR(1)) -- P5 -> STATUS
RETURNS VOID AS $$
BEGIN
  IF(NAME_TABLE ILIKE 'PRODUTO') THEN
    INSERT INTO produto VALUES (DEFAULT, PARAMETRO_1, PARAMETRO_2, PARAMETRO_3, PARAMETRO_4, PARAMETRO_5, PARAMETRO_6);
    RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela PRODUTO';
  ELSE
    RAISE EXCEPTION 'Ops, nenhuma tabela foi encontrada, revise os parâmetros passados..';
  END IF;
END;
$$
LANGUAGE PLPGSQL;

CREATE FUNCTION ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 INT, --P1 -> COD_INGREDIENTE, P2 -> COD_PRODUTO
                                 PARAMETRO_2 INT, PARAMETRO_3 INT) -- P3 -> QUANTIDADE_NECESSARIA
RETURNS VOID AS $$
BEGIN
  IF(NAME_TABLE ILIKE 'INGREDIENTE') THEN
    INSERT INTO ingrediente VALUES (DEFAULT, PARAMETRO_1, PARAMETRO_2, PARAMETRO_3);
    RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela INGREDIENTE';
  ELSE
    RAISE EXCEPTION 'Ops, nenhuma tabela foi encontrada, revise os parâmetros passados..';
  END IF;
END;
$$
LANGUAGE PLPGSQL;

CREATE FUNCTION ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 INT,
                                 PARAMETRO_2 REAL)
RETURNS VOID AS $$
BEGIN
  IF(NAME_TABLE ILIKE 'COMPRA') THEN
    INSERT INTO compra VALUES (DEFAULT, PARAMETRO_1, PARAMETRO_2, DEFAULT);
    RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela COMPRA';
  ELSE
    RAISE EXCEPTION 'Ops, nenhuma tabela foi encontrada, revise os parâmetros passados..';
  END IF;
END;
$$
LANGUAGE PLPGSQL;

CREATE FUNCTION ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 INT,
                                 PARAMETRO_2 INT, PARAMETRO_3 INT, PARAMETRO_4 REAL)
RETURNS VOID AS $$
BEGIN
  IF(NAME_TABLE ILIKE 'PRODUTO_PEDIDO') THEN
    INSERT INTO PRODUTO_PEDIDO VALUES (DEFAULT, PARAMETRO_1, PARAMETRO_2, PARAMETRO_3, PARAMETRO_4);
    RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela PRODUTO_PEDIDO';
  ELSE
    RAISE EXCEPTION 'Ops, nenhuma tabela foi encontrada, revise os parâmetros passados..';
  END IF;
END;
$$
LANGUAGE PLPGSQL;

CREATE FUNCTION ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 INT,
                                 PARAMETRO_2 INT, PARAMETRO_3 REAL)
RETURNS VOID AS $$
BEGIN
  IF(NAME_TABLE ILIKE 'COTACAO_ATUAL') THEN
    INSERT INTO cotacao_atual VALUES (DEFAULT, PARAMETRO_1, PARAMETRO_2, PARAMETRO_3);
    RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela COTACAO_ATUAL';
  ELSE
    RAISE EXCEPTION 'Ops, nenhuma tabela foi encontrada, revise os parâmetros passados..';
  END IF;
END;
$$
LANGUAGE PLPGSQL;

CREATE FUNCTION ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 INT,
                                 PARAMETRO_2 INT, PARAMETRO_3 INT, PARAMETRO_4 REAL)
RETURNS VOID AS $$
BEGIN
	IF(NAME_TABLE ILIKE 'PRODUTO_COMPRA') THEN
    	INSERT INTO PRODUTO_COMPRA VALUES (DEFAULT, PARAMETRO_1, PARAMETRO_2, PARAMETRO_3, PARAMETRO_4);
    	RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela PRODUTO_COMPRA';
	ELSE
    	RAISE EXCEPTION 'Ops, nenhuma tabela foi encontrada, revise os parâmetros passados..';
  END IF;
END;
$$
LANGUAGE PLPGSQL;


CREATE FUNCTION ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 INT,
                                 PARAMETRO_2 INT, PARAMETRO_3 REAL, PARAMETRO_4 char(1))
RETURNS VOID AS $$
BEGIN
	IF(NAME_TABLE ILIKE 'PEDIDO') THEN
    	INSERT INTO PEDIDO VALUES (DEFAULT, PARAMETRO_1, PARAMETRO_2,DEFAULT, PARAMETRO_3, PARAMETRO_4);
    	RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela PEDIDO';
	ELSE
    	RAISE EXCEPTION 'Ops, nenhuma tabela foi encontrada, revise os parâmetros passados..';
  END IF;
END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION REALIZA_PEDIDO(MESA_ID INT, PRODUTO_ID INT, QUANTIDADE INT,ATENDENTE_ID INT, PEDIDO_ID INT DEFAULT NULL)
RETURNS VOID AS $$
DECLARE
  ID_PEDIDO INT;
  VALOR_TOTAL REAL;
BEGIN

	IF NOT EXISTS (SELECT * FROM PRODUTO WHERE COD_PRODUTO = PRODUTO_ID) THEN
	 	RAISE EXCEPTION 'PRODUTO INVÁLIDO OU INEXISTENTE!!';
	ELSIF EXISTS (SELECT * FROM PRODUTO WHERE COD_PRODUTO = PRODUTO_ID AND
		QUANT_ESTOQUE < QUANTIDADE) THEN
       RAISE EXCEPTION 'OPS, A QUANTIDADE EM ESTOQUE É INSUFICIENTE..';
	END IF;

	SELECT VALOR_TOTAL * QUANTIDADE INTO VALOR_TOTAL FROM PRODUTO 
	  WHERE COD_PRODUTO = PRODUTO_ID;
	  
	 UPDATE PRODUTO 
	  SET QUANT_ESTOQUE = QUANT_ESTOQUE - QUANTIDADE
	  WHERE COD_PRODUTO = PRODUTO_ID;
	  
	 IF EXISTS (SELECT * FROM INGREDIENTE WHERE COD_PRODUTO = PRODUTO_ID) THEN
	   FOR INGREDIENTE IN (SELECT * FROM INGREDIENTE WHERE COD_PRODUTO = PRODUTO_ID) LOOP
	     UPDATE PRODUTO
		 SET QUANT_ESTOQUE = QUANT_ESTOQUE - INGREDIENTE.QUANTIDADE_NECESSARIA
		 WHERE COD_PRODUTO = INGREDIENTE.COD_INGREDIENTE;
	   END LOOP;
	 END IF;
		 

    IF(PEDIDO_ID IS NULL) THEN
        SELECT ADICIONA_VALORES('PEDIDO', MESA_ID, ATENDENTE_ID, VALOR_TOTAL, 'A');
        SELECT MAX(PEDIDO_ID) INTO PEDIDO_ID FROM pedido;
	ELSE
	  	ID_PEDIDO := PEDIDO_ID;
	    UPDATE PEDIDO
		SET 
			VALOR_TOTAL_PEDIDO = VALOR_TOTAL_PEDIDO + VALOR_TOTAL
		WHERE
		    COD_PEDIDO = PEDIDO_ID;
    END IF;

    IF NOT EXISTS (SELECT * FROM PRODUTO_PEDIDO WHERE COD_PEDIDO = PEDIDO_ID AND COD_PRODUTO = PRODUTO_ID) THEN
		SELECT ADICIONA_VALORES('PRODUTO_PEDIDO', PEDIDO_ID,PRODUTO_ID, QUANTIDADE, VALOR_TOTAL);
    ELSE
        UPDATE PRODUTO_PEDIDO 
		SET QUANTIDADE_ITEMP = QUANTIDADE_ITEMP + QUANTIDADE,
		VALOR_TOTAL_ITEMP = VALOR_TOTAL_ITEMP + VALOR_TOTAL
		WHERE COD_PROD_PED = PEDIDO_ID AND COD_PRODUTO = PRODUTO_ID;
    END IF;
    
    RAISE NOTICE 'Pedido realizado com sucesso!';
    END;
$$
LANGUAGE PLPGSQL;
