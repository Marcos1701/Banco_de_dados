1)
select nome, dt_nasc data_nascimento from hospede
 order by nome asc, dt_nasc desc;
 
 
2) 
select nome Categoria from categoria
 order by nome;

3)
SELECT NUM NUMERO, VALOR_DIA DIARIA FROM APARTAMENTO NATURAL JOIN CATEGORIA
   ORDER BY VALOR_DIA DESC;
  
4)
SELECT NOME NOME_CATEGORIA, COUNT(NUM) QTD_APTO FROM APARTAMENTO NATURAL JOIN CATEGORIA
  GROUP BY NOME HAVING COUNT(NUM) = 1;
  
5)
SELECT NOME, DT_NASC FROM HOSPEDE 
WHERE NACIONALIDADE ILIKE 'BRASILEIRO'
 ORDER BY NOME, DT_NASC DESC;
 
 insert into hospede values
    (4, 'Carlos Barreto', '1991-05-14', 'brasileiro'),
	(5, 'Carla Maria', '2001-11-04', 'brasileiro'),
	(6, 'Andressa Rita', '1989-02-24', 'brasileiro')
  
6)
select nome, num, count(num) from hospede natural join hospedagem
  group by num, nome
  
7)
select nome categoria from categoria where
  (select length(nome)) > 15;
  
insert into categoria values
  (5, 'Luxo com varanda e open bar incluso', 350)

8)
select ap.num, nome from 
  hospedagem natural join apartamento ap natural join categoria
   where dt_ent between '2017-01-01' and '2017-12-31'
   
   select * from apartamento
   select * from hospedagem
insert into hospedagem values
  (6, 4, 110, '2017-05-12', '2017-05-20'),
  (7, 5, 102, '2017-07-10', '2017-07-20')
  
9) não dá de fazer..
  
10)
create table funcionario(
   cod_func int not null primary key,
   nome varchar(100) not null,
   dt_nasc date not null,
   salario float not null
);

alter table hospedagem add cod_func int;

insert into funcionario values
  (1, 'José Abreu', '2000-03-12', 1200.00),
  (2, 'Antonio Carlos', '1996-10-02', 1350.00),
  (3, 'Miguel Santos', '1992-12-04', 1270.50),
  (4, 'Samuel Miranda', '1999-06-20', 1900.00)

update funcionario
set salario = 1200.00
where cod_func = 1;

update funcionario
set salario = 1350.00
where cod_func = 2;

update funcionario
set salario = 1270.50
where cod_func = 3;

update funcionario
set salario = 1900.00
where cod_func = 4;
 
update hospedagem
set cod_func = 1
 where cod_hospeda in (1,4,7);

update hospedagem
set cod_func = 2
 where cod_hospeda in (2,3);

update hospedagem
set cod_func = 3
 where cod_hospeda = 5;

update hospedagem
set cod_func = 4
 where cod_hospeda = 6

11)

update funcionario
set salario = retorno.sa + (10 * retorno.qtd) from (
   select cod_func cod, salario sa, count(*) qtd from funcionario natural join hospedagem
      group by cod_func, salario
	order by cod
) retorno 
where cod_func = retorno.cod;

select nome,salario from funcionario

select cod_func codigo_funcionario, nome, salario from(
    
update (select * from funcionario fu)
set salario = salario + (qtd * 10)
	from (select cod_func, count(*) from funcionario
		    natural join hospedagem
		    group by cod_func) h
where fu.cod_func = h.cod_func
	returning *;
) retorno; //não funciona 'ainda'...


12)
select num numero, nome categoria, count(num) from apartamento 
natural join categoria
group by num, nome
order by num, nome;

13)

SELECT NOME CATEGORIA, 
       COALESCE(NUM::text, 'não possui apartamento') NUMERO_APARTAMENTO
FROM CATEGORIA cat
LEFT JOIN APARTAMENTO ap ON cat.COD_CAT = ap.COD_CAT
ORDER BY NOME, NUM;

SELECT COALESCE(NOME::text, 'não possui categoria') CATEGORIA, 
       COALESCE(NUM::text, 'não possui apartamento') NUMERO_APARTAMENTO
FROM CATEGORIA cat
FULL JOIN APARTAMENTO ap ON cat.COD_CAT = ap.COD_CAT
ORDER BY NOME, NUM;

::text - converte número do apartamento em texto, pois a função 
COALESCE exige que todos os argumentos tenham o mesmo tipo.

