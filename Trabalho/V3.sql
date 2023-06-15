drop schema public cascade;
create schema public;

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
  FOREIGN KEY (COD_CATEGORIA) REFERENCES CATEGORIA(COD_CATEGORIA) ON DELETE CASCADE
);

-- Tabela INGREDIENTE
CREATE TABLE INGREDIENTE (
  COD_INGREDIENTE INT REFERENCES PRODUTO(COD_PRODUTO) PRIMARY KEY, -- INGREDIENTE É UM PRODUTO, PODENDO SER VENDÁVEL OU NÃO..
  COD_PRODUTO INT NOT NULL, -- PRODUTO EM QUE O INGREDIENTE É UTILIZADO
  QUANTIDADE_NECESSARIA INT NOT NULL,
  FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTO(COD_PRODUTO) ON DELETE CASCADE
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
  FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTO (COD_PRODUTO) ON DELETE CASCADE,
  FOREIGN KEY (COD_FORNECEDOR) REFERENCES FORNECEDOR (COD_FORNECEDOR) ON DELETE CASCADE
);

-- Tabela PEDIDO
CREATE TABLE PEDIDO (
  COD_PEDIDO SERIAL PRIMARY KEY,
  COD_MESA INT,
  COD_ATENDENTE INT,
  DATA_PEDIDO TIMESTAMP DEFAULT NOW(),
  VALOR_TOTAL_PEDIDO REAL,
  STATUS CHAR(1) DEFAULT 'A', -- F => FECHADO (PAGO), A => ABERTO (AINDA NÃO HOUVE O PAGAMENTO)
  FOREIGN KEY (COD_MESA) REFERENCES MESA(COD_MESA) ON DELETE CASCADE,
  FOREIGN KEY (COD_ATENDENTE) REFERENCES ATENDENTE(COD_ATENDENTE) ON DELETE CASCADE
);

-- Tabela PRODUTO_PEDIDO
CREATE TABLE PRODUTO_PEDIDO (
  COD_PROD_PED SERIAL PRIMARY KEY,
  COD_PEDIDO INT,
  COD_PRODUTO INT,
  QUANTIDADE_ITEMP INT,
  VALOR_TOTAL_ITEMP REAL,
  FOREIGN KEY (COD_PEDIDO) REFERENCES PEDIDO(COD_PEDIDO) ON DELETE CASCADE,
  FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTO(COD_PRODUTO) ON DELETE CASCADE
);

-- Tabela PRODUTO_COMPRA
CREATE TABLE PRODUTO_COMPRA (
  COD_PROD_COMP SERIAL PRIMARY KEY,
  COD_COMPRA INT,
  COD_PRODUTO INT,
  QUANTIDADE_ITEMC INT,
  VALOR_TOTAL_ITEMC REAL,
  FOREIGN KEY (COD_COMPRA) REFERENCES COMPRA(COD_COMPRA) ON DELETE CASCADE,
  FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTO(COD_PRODUTO) ON DELETE CASCADE
);


SELECT ADICIONA_VALORES('FORNECEDOR','João Silva','40028922', '12345678');
SELECT ADICIONA_VALORES('FORNECEDOR','Maria Santos','32230197', '87654321');
SELECT ADICIONA_VALORES('FORNECEDOR','Pedro Almeida','32240816', '98765432');
SELECT * FROM FORNECEDOR;
-- Tabela CATEGORIA
SELECT ADICIONA_VALORES('CATEGORIA','Categoria A');
SELECT ADICIONA_VALORES('CATEGORIA','Categoria B');
SELECT ADICIONA_VALORES('CATEGORIA','Categoria C');

SELECT * FROM CATEGORIA;
-- Tabela PRODUTO
SELECT ADICIONA_VALORES('PRODUTO','Produto A', 1, 10.50, 100, 'V');
SELECT ADICIONA_VALORES('PRODUTO','Produto B', 2, 5.99, 50, 'V');
SELECT ADICIONA_VALORES('PRODUTO','Produto C', 1, 8.75, 75, 'V');

