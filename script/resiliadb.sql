create database resiliadb; -- Cria o banco de dados "resiliadb"
use resiliadb; -- Acessa o banco de dados "resiliadb"

-- Tabela Estudantes
CREATE TABLE Estudantes (
    id_estudante INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada estudante
    nome_estudante VARCHAR(50) NOT NULL, -- Nome completo do estudante
    data_nascimento DATE, -- Data de nascimento do estudante
    data_matricula DATE, -- Data em que o estudante foi matriculado no curso
    email VARCHAR(50) UNIQUE, -- Email do estudante (deve ser único)
    cpf CHAR(11) UNIQUE, -- CPF do estudante (deve ser único)
    ativo char(1) -- Indica se o estudante está ativo no curso (S para sim, N para não)
);

-- Tabela Pessoas Facilitadores
CREATE TABLE Facilitadores (
    id_facilitadores INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada facilitador
    nome VARCHAR(50) NOT NULL, -- Nome completo do facilitador
    numero_matricula VARCHAR(5) UNIQUE, -- Número de matrícula do facilitador (deve ser único)
    cpf CHAR(11) UNIQUE, -- CPF do facilitador (deve ser único)
    email VARCHAR(50) UNIQUE -- Email do facilitador (deve ser único)
);

-- Tabela Cursos
CREATE TABLE Cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada curso
    nome VARCHAR(50) NOT NULL, -- Nome do curso
    turno CHAR(1), -- Turno do curso (T para tarde, M para manhã, N para noite)
    modalidade CHAR(1), -- Modalidade do curso (P para presencial, R para remoto, H para híbrido)
);

-- Tabela Turmas
CREATE TABLE Turmas (
    id_turma INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada turma
    codigo_turma VARCHAR(10) UNIQUE, -- Código de identificação da turma (deve ser único)
    empresa_parceira VARCHAR(50) -- Nome da empresa parceira responsavel pela turma (caso haja)
    id_facilitadores INT, -- Referência ao facilitador da turma
    id_estudante INT, -- Referência ao estudante que pertence à turma
    id_curso INT, -- Referência ao curso ao qual a turma pertence
    quantidades_estudantes INT, -- Quantidade de estudantes na turma
    FOREIGN KEY (id_facilitadores) REFERENCES Facilitadores(id_facilitadores), -- Relacionamento com a tabela de facilitadores
    FOREIGN KEY (id_estudante) REFERENCES Estudantes(id_estudante), -- Relacionamento com a tabela de estudantes
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso) -- Relacionamento com a tabela de cursos
);

-- Tabela Módulos
CREATE TABLE Modulos (
    id_modulo INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada módulo
    numero_modulo CHAR(2), -- Número sequencial do módulo
    nome_modulo VARCHAR(50), -- Nome do módulo
    qtd_aulas INT, -- Quantidade de aulas que um determinado modulo possui
    data_limite DATE, -- Data limite para a finalização do módulo
    id_facilitadores INT, -- Referência ao facilitador responsável pelo módulo
    id_estudante INT, -- Referência ao estudante que cursou o módulo
    FOREIGN KEY (id_facilitadores) REFERENCES Facilitadores(id_facilitadores), -- Relacionamento com a tabela de facilitadores
    FOREIGN KEY (id_estudante) REFERENCES Estudantes(id_estudante) -- Relacionamento com a tabela de estudantes
);

-- Tabela Endereço
CREATE TABLE Endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada endereço
    id_estudante INT, -- Referência ao estudante relacionado ao endereço
    rua VARCHAR(50), -- Nome da rua do endereço
    pais CHAR(2), -- Código do país do endereço (Ex: BR para Brasil)
    estado CHAR(2), -- Código do estado do endereço (Ex: SP para São Paulo)
    cidade VARCHAR(50), -- Nome da cidade do endereço
    bairro VARCHAR(50), -- Nome do bairro do endereço
    numero VARCHAR(10), -- Número da residência no endereço
    complemento VARCHAR(50), -- Complemento do endereço (Ex: Apt 101)
    id_facilitadores INT, -- Referência ao facilitador relacionado ao endereço
    FOREIGN KEY (id_estudante) REFERENCES Estudantes(id_estudante), -- Relacionamento com a tabela de estudantes
    FOREIGN KEY (id_facilitadores) REFERENCES Facilitadores(id_facilitadores) -- Relacionamento com a tabela de facilitadores
);

-- Tabela Telefone
CREATE TABLE Telefone (
    id_telefone INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada telefone
    id_estudante INT, -- Referência ao estudante relacionado ao telefone
    codigo_pais VARCHAR(3), -- Código do país do número de telefone (Ex: 55 para Brasil)
    DDD CHAR(2), -- DDD do número de telefone (Ex: 21 para Rio de Janeiro)
    numero CHAR(9), -- Número do telefone (Ex: 912345678)
    id_facilitadores INT, -- Referência ao facilitador relacionado ao telefone
    FOREIGN KEY (id_estudante) REFERENCES Estudantes(id_estudante), -- Relacionamento com a tabela de estudantes
    FOREIGN KEY (id_facilitadores) REFERENCES Facilitadores(id_facilitadores) -- Relacionamento com a tabela de facilitadores
);

-- Tabela Atividades
CREATE TABLE Atividades (
    id_atividade INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada atividade
    projeto_grupo char(1), -- Indicação se a atividade em grupo foi feita (S para sim, N para não)
    projeto_individual char(1), -- Indicação se a atividade individual foi feita (S para sim, N para não)
    projeto_extra char(1), -- Indicação se o projeto extra foi feito (S para sim, N para não)
    lista_exercicios_portal char(1), -- Indicação se a lista do portal foi feita (S para sim, N para não)
    avaliacao_soft char(1), -- Indicação se a avaliação soft foi feita (S para sim, N para não)
    data_inicio DATE, -- Data de início da atividade
    data_entrega DATE, -- Data de entrega da atividade
    id_modulo INT, -- Referência ao id do módulo que que aquela atividade foi definida
    id_turma INT, -- Referência à turma relacionada à atividade
    id_estudante INT, -- Referência ao estudante que realizou a atividade
    FOREIGN KEY (id_modulo) REFERENCES Modulos(id_modulo),
    FOREIGN KEY (id_turma) REFERENCES Turmas(id_turma), -- Relacionamento com a tabela de turmas
    FOREIGN KEY (id_estudante) REFERENCES Estudantes(id_estudante) -- Relacionamento com a tabela de estudantes
);

-- Tabela Presenças
CREATE TABLE Presencas (
    id_presenca INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada registro de presença
    data_aula DATE, -- Data da aula em questão
    status_presenca char(1), -- Indicação de presença na aula (S para sim, N para não)
    horario_entrada DATETIME, -- Horário de entrada do estudante na aula
    horario_saida DATETIME, -- Horário de saída do estudante da aula
    justificativa varchar(50), -- Justificativa caso o aluno falte
    id_estudante INT, -- Referência ao estudante relacionado ao registro de presença
    id_turma INT, -- Referência à turma relacionada ao registro de presença
    FOREIGN KEY (id_estudante) REFERENCES Estudantes(id_estudante), -- Relacionamento com a tabela de estudantes
    FOREIGN KEY (id_turma) REFERENCES Turmas(id_turma) -- Relacionamento com a tabela de turmas
);