coalese - recebe um valor a ser analisado e um valor_padrão, quando o valor
 analisado é nulo ele é substituído pelo valor_padrão
 
LEFT JOIN - faz a junção das tabelas, "como qualquer outro tipo de join",
 mas ao invés de descartar as colunas que não atendem á condição, ele apenas pre-
 enche a parte da tabela sem a correspondencia desejada com valores nulos no lugar dos
 valores originais...
  resposta mais detalhada:
   O LEFT JOIN no PostgreSQL é uma operação de junção (JOIN) que retorna todas as 
   linhas da tabela à esquerda (a tabela que vem antes da palavra-chave LEFT JOIN) 
   e as correspondentes linhas da tabela à direita (a tabela que vem depois da 
   palavra-chave LEFT JOIN), se houverem. Se não houver correspondência na tabela à direita, as colunas 
   correspondentes na linha resultante serão preenchidas com valores NULL.

14)

select nome nome_funcionario from funcionario where
 cod_func in(
	 select cod_func from hospede h
	 natural join hospedagem 
	 natural join apartamento ap 
	 join categoria cat on ap.cod_cat = cat.cod_cat
     where h.nome ilike 'João%' or cat.nome ilike 'Luxo')
	 

	 
15)

select cod_hospeda codigo_hospedagem from hospedagem
where cod_hosp = (select cod_hosp from hospedagem 
	natural join hospede
	natural join apartamento ap
	join categoria cat on ap.cod_cat = cat.cod_cat
	where 
 	 valor_dia = (select max(valor_dia) from categoria) and 
 	 dt_nasc = (select max(dt_nasc) from hospedagem 
	  natural join hospede
	  natural join apartamento ap
	  join categoria cat on ap.cod_cat = cat.cod_cat
	   where 
 	  valor_dia = (select max(valor_dia) from categoria))
  	limit 1)
  
  select * from hospedagem
  order by cod_hospeda
  insert into hospedagem values
  (8,4,101,'2023-03-10',NULL,3)
  
16)
select h1.nome from hospede h1 join hospede h2 on h2.cod_hosp = 2
  where h1.dt_nasc = h2.dt_nasc and (h1.cod_hosp <> h2.cod_hosp)
  
select * from hospede

insert into hospede values
(7, 'José Ribamar','1990-09-15', 'Paraguaio')

17)
select h.nome from hospede h
natural join hospedagem
where
 (dt_ent between '2017-01-01' and '2017-12-31') and dt_nasc = (
	 select min(dt_nasc) from hospede
	natural join hospedagem
 	(dt_ent between '2017-01-01' and '2017-12-31'))
	

select nome from hospede 
natural join hospedagem
where
 (dt_ent between '2017-01-01' and '2017-12-31')
order by dt_nasc
limit 1;

18)
select cat.nome categoria from hospede ho
natural join hospedagem h
natural join apartamento ap
join funcionario f on f.cod_func = h.cod_func
join categoria cat on cat.cod_cat = ap.cod_cat
where
ho.nome ilike 'Maria%' or (ho.nome ilike 'João%' and f.nome ilike 'Joaquim%')


select * from funcionario
insert into funcionario values
(5, 'Joaquim Santos', '1990-12-30', 1250.00)

select * from hospedagem
order by cod_hospeda

insert into hospedagem values
(9,1,102,'2023-02-13', '2023-02-16',5)

19)
select f.nome, f.dt_nasc data_nascimento, max(valor_dia) maior_diaria_pega from funcionario f 
natural join hospedagem
natural join apartamento ap
join categoria ca on ap.cod_cat = ca.cod_cat
group by f.cod_func

20)
select nome, count(num) qtd_apartamentos_ocupados from hospede
natural join hospedagem
group by cod_hosp

21)
select h.nome, dt_ent data_entrada, coalesce(dt_sai::text, 'Ainda não saiu..'), valor_dia valor_diaria
from hospede h
natural join hospedagem
natural join apartamento ap
join categoria ca on ap.cod_cat = ca.cod_cat;

22)
select distinct nome from hospede ho
natural join hospedagem h
natural join apartamento
where not exists 
 (select 1 from apartamento
  where num not in (
	  select num from hospedagem h
	   where h.cod_hosp = ho.cod_hosp and num is not null
   )
  )

select * from hospedagem
order by cod_hospeda

insert into hospedagem values
(5,1,110,'2023-02-16', '2023-02-20'),
(10,1,103,'2023-02-26', '2023-03-01')

update hospedagem
set num = 110
where cod_hospeda = 5

select * from apartamento