-- Tabela INGREDIENTE
SELECT ADICIONA_VALORES('INGREDIENTE',1, 3, 2);
SELECT ADICIONA_VALORES('INGREDIENTE',2, 2, 1);
SELECT ADICIONA_VALORES('INGREDIENTE',3, 1, 3);

-- Tabela MESA
SELECT ADICIONA_VALORES('MESA',1, 4);
SELECT ADICIONA_VALORES('MESA',2, 6);
SELECT ADICIONA_VALORES('MESA',3, 2);

-- Tabela ATENDENTE
SELECT ADICIONA_VALORES('ATENDENTE','José Alberto');
SELECT ADICIONA_VALORES('ATENDENTE','Carlos Andrade');
SELECT ADICIONA_VALORES('ATENDENTE','Alexandre Santana');

-- Tabela COMPRA
SELECT ADICIONA_VALORES('COMPRA',150);
SELECT ADICIONA_VALORES('COMPRA',250);
SELECT ADICIONA_VALORES('COMPRA',100);

-- Tabela COTACAO_ATUAL
SELECT ADICIONA_VALORES('COTACAO_ATUAL',1, 1, 9.99);
SELECT ADICIONA_VALORES('COTACAO_ATUAL',2, 2, 4.50);
SELECT ADICIONA_VALORES('COTACAO_ATUAL',3, 3, 7.25);

-- Tabela PEDIDO
SELECT ADICIONA_VALORES('PEDIDO',1, 1, 50.75);
SELECT ADICIONA_VALORES('PEDIDO',2, 2, 80.20);
SELECT ADICIONA_VALORES('PEDIDO',3, 3, 30.50);

-- Tabela PRODUTO_PEDIDO
SELECT ADICIONA_VALORES('PRODUTO_PEDIDO',1, 1, 2, 21.00);
SELECT ADICIONA_VALORES('PRODUTO_PEDIDO',1, 2, 1, 5.99);
SELECT ADICIONA_VALORES('PRODUTO_PEDIDO',2, 3, 3, 26.25);

-- Tabela PRODUTO_COMPRA
SELECT ADICIONA_VALORES('PRODUTO_COMPRA',1, 1, 10, 99.90);
SELECT ADICIONA_VALORES('PRODUTO_COMPRA',2, 2, 5, 22.50);
SELECT ADICIONA_VALORES('PRODUTO_COMPRA',3, 3, 8, 58.00);


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
  insert into MESA values(COD,PARAMETRO_1);
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


CREATE OR REPLACE FUNCTION ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 VARCHAR(50), -- P1 -> NOME_PROD, P2 -> COD_CATEGORIA
                                 PARAMETRO_2 INT, PARAMETRO_3 REAL, -- P3 -> VALOR_UNITARIO , P4 -> QUANT_ESTOQUE
                                 PARAMETRO_4 INT, PARAMETRO_5 CHAR(1)) -- P5 -> STATUS
RETURNS VOID AS $$
BEGIN
  IF(NAME_TABLE ILIKE 'PRODUTO') THEN
    INSERT INTO produto VALUES (DEFAULT, PARAMETRO_1, PARAMETRO_2, PARAMETRO_3, PARAMETRO_4, PARAMETRO_5);
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

