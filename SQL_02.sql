
 create database banco_PL11;

create table Cliente 
(
	cod_cliente int identity(1,1), 
	nome varchar(50), 
	profissao varchar(50), 
	localidade varchar(50)
	constraint PK_Cliente primary Key (cod_cliente)
);  

create table Agencia 
(
	cod_agencia int identity(1,1), 
	nome varchar(50),  
	localidade varchar(50),  
	constraint PK_Agencia primary Key (cod_agencia)
);

create table Conta 
(
	num_conta int identity(1,1), 
	tipo_conta varchar(50), 
	cod_cliente int,
	cod_agencia int,
	saldo int,
	constraint PK_Projeto primary Key (num_conta),
	constraint FK_Fornecimento_Client FOREIGN KEY (cod_cliente) REFERENCES Cliente(cod_cliente),
	constraint FK_Fornecimento_agencia FOREIGN KEY (cod_agencia) REFERENCES Agencia(cod_agencia)
);

create table Emprestimo 
(
	num_emprestimo int identity(1,1), 
	cod_cliente int, 
	cod_agencia int, 
	valor int,
	constraint PK_Fornecimento primary Key (num_emprestimo),
	constraint FK_Fornecimento_Client2 FOREIGN KEY (cod_cliente) REFERENCES Cliente(cod_cliente),
	constraint FK_Fornecimento_agencia2 FOREIGN KEY (cod_agencia) REFERENCES Agencia(cod_agencia)
);

insert into Cliente(nome, profissao, localidade) values('Aderito', 'ambulante', 'Porto');
insert into Cliente(nome, profissao, localidade) values('Ambrosio', 'viagante', 'lisboa');
insert into Cliente(nome, profissao, localidade) values('Anacleto', 'Ambos', 'Aveiro');

insert into Agencia( nome, localidade) values('cgd', 'Porto');
insert into Agencia( nome, localidade) values('millenium', 'lisboa');
insert into Agencia( nome, localidade) values('bpi', 'Aveiro');

insert into Conta(tipo_conta, cod_cliente, cod_agencia, saldo) values('ordem', 1, 1, 10200);
insert into Conta(tipo_conta, cod_cliente, cod_agencia, saldo) values('praso', 2, 3, 100500);
insert into Conta(tipo_conta, cod_cliente, cod_agencia, saldo) values('ordem', 3, 3, 1500);

insert into Emprestimo( cod_cliente, cod_agencia, valor) values( 1, 1, 1000000);
insert into Emprestimo( cod_cliente, cod_agencia, valor) values(2, 3, 5000000);
insert into Emprestimo( cod_cliente, cod_agencia, valor) values(3, 3, 10000);

select * from Cliente;
select * from Agencia;
select * from Conta;
select * from Emprestimo;

-- 4 a. Quais os clientes cuja profissão é desconhecida?
Create or alter View ViewA as
select * from Cliente c where c.profissao is null;

-- 4 b. Listar o número de contas existentes em cada agência.
Create or alter View ViewB as
select a.nome, count(c.cod_agencia) num_agencia
from Agencia a
inner join conta c 
	on a.cod_agencia = c.cod_agencia
group by a.nome;

-- 4 c. Quais os clientes com, pelo menos, um empréstimo no banco?
Create or alter View ViewC as
select c.nome, count(e.num_emprestimo) numer_emprestimos
from Emprestimo e
inner join Cliente c
	on e.cod_cliente = c.cod_cliente
group by c.nome
having  count(e.num_emprestimo) > 0;



-- 5 a. Quais os clientes que residem numa dada localidade?
create procedure clienteLocalidade ( @localidade varchar(100))
as
select *
from cliente
where localidade = @localidade;
GO


EXECUTE clienteLocalidade
    @localidade = 'Lisboa';
GO

-- 5 b. Quais os clientes com conta numa dada agência?
create procedure clienteAgencia (@agencia varchar(100))

as

select cl.nome, a.nome
from cliente cl
inner join conta c
on cl.cod_cliente = c.cod_cliente
inner join agencia a
on a.cod_agencia = c.cod_agencia
where a.nome = @agencia;
GO


EXECUTE clienteAgencia
    @agencia = 'Banco Central';
GO

