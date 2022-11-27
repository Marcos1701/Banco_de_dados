select * from hospedagem join hospede 
on hospedagem.cod_hosp = hospede.cod_hosp
where hospede.nome = 'Marcos Eduardo' or 
hospede.nome = 'Ricardão da 09';