CREATE FUNCTION ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 REAL)
RETURNS VOID AS $$
BEGIN
  IF(NAME_TABLE ILIKE 'COMPRA') THEN
    INSERT INTO compra VALUES (DEFAULT, PARAMETRO_1, DEFAULT);
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
  ELSIF(NAME_TABLE ILIKE 'PRODUTO_COMPRA') THEN
    	INSERT INTO PRODUTO_COMPRA VALUES (DEFAULT, PARAMETRO_1, PARAMETRO_2, PARAMETRO_3, PARAMETRO_4);
    	RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela PRODUTO_COMPRA';
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
  ELSIF(NAME_TABLE ILIKE 'PEDIDO') THEN
    	INSERT INTO PEDIDO VALUES (DEFAULT, PARAMETRO_1, PARAMETRO_2,DEFAULT, PARAMETRO_3, DEFAULT);
    	RAISE NOTICE 'Os valores foram inseridos com sucesso na tabela PEDIDO';
  ELSE
    RAISE EXCEPTION 'Ops, nenhuma tabela foi encontrada, revise os parâmetros passados..';
  END IF;
END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION atualiza_valor_total_pedido()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE PEDIDO
    SET VALOR_TOTAL_PEDIDO = (
        SELECT SUM(VALOR_TOTAL_ITEMP)
        FROM PRODUTO_PEDIDO
        WHERE COD_PEDIDO = NEW.COD_PEDIDO
    )
    WHERE COD_PEDIDO = NEW.COD_PEDIDO;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER atualiza_valor_total_pedido_trigger
AFTER INSERT OR UPDATE ON PRODUTO_PEDIDO
FOR EACH ROW
EXECUTE PROCEDURE atualiza_valor_total_pedido();

CREATE OR REPLACE FUNCTION CONFERE_ESTOQUE()
RETURNS TRIGGER AS $$
DECLARE
	ING RECORD;
BEGIN

	IF(NEW.QUANT_ESTOQUE < 0) THEN
		IF(TG_OP ILIKE 'UPDATE') THEN
			RAISE EXCEPTION 'A QUANTIDADE DE ESTOQUE É INSUFICIENTE!!';
		ELSE
		    RAISE EXCEPTION 'A QUANTIDADE DE ESTOQUE NÃO PODE SER NEGATIVA!!';
		END IF;
	END IF;

	IF EXISTS (SELECT * FROM INGREDIENTE WHERE COD_PRODUTO = NEW.COD_PRODUTO) THEN
	   FOR ING IN (SELECT * FROM INGREDIENTE WHERE COD_PRODUTO = NEW.COD_PRODUTO) LOOP
	   		IF EXISTS(SELECT * FROM INGREDIENTE I JOIN PRODUTO ON I.COD_INGREDIENTE = ING.COD_PRODUTO
					  AND I.COD_PRODUTO = NEW.COD_PRODUTO WHERE QUANTIDADE_NECESSARIA > QUANT_ESTOQUE) THEN
					  RAISE EXCEPTION 'PRODUTO NÃO ADICIONADO, POIS SEUS INGREDIENTES SÃO INSUFICIENTES!!';  
			END IF;
	   END LOOP;
	 END IF;
	   RAISE NOTICE 'PRODUTO ADICIONADO COM SUCESSO!!';

END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER CONFERE_ESTOQUE_P
AFTER INSERT OR UPDATE ON PRODUTO
FOR EACH ROW
EXECUTE PROCEDURE CONFERE_ESTOQUE();

CREATE VIEW EXIBE_CARDAPIO AS
	SELECT NOME_PROD NOME_PRODUTO,VALOR_UNITARIO , NOME_CAT CATEGORIA
		FROM PRODUTO NATURAL JOIN CATEGORIA WHERE STATUS = 'V';

CREATE OR REPLACE FUNCTION REALIZA_PEDIDO(MESA_ID INT, PRODUTO_ID INT, QUANTIDADE INT,ATENDENTE_ID INT, PEDIDO_ID INT DEFAULT NULL)
RETURNS VOID AS $$
DECLARE
  ID_PEDIDO INT;
  VALOR_TOTAL REAL;
