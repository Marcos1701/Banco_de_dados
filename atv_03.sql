-- 1° Questão
CREATE TABLE ALUNO (
 MATRICULA VARCHAR(15) NOT NULL PRIMARY KEY,
 NOME VARCHAR(30)) 
 
 CREATE OR REPLACE FUNCTION INICIAL_NOME_A()
  RETURNS TRIGGER AS $CONFERE_NOME$
  BEGIN
   IF NEW.NOME ILIKE 'A%' THEN
   RAISE EXCEPTION 'Alunos com nomes iniciados com "a" não são permitidos';
   
   END IF;
     RETURN NEW;
  END;
  $CONFERE_NOME$
  LANGUAGE PLPGSQL;
  
  CREATE TRIGGER NAO_PERMITE_A 
  BEFORE INSERT OR UPDATE 
  ON ALUNO 
  FOR EACH ROW
  EXECUTE PROCEDURE
   INICIAL_NOME_A();
   
   
  INSERT INTO ALUNO VALUES('121', 'José'),('122','Alex')
  
  select * from aluno

-- 2° Questão
drop table funcionario
create table funcionario(
 cod int not null primary key,
 nome varchar(30) not null,
 sal int not null,
 dt_ult_at timestamp not null,
 usuario_que_at varchar(30) not null)
 
 create trigger t_inserir_valores
 before insert 
 on funcionario
 for each row
 execute procedure
  f_inserir_valores();
  
 create or replace function f_inserir_valores()
 returns trigger as $$
  begin
   if new.nome is null then
     raise exception 'O nome não pode ser nulo';
   end if;
   if new.sal <=0 or new.sal is null then
     raise exception '% não pode ter salario nulo ou negativo', new.nome;
   end if; 
     new.dt_ult_at = now();
	 new.usuario_que_at = current_user; 
    return new;
   end;
   $$
  language PLPGSQL;
  
insert into funcionario values(1,'Jose',100)

-- Questão 3

create table empregado(
 nome varchar not null,
 salario int not null);
 
create table empregado_audit(
 operacao char(1) not null,
 usuario varchar not null,
 data timestamp not null,
 nome varchar not null,
 salario int not null
 )


create trigger t_confere_op
 after insert or update or delete 
 on empregado
 for each row
 execute procedure
  f_confere_op();
  
 create or replace function f_confere_op()
 returns trigger as $$
  begin
    if (tg_op = 'DELETE') then
	  insert into empregado_audit select 'E', current_user, now(), old.*;
	elsif (tg_op = 'INSERT') then
	  insert into empregado_audit select 'I', current_user, now(), new.*;
	elsif (tg_op = 'UPDATE') then
	  insert into empregado_audit select 'A', current_user, now(), new.*;
	  end if;
    return new;
   end;
   $$
  language PLPGSQL;
  
  insert into empregado values
  ('Jose',100)
  
  update empregado
  set nome = 'Carlos'
  
  delete from empregado
  
  select * from empregado_audit
-- v2

create or replace function confere_nome()
  returns trigger as $$
  begin
  if (new.nome ilike 'a%') then
  raise exception 'Ops, nomes iniciados com "a" não são permitidos';
  
  end if;
  
  end;
  
  $$ language plpgsql;
  
create or replace trigger t_confere_nome
before insert or update on aluno
for each row
execute procedure confere_nome();

insert into aluno values('1', 'José')

select * from aluno

create or replace function fconfere_valores_valido()
returns trigger as $$
begin
if (new.nome is NULL) then
 raise exception 'Nomes nulos não são permitidos!!';
elsif new.sal is null then
 raise exception 'O salário não pode ser nulo!!';
elsif new.sal < 0 then
 raise exception 'O salário não pode ser negativo!!';
else
new.dt_ult_at = now();
 new.usuario_que_at = current_user;
end if;
return new;
end;
$$ language plpgsql;

create trigger tconfere_valores_valido
before insert or update on funcionario
for each row 
execute procedure fconfere_valores_valido();
  
 create or replace function f_gera_auditoria()
 returns trigger as $$
  begin
    if (tg_op = 'DELETE') then
	  insert into empregado_audit select 'E', current_user, now(), old.*;
	elsif (tg_op = 'INSERT') then
	  insert into empregado_audit select 'I', current_user, now(), new.*;
	elsif (tg_op = 'UPDATE') then
	  insert into empregado_audit select 'A', current_user, now(), new.*;
	  end if;
    return new;
   end;
   $$
  language PLPGSQL;
  
  create trigger t_gera_auditoria
 after insert or update or delete 
 on empregado
 for each row
 execute procedure
  f_gera_auditoria();
  

create table empregados_2(
id serial primary key ,
nome varchar not null,
salario integer
)

create or replace table empregados_2_audit(
usuario varchar,
data timestamp,
id integer,
coluna text,
valor_antigo text,
valor_novo text
)

create or replace function f_gera_audit2()
returns trigger as $$
begin

if new.id <> old.id then
raise exception 'O id não pode ser alterado!!';
end if;
  if (new.nome <> old.nome and new.nome is not null) then
    insert into empregados_2_audit values(current_user,now,old.id,old.nome,new.nome);
end if;
   if (new.salario <> old.salario and new.salario is not null) then
   insert into empregados_2_audit values(current_user,now,old.id,old.salario,new.salario);
   end if;
  end;
      $$
  language PLPGSQL;
  
  create or replace trigger t_gera_audit2
  before update on empregados_2
  for each row
  execute procedure f_gera_audit2();
  