-- 5 c. Quais os clientes com empréstimos de valor superior a um dado valor?
create or alter procedure emprestimo_superior (
@valor float)
as
select c.nome, e.valor
from cliente c
inner join emprestimo e
on e.cod_cliente = c.cod_cliente
where e.valor > @valor
go

exec emprestimo_superior
@valor = 300
go

-- 5 d. Quais os nomes dos clientes com a mesma profissão que do cliente com um dado cod_cliente inserido por parâmetro?
create or alter procedure mesma_profissao (
@codigo_cliente VARCHAR(200))
as
declare @profissao VARCHAR(200)
set @profissao = (select profissao from cliente
where cod_cliente = @codigo_cliente)

select nome from cliente where profissao = @profissao;

go

create or alter procedure mesma_profissao (
@codigo_cliente VARCHAR(200))
as
select c2.nome, c2.profissao
from cliente c1
inner join cliente c2 on c1.profissao = c2.profissao
where c1.cod_cliente = @codigo_cliente
go

exec mesma_profissao
@codigo_cliente = 3
go

-- 5 e. Listar as contas de uma dada, por ordem decrescente do seu valor de saldo?
create procedure saldoAgencia(@in_saldo varchar(200))
as
	select a.nome, b.*
	from agencia a
	inner join conta b
	on a.cod_agencia = b.cod_agencia
	where a.nome = @in_saldo
	order by b.saldo desc
go

go
execute saldoAgencia
@in_saldo = 'Velho Banco'
go
-- 5 f. Quantas contas existem numa dada agência?
create procedure num_contas_numa_agencia(@in_nome varchar (100)) as
	select count(*) as nContas from agencia a
	inner join conta c on a.cod_agencia=c.cod_agencia
	where a.nome = @in_nome
go

exec num_contas_numa_agencia @in_nome = 'AgenciaPorto'

-- 5 g. Para cada agência com menos X contas, listar os valores máximos dos saldos dessas contas. O X ser enviado por parâmetro.
create or alter procedure saldo_contas(@contas int)
as
SELECT a.Nome, count(c.CodAg) as Ncontas, MAX(c.saldo) as Saldo
from Agencia a
inner join Conta c
on a.CodAg = c.CodAg
GROUP BY a.Nome
HAVING COUNT(c.CodAg) < @contas

Exec saldo_contas @contas = 3;

-- 5 h. Quais os clientes que são simultaneamente depositantes e devedores de uma dada agência?
--h. Quais os clientes que são simultaneamente depositantes e devedores de uma dada agência?
create or alter procedure ClDepEDev
(@codAgencia int)
as
select cl.*
from Cliente cl
inner join Conta c
on c.cod_cliente = cl.cod_cliente
inner join Agencia a
on a.cod_agencia = c.cod_agencia
inner join Emprestimos e
on e.cod_cliente = cl.cod_cliente
where a.cod_agencia = @codAgencia

exec ClDepEDev @codAgencia = 2;
-- 5 i. Quais os clientes de uma dada agência, que são apenas depositantes?
create or alter procedure procedure_I
(@agencia varchar(50))
as
SELECT c.nome
FROM cliente c
inner join conta co
on c.cod_cliente = co.cod_cliente
inner join agencia a
on co.cod_agencia = a.cod_agencia
WHERE NOT EXISTS
(
SELECT e.cod_cliente
FROM emprestimo e
WHERE c.cod_cliente = e.cod_cliente
)
and a.nome like @agencia
group by c.nome

Exec procedure_I @agencia = 'FCP';
GO

create or alter procedure clientes_apenas_depositantes
(@in_nome varchar (100)) as
select c.* from cliente c
inner join conta co on c.cod_cliente = co.cod_cliente
inner join agencia a on a.cod_agencia = co.cod_agencia
left join emprestimo e on e.cod_cliente = c.cod_cliente
where co.saldo is not null and e.valor is null and a.nome = @in_nome
go



exec clientes_apenas_depositantes @in_nome = 'AgenciaLisboa'

-- 5 j. Quais as agências com depositantes numa dada localidade

create procedure agencias_com_depositantes_numa_localidade
(@in_localidade varchar (100)) as
select distinct a.nome from cliente c
inner join conta co on c.cod_cliente = co.cod_cliente
inner join agencia a on co.cod_agencia = a.cod_agencia
where a.localidade = @in_localidade and co.saldo is not null;


exec agencias_com_depositantes_numa_localidade @in_localidade = 'Porto'