BEGIN

	IF NOT EXISTS (SELECT * FROM PRODUTO WHERE COD_PRODUTO = PRODUTO_ID) THEN
	 	RAISE EXCEPTION 'PRODUTO INVÁLIDO OU INEXISTENTE!!';
	END IF;

	SELECT VALOR_TOTAL * QUANTIDADE INTO VALOR_TOTAL FROM PRODUTO 
	  WHERE COD_PRODUTO = PRODUTO_ID;
	UPDATE PRODUTO
	SET QUANT_ESTOQUE = QUANT_ESTOQUE - QUANTIDADE
	WHERE COD_PRODUTO = PRODUTO_ID; 

    IF(PEDIDO_ID IS NULL) THEN
        SELECT ADICIONA_VALORES('PEDIDO', MESA_ID, ATENDENTE_ID, VALOR_TOTAL, 'A');
        SELECT MAX(PEDIDO_ID) INTO PEDIDO_ID FROM pedido;
	ELSE
	  	ID_PEDIDO := PEDIDO_ID;
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

CREATE OR REPLACE FUNCTION FECHAR_PEDIDO(COD_DA_MESA int)
RETURNS VOID AS $$
BEGIN 

	IF EXISTS(SELECT * FROM PEDIDO WHERE COD_MESA = COD_DA_MESA AND STATUS = 'A') THEN
		UPDATE PEDIDO
			SET STATUS = 'F'
		WHERE COD_MESA = COD_DA_MESA AND STATUS = 'A';
		RAISE NOTICE 'O PEDIDO FOI FECHADO COM SUCESSO!!';
	ELSE
		RAISE EXCEPTION 'PEDIDO NÃO ENCONTRADO!!';
	END IF;
	
END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION REALIZA_COMPRA(COD_PROD INT, QUANT INT, COD_DA_COMPRA INT DEFAULT NULL)
RETURNS VOID AS $$
DECLARE 
	COMPRA_ID INT;
	VALOR_TOTAL REAL;
	AUX INT;
	PROD RECORD;
BEGIN
	IF NOT EXISTS (SELECT * FROM PRODUTO WHERE COD_PRODUTO = COD_PROD) THEN
	 	RAISE EXCEPTION 'PRODUTO INVÁLIDO OU INEXISTENTE!!';
	END IF;

	SELECT (MIN(PRECO_PRODUTO) * QUANT) INTO VALOR_TOTAL FROM COTACAO_ATUAL
	  WHERE COD_PRODUTO = COD_PROD;
	  
	 IF VALOR_TOTAL IS NULL THEN
	    RAISE EXCEPTION 'Ops, não há correspondencia do produto solicitado na tabela cotacao_atual.';
	END IF;
	
	IF EXISTS (SELECT * FROM COMPRA WHERE COD_COMPRA = COD_DA_COMPRA) THEN
	   UPDATE COMPRA
	   SET VALOR_TOTAL_COMPRA = VALOR_TOTAL_COMPRA + VALOR_TOTAL
	   WHERE COD_COMPRA = COD_DA_COMPRA;
	   COMPRA_ID := COD_DA_COMPRA;
	ELSE 
	   SELECT ADICIONA_VALORES('COMPRA', VALOR_TOTAL);
	   SELECT MAX(COD_COMPRA) INTO COMPRA_ID FROM COMPRA;
	END IF;
	
	IF NOT EXISTS (SELECT * FROM PRODUTO_COMPRA WHERE COD_COMPRA = COMPRA_ID AND COD_PRODUTO = COD_PROD) THEN
	    SELECT ADICIONA_VALORES('PRODUTO_COMPRA',COMPRA_ID, COD_PROD,QUANT,VALOR_TOTAL);
	ELSE
	    UPDATE PRODUTO_COMPRA
		SET VALOR_TOTAL_ITEMC = VALOR_TOTAL_ITEMC + VALOR_TOTAL
		WHERE COD_COMPRA = COMPRA_ID AND COD_PRODUTO = COD_PROD;
		
	END IF;
	
	UPDATE PRODUTO
	SET QUANT_ESTOQUE = QUANT_ESTOQUE + QUANT
	WHERE COD_PRODUTO = COD_PROD;
	
	IF EXISTS(SELECT * FROM INGREDIENTE WHERE COD_INGREDIENTE = COD_PROD) THEN 
	  FOR PROD IN (SELECT * FROM INGREDIENTE WHERE COD_INGREDIENTE = COD_PROD) LOOP
	  	 IF NOT EXISTS (
			 SELECT * FROM INGREDIENTE I JOIN PRODUTO PR ON COD_INGREDIENTE = PR.COD_PRODUTO AND 
			   PROD.COD_PRODUTO = I.COD_PRODUTO
		       WHERE QUANT_ESTOQUE < QUANTIDADE_NECESSARIA
		   ) THEN
			   SELECT SUM(QUANT_ESTOQUE) / SUM(QUANTIDADE_NECESSARIA) INTO AUX
			   FROM INGREDIENTE I JOIN PRODUTO PR ON COD_INGREDIENTE = PR.COD_PRODUTO AND 
			   PROD.COD_PRODUTO = I.COD_PRODUTO;
			   
			   UPDATE PRODUTO
			   SET QUANT_ESTOQUE = AUX
			   WHERE COD_PRODUTO = PROD.COD_PRODUTO;
	    END IF;
	  END LOOP; 
	END IF;
	
	RAISE NOTICE 'COMPRA REALIZADA COM SUCESSO!!';
