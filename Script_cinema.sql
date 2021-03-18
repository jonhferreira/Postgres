CREATE SCHEMA cinema;

CREATE TABLE cinema.filme(
	id_filme SERIAL NOT NULL,
	nome VARCHAR NOT NULL,
	sinopse TEXT,
	tempo INT,
	data_lancamento DATE,
	CONSTRAINT ch_tempo CHECK (tempo > 0),
	CONSTRAINT pk_id_filme PRIMARY KEY(id_filme)
);

CREATE TABLE cinema.sala(
	numero INT NOT NULL,
	descricao VARCHAR NOT NULL,
	numero_cadeiras INT,
	CONSTRAINT ch_numero_cadeiras CHECK(numero_cadeiras > 0),
	CONSTRAINT pk_numero PRIMARY KEY(numero)
);

CREATE TABLE cinema.assento(
	id_assento SERIAL NOT NULL,
	sala INT NOT NULL,
	fila INT NOT NULL,
	poltrona INT NOT NULL,
	status VARCHAR NOT NULL DEFAULT 'disponivel',
	CONSTRAINT pk_id_assento PRIMARY KEY(id_assento),
	CONSTRAINT fk_sala FOREIGN KEY(sala) REFERENCES cinema.sala(numero)
		ON UPDATE CASCADE,
	CONSTRAINT uni_lugar UNIQUE(sala,fila,poltrona)	
);

CREATE TABLE cinema.sessao(
	id_sessao SERIAL NOT NULL,
	filme INT NOT NULL,
	sala INT NOT NULL,
	hora TIME NOT NULL,
	data_inicio DATE,
	data_fim DATE,
	CONSTRAINT ch_periodo CHECK(data_fim >= data_inicio),
	CONSTRAINT fk_filme FOREIGN KEY(filme) REFERENCES cinema.filme(id_filme)
		ON UPDATE CASCADE,
	CONSTRAINT fk_sala FOREIGN KEY(sala) REFERENCES cinema.sala(numero)
		ON UPDATE CASCADE,
	CONSTRAINT pk_id_sessao PRIMARY KEY(id_sessao)
);

CREATE TABLE cinema.ingresso(
	id_ingresso SERIAL NOT NULL,
	sessao INT NOT NULL,
	assento INT,
	valor_pago MONEY,
	CONSTRAINT ch_valor_pago CHECK(valor_pago::NUMERIC::FLOAT>0),
	CONSTRAINT pk_id_ingresso PRIMARY KEY(id_ingresso),
	CONSTRAINT fk_sessao FOREIGN KEY(sessao) REFERENCES cinema.sessao(id_sessao)
		ON UPDATE CASCADE,
	CONSTRAINT fk_assento FOREIGN KEY(assento) REFERENCES cinema.assento(id_assento)
		ON UPDATE CASCADE
);
