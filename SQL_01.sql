
 create database Empresa_PL10;

create table Fornecedor 
(
	CodFor int identity(1,1), 
	FNome varchar(50), 
	Tipo varchar(50), 
	Cidade varchar(50)
	constraint PK_fornecedor primary Key (CodFor)
);  

select * from peca

create table Peca 
(
	CodPeca int identity(1,1), 
	PNome varchar(50),  
	Cor varchar(50),  
	Peso int, 
	constraint PK_peca primary Key (CodPeca)
);  

create table Projeto 
(
	CodProj int identity(1,1), 
	Designacao varchar(50), 
	Cidade varchar(50),
	constraint PK_Projeto primary Key (CodProj)
);

create table Fornecimento 
(
	CodFor int, 
	CodPeca int, 
	CodProj int, 
	data date, 
	Qtd int,
	constraint PK_Fornecimento primary Key (CodFor, CodPeca, CodProj),
	constraint FK_Fornecimento_Fone FOREIGN KEY (CodFor) REFERENCES Fornecedor(CodFor),
	constraint FK_Fornecimento_Peca FOREIGN KEY (CodPeca) REFERENCES Peca(CodPeca),
	constraint FK_Fornecimento_Projeto FOREIGN KEY (CodProj) REFERENCES Projeto(CodProj)
);

insert into Fornecedor(FNome, Tipo, Cidade) values('Aderito', 'ambulante', 'Porto');
insert into Fornecedor(FNome, Tipo, Cidade) values('Ambrosio', 'viagante', 'lisboa');
insert into Fornecedor(FNome, Tipo, Cidade) values('Anacleto', 'Ambos', 'Aveiro');

insert into Peca(PNome, Cor, Peso) values('jante', 'preta', 10);
insert into Peca(PNome, Cor, Peso) values('pneu', 'branco', 5);
insert into Peca(PNome, Cor, Peso) values('radio', 'rosa', 2);

insert into Projeto(Designacao, Cidade) values('projecto do carro', 'porto');
insert into Projeto(Designacao, Cidade) values('projecto da bicicleta', 'Barcelos');
insert into Projeto(Designacao, Cidade) values('projecto da mota', 'valongo');

insert into Fornecimento(CodFor, CodPeca, CodProj, data, Qtd) values(1, 1, 1, Convert(date, '01-01-2022', 103), 3 );
insert into Fornecimento(CodFor, CodPeca, CodProj, data, Qtd) values(1, 2, 2, Convert(date, '01-01-2022', 103), 30 );
insert into Fornecimento(CodFor, CodPeca, CodProj, data, Qtd) values(2, 3, 3, Convert(date, '01-01-2022', 103), 50 );


-- Remover todos os registos de fornecimento de peças com uma dada cor-- 
delete f from Fornecimento f
left join Peca p
on f.codPeca = p.codPeca
where p.cor = 'amarelo';

-- Alter o a cor de todas as Peças para Vermelho--
update Peca
set cor = 'vermelho';

-- Alter a Cidade do Fornecedor “Armindo LDA”, ou outro a gosto, para “Paris”--
update Fornecedor
set cidade = 'Paris'
where FNome = 'Anacleto'



 -- a Mostrar todos os projetos com todos os seus detalhes.
Create or alter View ViewA as
Select * From Projeto

-- b Mostrar todos os detalhes dos projetos localizados em Lisboa.  
create view projetos_lisboa as
select *
from projeto
where cidade like '%lisboa%'

-- c Mostrar os códigos dos fornecedores do projeto J1. 
create view fornecedoresProjecto1 as
select codFor from fornecimento
where codProj = 1

-- d Mostrar os nomes dos projetos fornecidos pelo fornecedor F1. 
create view projetos_fornecedor1 as
select p.Designacao
from projeto p
inner join fornecimento f
	on f.CodProj = p.CodProj
inner join fornecedor fo
	on fo.CodFor = f.CodFor
where fo.CodFor = 1