END;

$$
LANGUAGE PLPGSQL;

-- SELECT * FROM GERAR_COMISSAO();

CREATE OR REPLACE FUNCTION GERAR_COMISSAO(DT_INICIO TIMESTAMP DEFAULT NULL, DT_FIM TIMESTAMP DEFAULT NOW(), COD_ATENDE INT DEFAULT NULL, PORCENTAGEM_COMISSAO FLOAT DEFAULT 0.05)
RETURNS TABLE (
	NOME_ATENDENTE VARCHAR,
	COMISSAO REAL
) AS $$
BEGIN

 	IF COD_ATENDE IS NULL THEN
		IF DT_INICIO IS NULL THEN
		   RETURN QUERY (SELECT NOME_ATEND NOME_ATENDENTE, CAST((VALOR_TOTAL * PORCENTAGEM_COMISSAO) AS REAL) AS COMISSAO FROM (
		        			SELECT NOME_ATEND, SUM(VALOR_TOTAL_PEDIDO) VALOR_TOTAL FROM ATENDENTE NATURAL JOIN PEDIDO
			   					WHERE DATA_PEDIDO <= DT_FIM
		                       GROUP BY COD_ATENDENTE) AS TT);
		ELSE
		  RETURN QUERY (SELECT NOME_ATEND NOME_ATENDENTE, CAST((VALOR_TOTAL * PORCENTAGEM_COMISSAO) AS REAL) AS COMISSAO FROM (
		        			SELECT NOME_ATEND, SUM(VALOR_TOTAL_PEDIDO) VALOR_TOTAL FROM ATENDENTE NATURAL JOIN PEDIDO
			   					WHERE DATA_PEDIDO between DT_INICIO AND DT_FIM
		                       GROUP BY COD_ATENDENTE) AS TT);
		END IF;
	ELSE
		IF DT_INICIO IS NULL THEN
		   RETURN QUERY (SELECT NOME_ATEND NOME_ATENDENTE, CAST((VALOR_TOTAL * PORCENTAGEM_COMISSAO) AS REAL) AS COMISSAO FROM (
		        			SELECT NOME_ATEND, SUM(VALOR_TOTAL_PEDIDO) VALOR_TOTAL FROM ATENDENTE NATURAL JOIN PEDIDO
			   					WHERE DATA_PEDIDO <= DT_FIM AND COD_ATENDENTE = COD_ATENDE
		                       GROUP BY COD_ATENDENTE) AS TT);
		ELSE
		  RETURN QUERY (SELECT NOME_ATEND NOME_ATENDENTE, CAST((VALOR_TOTAL * PORCENTAGEM_COMISSAO) AS REAL) AS COMISSAO FROM (
		        			SELECT NOME_ATEND, SUM(VALOR_TOTAL_PEDIDO) VALOR_TOTAL FROM ATENDENTE NATURAL JOIN PEDIDO
			   					WHERE COD_ATENDENTE = COD_ATENDE AND DATA_PEDIDO between DT_INICIO AND DT_FIM 
		                       GROUP BY COD_ATENDENTE) AS TT);
		END IF;
	END IF;
