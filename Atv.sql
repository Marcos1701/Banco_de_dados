1) 
select * from categoria where valor_dia between 100 and  200;

2)
select * from categoria where nome ilike '%luxo%';


3)
select nome from categoria where cod_cat in (
	select cod_cat from apartamento where num in(
		select num from hospedagem where dt_ent <= (now() - interval '5 years')
));

4)
select * from apartamento where num in(
	select num from hospedagem where dt_sai is null);
	
5)
select * from apartamento where cod_cat in(1, 2, 3, 11, 34, 54, 24, 12)

6)
select * from apartamento where cod_cat in(
	select cod_cat from categoria where nome ilike 'luxo%');
	
7)
select  count(num) Quantidade_de_Apto from apartamento;

8)
select sum(valor_dia) somatorio_resultante from categoria;

9)
select avg(valor_dia) media_resultante from categoria;

10)
select max(valor_dia) maior_preco_cat from categoria;

11)
select min(valor_dia) menor_preco_cat from categoria;

12)
select cod_hosp codigo_hosp, avg(valor_dia) media_resultante from categoria ca,apartamento ap, hospedagem h
   where ca.cod_cat = ap.cod_cat and h.num = ap.num
   group by cod_hosp;
   
select h1.nome nome_hosp, avg(valor_dia) media_resultante from 
  categoria ca natural join apartamento ap natural join hospedagem h join hospede h1 on h1.cod_hosp = h.cod_hosp
   group by h1.nome;
   
13)
SELECT ca.NOME CATEGORIA, COUNT(num) QUANTIDADE
FROM APARTAMENTO ap
JOIN CATEGORIA ca ON ap.COD_CAT = ca.COD_CAT
GROUP BY ca.NOME;

14)
select ca.cod_cat codigo_cat, ca.nome nome_cat from
   categoria ca join apartamento ap on ca.cod_cat = ap.cod_cat
     group by ca.cod_cat, ca.nome having count(ap.num) >= 2;
	
15)
select nome from hospede where dt_nasc > '1970-01-01'

16)
select count(*) quantidade_hospedes from hospede

17)
select h.num numero_apartamento from hospedagem h 
    group by h.num having count(*) >= 2;

18)
alter table hospede add nacionalidade varchar(20)
update hospede 
 set nacionalidade = 'Brasileiro'
   where cod_hosp in (1, 3);
 
update hospede 
 set nacionalidade = 'Argentino'
   where cod_hosp = 2;
 
19)
select nacionalidade, count(nome) quantidade from hospede
  group by nacionalidade
 
20)
select min(dt_nasc) data_nascimento from hospede

21)
select max(dt_nasc) data_nascimento from hospede

22)
update categoria
set valor_dia = valor_dia * 0.1 + valor_dia

23)
select nome from categoria where 
   cod_cat not in(select ca.cod_cat from categoria ca join apartamento ap on
				  ca.cod_cat = ap.cod_cat);

24)
select num numero_apto from apartamento where
  num not in(select ap.num from apartamento ap join hospedagem h on
			  ap.num = h.num)

insert into apartamento values(110, 'L', 3);

25)

select ap.num, valor_dia from hospede h1, hospedagem h, apartamento ap, categoria ca 
  where h1.cod_hosp = h.cod_hosp and h.num = ap.num and ap.cod_cat = ca.cod_cat 
         and h1.nome ilike 'João%';
  
SELECT ap.num numero, valor_dia diaria_paga 
	FROM hospede h1 
	JOIN hospedagem h ON h1.cod_hosp = h.cod_hosp 
	JOIN apartamento ap ON h.num = ap.num 
	JOIN categoria ca ON ap.cod_cat = ca.cod_cat 
		WHERE h1.nome ILIKE 'João%' 
			ORDER BY valor_dia DESC 
			LIMIT 1;

order by - ordena os valores (desc - decrescente, asc -  crescente)
limit - limita a quantidade de valores que serão exibidos/retornados

26)
select nome from hospede where
  cod_hosp not in(select cod_hosp from hospedagem where
				   num = 201)
				   
27)

select nome from hospede where
  cod_hosp not in(select cod_hosp from hospedagem where
				   num in (select num from apartamento ap join categoria ca on
						     ap.cod_cat = ca.cod_cat and nome ilike 'luxo'))