-- e Mostrar as cores das peças fornecidas pelo fornecedor F1.  
create view cores_f1 as
select f.codfor, p.pnome, p.cor
from peca p
inner join fornecimento fr
on p.codpeca = fr.codpeca
inner join fornecedor f
on fr.codfor = f.codfor
where f.codfor = 1

-- f Mostrar os códigos dos fornecedores dos projetos J1 e J2.  
create view codFornecedores_1_2 as
select distinct fo.CodFor
from fornecedor fo
inner join fornecimento f
on f.CodFor = fo.CodFor
inner join projeto p
on p.CodProj = f.CodProj
where p.CodProj in (1,2)

-- g Mostrar os códigos das peças fornecidas para algum projeto em Lisboa.  

create view vg as
select distinct pc.*
from peca pc
inner join fornecimento ft
on ft.codpeca = pc.codpeca
inner join projeto p
on p.codproj = ft.codproj
where p.cidade = 'Lisboa';

--h. Mostrar os códigos dos fornecedores que forneceram uma peça vermelha para algum projeto em Lisboa ou no Porto.
create or alter view vh as
select distinct fr.*
from fornecedor fr
inner join fornecimento ft
on ft.codfor = fr.codfor
inner join peca pc
on pc.codpeca = ft.codpeca
inner join projeto p
on p.codproj = ft.codproj
where pc.cor Like '%Vermelho%' and p.cidade IN ('Porto','Lisboa');

-- i Mostrar os códigos dos projetos fornecidos por todos os fornecedores que fornecem alguma peça vermelha.  
create or alter view fornecedores_peca_vermelha as
select p.codProj
from projeto p
inner join fornecimento f
on f.codProj = p.codProj
inner join fornecedor fd
on fd.codFor = f.codFor
inner join peca pe
on pe.codPeca = f.codPeca
where pe.cor like 'vermelh%'
group by p.codProj

-- j Mostra o número total de projetos que têm como fornecedor o F3.  
create view total_projetos_fornecedor_c as
select count(*) as total_projetos_fornecedor_c
from fornecimento f
inner join fornecedor fd
on fd.codFor = f.codFor
where fd.fNome like 'F3'

-- k Mostrar o número de peças fornecidas por cada fornecedor.
CREATE OR ALTER VIEW N_pecas as
select f.FNome , COUNT(pe.CodPeca) as Pecas
from Fornecedor f
inner join Fornecimento fo
on f.CodFor = fo.CodFor
inner join Peca pe
on fo.CodPeca = pe.CodPeca
group by f.FNome

-- l Mostrar peças que nunca foram fornecidas a qualquer projecto.  
create view pecas_sem_projeto as
select *
from peca
where codpeca not in (SELECT codpeca FROM fornecimento)
OU
create view Pecas_nao_vendidas as
select p.*
from peca p
left join fornecimento fo
	on fo.CodPeca = p.CodPeca
where fo.CodProj is null


-- 5 a Mudar a cor de todas as peças com uma dada cor para outra cor. 
create or alter procedure mudar_cor (@novaCor varchar(10), @antiga varchar(10))
as
update Peca
set cor = @novaCor
where cor = @antiga;


EXEc mudar_cor @antiga = 'Vermelha', @novaCor = 'Azul';

-- 5b Remover todos os registos de fornecimento de peças com uma dada cor.  
create or alter procedure rem_fornecimento2(@cor varchar(50))
as
BEGIN
DELETE fo
from fornecimento fo
inner join peca p
on fo.codpeca = p.codpeca
WHERE p.cor = @cor
END

Exec rem_fornecimento2 @cor = 'preta';

-- 5c Obter o número total de projetos de um dado fornecedor específico
create or alter procedure TotalProj_Fornecedor
(@CodForn int)
as
select COUNT(fo.CodProj) as total_proj
from fornecimento fo
where fo.CodFor = @CodForn

-- 5d. Obtenha o número de peças fornecidas para um dado projecto.
create or alter procedure numerodepecasporprojeto
(@in_idprojeto int) as
select SUM(ft.qtd) as Numero_De_Peças_De_Um_Projeto
from fornecimento ft
where ft.codproj = @in_idprojeto
go