END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION GERAR_RELATORIO_ATENDENTE(COD_ATENDE INT DEFAULT NULL)
RETURNS VOID AS $$
BEGIN

	IF COD_ATENDE IS NULL THEN
		SELECT NOME_ATEND NOME, SUM(VALOR_TOTAL_PEDIDO) VALOR_TOTAL_VENDAS, COUNT(VALOR_TOTAL_PEDIDO) QUANTIDADE_VENDAS
			FROM PEDIDO NATURAL JOIN ATENDENTE
				GROUP BY COD_ATENDENTE;
	ELSE
		SELECT NOME_ATEND NOME, SUM(VALOR_TOTAL_PEDIDO) VALOR_TOTAL_VENDAS, COUNT(VALOR_TOTAL_PEDIDO) QUANTIDADE_VENDAS
			FROM PEDIDO NATURAL JOIN ATENDENTE
				WHERE COD_ATENDENTE = COD_ATENDE;
	END IF;
END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION valida_preco_produto()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.PRECO_PRODUTO < 0 THEN
        RAISE EXCEPTION 'O preço do produto não pode ser menor que 0.';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER valida_preco_produto_trigger
BEFORE INSERT OR UPDATE ON COTACAO_ATUAL
FOR EACH ROW
EXECUTE PROCEDURE valida_preco_produto();


CREATE GROUP ATENDENTE_G;
CREATE GROUP GERENTE;
GRANT CREATEUSER TO GERENTE;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO GERENTE WITH GRANT OPTION;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public  TO GERENTE WITH GRANT OPTION;
GRANT SELECT ON MESA, COTACAO_ATUAL TO ATENDENTE_G WITH GRANT OPTION;
GRANT INSERT, UPDATE, DELETE ON PRODUTO, COMPRA, PEDIDO, PRODUTO_PEDIDO, PRODUTO_COMPRA TO ATENDENTE_G WITH GRANT OPTION;

GRANT EXECUTE ON FUNCTION
ADICIONA_VALORES(NAME_TABLE VARCHAR,COD INT,PARAMETRO_1 INT), -- MESA
ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 REAL), -- COMPRA
ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 INT,PARAMETRO_2 INT, PARAMETRO_3 INT, PARAMETRO_4 REAL), -- PRODUTO_PEDIDO E PRODUTO_COMPRA
ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 INT,PARAMETRO_2 INT, PARAMETRO_3 REAL), -- PEDIDO
ADICIONA_VALORES(NAME_TABLE VARCHAR, PARAMETRO_1 INT,PARAMETRO_2 INT, PARAMETRO_3 REAL, PARAMETRO_4 char(1)), --
atualiza_valor_total_pedido(),
REALIZA_PEDIDO(MESA_ID INT, PRODUTO_ID INT, QUANTIDADE INT,ATENDENTE_ID INT, PEDIDO_ID INT), 
REALIZA_COMPRA(COD_PROD INT, QUANT INT, COD_DA_COMPRA INT) 
TO ATENDENTE_G WITH GRANT OPTION;

CREATE USER MARCIO WITH PASSWORD '1234' IN GROUP GERENTE;

CREATE USER MARCELO WITH PASSWORD '4321' IN GROUP ATENDENTE_G;

select * from GERAR_COMISSAO()
