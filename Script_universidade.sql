CREATE SCHEMA universidade;

CREATE DOMAIN universidade.tipocpf AS BIGINT NOT NULL;
CREATE DOMAIN universidade.tipomatricula AS VARCHAR(7) NOT NULL;
CREATE DOMAIN universidade.sigladepto AS VARCHAR(4);

CREATE TABLE universidade.usuario(
	cpf universidade.tipocpf,
	primeiro_nome VARCHAR(50) NOT NULL,
	data_nasc DATE NOT NULL,
	email VARCHAR[],
	telefone VARCHAR[],
	CONSTRAINT pk_cpf PRIMARY KEY(cpf)
);


CREATE TABLE universidade.endereco(
	id_endereco SERIAL,
	cep BIGINT NOT NULL,
	rua VARCHAR NOT NULL,
	bairro VARCHAR,
	cidade VARCHAR NOT NULL,
	estado VARCHAR NOT NULL,
	pais VARCHAR NOT NULL,
	CONSTRAINT pk_idendereco PRIMARY KEY(id_endereco),
	CONSTRAINT uni_resid UNIQUE(cep,rua,cidade,estado)	
);

CREATE TABLE universidade.mora(
	cpf universidade.tipocpf,
	id_endereco INT NOT NULL,
	complemento VARCHAR,
	numero VARCHAR,
	CONSTRAINT pk_ident PRIMARY KEY(cpf,id_endereco),
	CONSTRAINT fk_cpf_mora FOREIGN KEY(cpf) REFERENCES universidade.usuario(cpf)
		ON UPDATE CASCADE
);

CREATE TABLE universidade.estudante(
	mat_estudante universidade.tipomatricula,
	cpf universidade.tipocpf,
	mc FLOAT NOT NULL DEFAULT 0,
	CONSTRAINT pk_matestudante PRIMARY KEY(mat_estudante),
	CONSTRAINT fk_cpf_estudante FOREIGN KEY(cpf) REFERENCES universidade.usuario(cpf)
		ON UPDATE CASCADE,
	CONSTRAINT uni_cpf UNIQUE(cpf)
);

CREATE TABLE universidade.cargo(
	id_cargo SERIAL NOT NULL,
	descricao VARCHAR NOT NULL,
	salario_base FLOAT NOT NULL,
	CONSTRAINT ch_salario_base CHECK(salario_base > 1000),
	CONSTRAINT pk_id_cargo PRIMARY KEY(id_cargo)
	
);

CREATE TABLE universidade.professor(
	mat_professor universidade.tipomatricula,
	cpf universidade.tipocpf,
	cargo INT NOT NULL,
	departamento universidade.sigladepto,
	CONSTRAINT pk_mat_professor PRIMARY KEY(mat_professor),
	CONSTRAINT fk_cargo FOREIGN KEY(cargo) REFERENCES universidade.cargo(id_cargo)
		ON UPDATE CASCADE
);

CREATE TABLE universidade.departamento(
	cod_depto universidade.sigladepto NOT NULL,
	nome VARCHAR NOT NULL,
	chefe universidade.tipomatricula,
	orcamento FLOAT NOT NULL DEFAULT 0,
	CONSTRAINT pk_cod_depto PRIMARY KEY(cod_depto)	
);


ALTER TABLE universidade.departamento 
	ADD CONSTRAINT pk_chefe FOREIGN KEY(chefe) 
	REFERENCES universidade.professor(mat_professor)
		ON UPDATE CASCADE;
	
ALTER TABLE universidade.professor
	ADD CONSTRAINT fk_departamento FOREIGN KEY(departamento) 
	REFERENCES universidade.departamento(cod_depto)
		ON UPDATE CASCADE;
	
CREATE TABLE universidade.projeto(
	codigo INT NOT NULL,
	descricao VARCHAR NOT NULL,
	CONSTRAINT pk_codigo PRIMARY KEY(codigo)
);

CREATE TABLE universidade.plano(
	mat_estudante universidade.tipomatricula,
	mat_professor universidade.tipomatricula,
	projeto INT NOT NULL,
	ano INT NOT NULL,
	CONSTRAINT pk_mat_estudante PRIMARY KEY(mat_estudante),
	CONSTRAINT fk_mat_estudante FOREIGN KEY(mat_estudante) REFERENCES universidade.estudante(mat_estudante)
		ON UPDATE CASCADE,
	CONSTRAINT fk_mat_professor FOREIGN KEY(mat_professor) REFERENCES universidade.professor(mat_professor)
		ON UPDATE CASCADE,
	CONSTRAINT fk_projeto FOREIGN KEY(projeto) REFERENCES universidade.projeto(codigo)
		ON UPDATE CASCADE
);

CREATE TABLE universidade.diciplina(
	cod_disc VARCHAR(8) NOT NULL,
	nome VARCHAR(8) NOT NULL,
	creditos SMALLINT NOT NULL,
	pre_req VARCHAR(8),
	depto_responsavel universidade.sigladepto NOT NULL,
	CONSTRAINT ch_creditos CHECK(1 <= creditos AND creditos <= 32),
	CONSTRAINT pk_cod_disc PRIMARY KEY(cod_disc),
	CONSTRAINT fk_depto_responsavel FOREIGN KEY(depto_responsavel) REFERENCES universidade.departamento(cod_depto)	
		ON UPDATE CASCADE
);

CREATE TABLE universidade.semestre(
	ano SMALLINT NOT NULL,
	periodo SMALLINT NOT NULL,
	data_inicio DATE,
	data_fim DATE,
	CONSTRAINT ch_temporada CHECK(data_fim > data_inicio)
	CONSTRAINT pk_perio PRIMARY KEY(ano,periodo)
);

CREATE TABLE universidade.turma(
	id_turma SERIAL NOT NULL,
	cod_disc VARCHAR(8) NOT NULL,
	turma SMALLINT NOT NULL,
	ano SMALLINT NOT NULL,
	periodo SMALLINT NOT NULL,
	CONSTRAINT pk_id_turma PRIMARY KEY(id_turma),
	CONSTRAINT uni_disc UNIQUE(cod_disc,turma,ano,periodo),
	CONSTRAINT fk_cod_disc FOREIGN KEY(cod_disc) REFERENCES universidade.diciplina(cod_disc)
		ON UPDATE CASCADE,
	CONSTRAINT fk_perio FOREIGN KEY(ano,periodo) REFERENCES universidade.semestre(ano,periodo)
		ON UPDATE CASCADE
);

CREATE TABLE universidade.cursa(
	mat_estudante universidade.tipomatricula,
	id_turma INT NOT NULL,
	notas FLOAT,
	CONSTRAINT pk_cursa PRIMARY KEY(mat_estudante,id_turma),
	CONSTRAINT fk_mat_estudante_cursa FOREIGN KEY(mat_estudante) REFERENCES universidade.estudante(mat_estudante)
		ON UPDATE CASCADE,
	CONSTRAINT fk_id_turma_cursa FOREIGN KEY(id_turma) REFERENCES universidade.turma(id_turma)
		ON UPDATE CASCADE
);

CREATE TABLE universidade.leciona(
	mat_professor universidade.tipomatricula,
	id_turma INT NOT NULL,
	CONSTRAINT pk_leciona PRIMARY KEY(mat_professor,id_turma),
	CONSTRAINT fk_mat_professor_lec FOREIGN KEY(mat_professor) REFERENCES universidade.professor(mat_professor)
		ON UPDATE CASCADE,
	CONSTRAINT fk_id_turma_leciona FOREIGN KEY(id_turma) REFERENCES universidade.turma(id_turma)
		ON UPDATE CASCADE
);

