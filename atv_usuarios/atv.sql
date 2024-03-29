
	CREATE TABLE APARTAMENTO (
		NUM INT NOT NULL PRIMARY KEY,
		STATUS CHAR(1) NOT NULL
	);
	
	CREATE TABLE HOSPEDE (
		COD_HOSP INT NOT NULL,
		NOME VARCHAR(50) NOT NULL,
		idade int NOT NULL,
		CONSTRAINT PRI_HOSP PRIMARY KEY(COD_HOSP)
	);
	
	CREATE TABLE HOSPEDAGEM (
		COD_HOSPEDA SERIAL NOT NULL,
		COD_HOSP INT NOT NULL,
		NUM INT NOT NULL,
		DT_ENT DATE NOT NULL,
		DT_SAI DATE,
		CONSTRAINT PRI_HOSPEDA PRIMARY KEY(COD_HOSPEDA),
		CONSTRAINT EST_HOSP FOREIGN KEY(COD_HOSP) REFERENCES HOSPEDE(COD_HOSP),
		CONSTRAINT EST_APTO FOREIGN KEY(NUM) REFERENCES APARTAMENTO(NUM)
	);
	
	CREATE VIEW HOSPEDE_IDADE AS
	  SELECT NOME, IDADE FROM HOSPEDE;
	  
	 SELECT * FROM HOSPEDE_IDADE
	 
	 INSERT INTO HOSPEDE (COD_HOSP, NOME, IDADE) 
	VALUES 
		(1, 'João Silva', 19), 
		(2, 'Maria Santos', 25), 
		(3, 'Pedro Souza', 32);
		
		INSERT INTO APARTAMENTO (NUM, STATUS) 
	VALUES 
		(101, 'L'), 
		(102, 'L'), 
		(103, 'O');
		
	CREATE OR REPLACE FUNCTION HOSPEDA(COD INT, NUM_AP INT)
	  RETURNS TEXT AS $$
	  BEGIN
	    IF NOT EXISTS (SELECT COD_HOSP FROM HOSPEDE WHERE COD_HOSP = COD) THEN
		   RAISE EXCEPTION 'HOSPEDE INVÁLIDO!!';
		ELSIF NOT EXISTS (SELECT NUM FROM APARTAMENTO WHERE NUM = NUM_AP AND STATUS ilike 'L') then
		   RAISE EXCEPTION 'APARTAMENTO JÁ OCUPADO!!';
		END IF;
		INSERT INTO HOSPEDAGEM VALUES(DEFAULT,COD,NUM_AP,CURRENT_DATE,NULL);
		update apartamento
		 set STATUS = 'O'
		 where num = NUM_AP;
		RETURN 'Hospedagem realizada com sucesso!!';
	  
	  END
	  $$ LANGUAGE PLPGSQL;
	  
	 select HOSPEDA(2,102)
