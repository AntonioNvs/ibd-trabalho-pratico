BEGIN;

CREATE TABLE IF NOT EXISTS MOTORISTA(
	cpf TEXT PRIMARY KEY NOT NULL,
    nome TEXT NOT NULL,
    data_nascimento DATE NOT NULL,
    endereco TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS VEICULO(
	placa TEXT PRIMARY KEY NOT NULL,
    id_veiculo TEXT UNIQUE NOT NULL,
    preco DOUBLE NOT NULL,
    categoria TEXT NOT NULL,
    num_rodas INTEGER NOT NULL,
    max_passageiros INTEGER NOT NULL,
    cpf TEXT NOT NULL,
    carro_lateral BOOLEAN,
    tipo_acoplamento TEXT,
    peso DOUBLE,
    carga_max_suportada DOUBLE,
    carga_max_acoplamento DOUBLE,
    FOREIGN KEY (cpf) REFERENCES MOTORISTA(cpf) ON DELETE RESTRICT,
	
	check(categoria = 'A' or categoria = 'B' or categoria = 'C' or categoria = 'D' or categoria = 'E'),
    
    check((
			categoria = 'A' AND
			(num_rodas = 2 or num_rodas = 3) AND
			max_passageiros < 3 AND
            peso IS NOT NULL
		) or (
			categoria = 'B' AND
		    carro_lateral IS FALSE AND
		    tipo_acoplamento IS NOT NULL AND
            peso <= 3500 AND
            max_passageiros <= 8
		) or (
			categoria = 'C' AND
			carro_lateral IS FALSE AND
		    tipo_acoplamento IS NOT NULL AND
            peso >= 3500 AND peso <= 6001 AND
            max_passageiros <= 3
        ) or (
			categoria = 'D' AND
			carro_lateral IS FALSE AND
		    tipo_acoplamento IS NOT NULL AND
            peso >= 3500 AND peso <= 6001 AND
            max_passageiros > 8
        ) or (
			categoria = 'E' AND
			carro_lateral IS FALSE AND
		    tipo_acoplamento IS NOT NULL AND
            peso >= 6000
        )
    )
);

CREATE TABLE IF NOT EXISTS CNH(
	n_habilitacao TEXT PRIMARY KEY NOT NULL,
    cpf TEXT NOT NULL UNIQUE,
    doc_identidade TEXT NOT NULL UNIQUE,
    orgao_emissor TEXT NOT NULL,
    nome_pai TEXT NOT NULL,
	nome_mae TEXT NOT NULL,
	validade DATE NOT NULL,
    FOREIGN KEY (cpf) REFERENCES MOTORISTA(cpf) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DATA_EMISSAO(
	id_emissao INTEGER PRIMARY KEY NOT NULL,
    n_habilitacao TEXT NOT NULL,
    data_emissao DATE NOT NULL,
    FOREIGN KEY (n_habilitacao) REFERENCES CNH(n_habilitacao) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS MULTA(
	id_multa INTEGER PRIMARY KEY NOT NULL,
    valor DOUBLE NOT NULL,
    pontuacao INTEGER NOT NULL,
    descricao TEXT NOT NULL
);

CREATE TABLE INSTANCIA_MULTA(
	id_instancia_multa INTEGER PRIMARY KEY NOT NULL,
    id_multa INTEGER NOT NULL,
    placa TEXT NOT NULL,
    n_habilitacao TEXT NOT NULL,
    data_instancia_multa DATE NOT NULL,
    endereco_ocorrencia TEXT NOT NULL,
    pago BOOLEAN NOT NULL,
    
    FOREIGN KEY (placa) REFERENCES VEICULO(placa) ON DELETE RESTRICT,
    FOREIGN KEY (n_habilitacao) REFERENCES CNH(n_habilitacao) ON DELETE RESTRICT,
    FOREIGN KEY (id_multa) REFERENCES MULTA(id_multa) ON DELETE RESTRICT
);

END;