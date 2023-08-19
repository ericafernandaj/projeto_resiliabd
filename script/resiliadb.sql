create database resiliadb; -- Cria o banco de dados "resiliadb"
use resiliadb;-- Acessa o banco de dados "resiliadb"

-- Tabela Cursos
-- Esta tabela mantém os registros de todos os cursos oferecidos pela Resilia.
-- Cada curso tem um nome, turno e modalidade.
CREATE TABLE Cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL, -- Nome do curso ofertado
    turno CHAR(1), -- Turno do curso ('M' para manhã, 'T' para tarde, 'N' para noite)
    modalidade CHAR(1) -- Modalidade do curso ('P' para presencial, 'R' para remoto, 'H' para hibrido)
);

-- Tabela Turmas
-- Armazena detalhes sobre as turmas criadas para os cursos. 
-- Cada turma está associada a um curso e pode ter uma empresa parceira.
CREATE TABLE Turmas (
    id_turma INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada turma
    nome_turma VARCHAR(50) UNIQUE, -- Nome de identificação da turma
    empresa_parceira VARCHAR(50), -- Nome da empresa parceira responsavel pela turma (caso haja)
    max_qtd_estudantes INT, -- Quantidade de maxima estudantes na turma
    id_curso INT, -- Referência ao curso ao qual a turma pertence
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso) -- Relacionamento com a tabela de cursos
);

-- Tabela Módulos
-- Armazena informações sobre os módulos que compõem uma turma. 
-- Cada módulo tem um número, nome, quantidade de aulas e uma data limite para sua conclusão.
CREATE TABLE Modulos (
    id_modulo INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada módulo
    numero_modulo CHAR(2), -- Número sequencial do módulo
    nome_modulo VARCHAR(50), -- Nome do módulo
    data_inicio DATE, -- Data de início do módulo
    data_limite DATE, -- Data limite para a finalização do módulo
    qtd_aulas INT, -- Quantidade de aulas que aquele módulo vai ter
    id_turma INT, -- Referência à turma que possui esse módulo
    FOREIGN KEY (id_turma) REFERENCES Turmas(id_turma) -- Relacionamento com a tabela de turmas
);
	

-- Tabela Facilitadores
-- Esta tabela armazena informações sobre os facilitadores que lecionam cursos na Resilia.
-- Cada facilitador tem um nome, matrícula, cpf e email, os quais são usados para identificação e comunicação.
CREATE TABLE Facilitadores (
    id_facilitador INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada facilitador
    nome VARCHAR(50) NOT NULL, -- Nome completo do facilitador
    numero_matricula VARCHAR(5) UNIQUE, -- Número de matrícula do facilitador (deve ser único)
    cpf CHAR(11) UNIQUE, -- CPF do facilitador (deve ser único)
    email VARCHAR(50) UNIQUE -- Email do facilitador (deve ser único)
);

-- Tabela FacilitadoresTurmas
-- Esta tabela é usada para estabelecer a relação entre os facilitadores e as turmas que eles ensinam na Resilia.
-- Como um facilitador pode lecionar em várias turmas e uma turma pode ter vários facilitadores, essa tabela de associação se torna essencial.
CREATE TABLE FacilitadoresTurmas (
    id_facilitador_turma INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada relação entre facilitador e turma
    id_facilitador INT, -- Identificador do facilitador
    id_turma INT, -- Identificador da turma
    FOREIGN KEY (id_facilitador) REFERENCES Facilitadores(id_facilitador), -- Chave estrangeira referenciando a tabela de facilitadores
    FOREIGN KEY (id_turma) REFERENCES Turmas(id_turma) -- Chave estrangeira referenciando a tabela de turmas
);

-- Tabela Estudantes
-- Esta tabela é usada para armazenar informações sobre cada estudante matriculado na Resilia.
-- Ela contém dados pessoais, a data de matrícula, e informações sobre em qual turma e módulo o estudante está atualmente.
CREATE TABLE Estudantes (
    id_estudante INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada estudante
    nome_estudante VARCHAR(50) NOT NULL, -- Nome completo do estudante
    data_nascimento DATE, -- Data de nascimento do estudante
    data_matricula DATE, -- Data em que o estudante foi matriculado no curso
    email VARCHAR(50) UNIQUE, -- Email do estudante (deve ser único)
    cpf CHAR(11) UNIQUE, -- CPF do estudante (deve ser único)
    ativo CHAR(1) DEFAULT 'S', -- Indica se o estudante está ativo no curso (S para sim, N para não). O estudante começa ativo por padrão
    id_turma INT, -- Identificador da turma em que o aluno está matriculado
    id_modulo_atual INT DEFAULT 1, -- Identificador do módulo atual do aluno. O estudante inicia no módulo 1 por padrão
    FOREIGN KEY (id_turma) REFERENCES Turmas (id_turma), 
    FOREIGN KEY (id_modulo_atual) REFERENCES Modulos (id_modulo)
);


-- Tabela Endereço
-- Esta tabela guarda os endereços dos estudantes e facilitadores.
-- Ela foi projetada para armazenar apenas um endereço para cada estudante ou facilitador, conforme especificado nas regras de negócio.
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
    id_facilitador INT, -- Referência ao facilitador relacionado ao endereço
    FOREIGN KEY (id_estudante) REFERENCES Estudantes(id_estudante), -- Relacionamento com a tabela de estudantes
    FOREIGN KEY (id_facilitador) REFERENCES Facilitadores(id_facilitador) -- Relacionamento com a tabela de facilitadores
);

-- Tabela Telefone
-- Esta tabela armazena os números de telefone dos estudantes e facilitadores.
-- Um estudante ou facilitador pode ter até dois números de telefone, como especificado nas regras de negócio.
CREATE TABLE Telefone (
    id_telefone INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada telefone
    id_estudante INT, -- Referência ao estudante relacionado ao telefone
    codigo_pais VARCHAR(3), -- Código do país do número de telefone (Ex: 55 para Brasil)
    DDD CHAR(2), -- DDD do número de telefone (Ex: 21 para Rio de Janeiro)
    numero CHAR(9), -- Número do telefone (Ex: 912345678)
    id_facilitador INT, -- Referência ao facilitador relacionado ao telefone
    FOREIGN KEY (id_estudante) REFERENCES Estudantes(id_estudante), -- Relacionamento com a tabela de estudantes
    FOREIGN KEY (id_facilitador) REFERENCES Facilitadores(id_facilitador) -- Relacionamento com a tabela de facilitadores
);

-- Tabela Atividades
-- Mantém o registro das atividades atribuídas aos estudantes.
-- Estas atividades incluem projetos em grupo, individuais, projetos extras, listas de exercícios e avaliações.
CREATE TABLE Atividades (
    id_atividade INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada atividade
    projeto_grupo char(1), -- Indicação se a atividade em grupo foi feita (S para sim, N para não)
    projeto_individual char(1), -- Indicação se a atividade individual foi feita (S para sim, N para não)
    projeto_extra char(1), -- Indicação se o projeto extra foi feito (S para sim, N para não)
    lista_exercicios_portal char(1), -- Indicação se a lista do portal foi feita (S para sim, N para não)
    avaliacao_soft char(1), -- Indicação se a avaliação soft foi feita (S para sim, N para não)
    data_entrega DATE, -- Data de entrega da atividade
    id_modulo INT, -- Referência ao id do módulo que que aquela atividade foi definida
    id_estudante INT, -- Referência ao estudante que realizou a atividade
    FOREIGN KEY (id_modulo) REFERENCES Modulos(id_modulo),
    FOREIGN KEY (id_estudante) REFERENCES Estudantes(id_estudante) -- Relacionamento com a tabela de estudantes
);

-- Tabela Presenças
-- Esta tabela rastreia a presença dos estudantes em cada aula.
-- Além de marcar a presença, ela também registra os horários de entrada e saída e, em caso de ausência, a justificativa.
CREATE TABLE Presencas (
    id_presenca INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada registro de presença
    data_aula DATE, -- Data da aula em questão
    status_presenca char(1), -- Indicação de presença na aula (S para sim, N para não)
    horario_entrada DATETIME, -- Horário de entrada do estudante na aula
    horario_saida DATETIME, -- Horário de saída do estudante da aula
    justificativa varchar(50), -- Justificativa caso o aluno falte
    id_modulo INT,
    id_estudante INT, -- Referência ao estudante relacionado ao registro de presença
    FOREIGN KEY (id_modulo) REFERENCES Modulos(id_modulo),
    FOREIGN KEY (id_estudante) REFERENCES Estudantes(id_estudante) -- Relacionamento com a tabela de estudantes
);


-- Cardinalidades: 

-- Cursos -> Turmas: 1:N 
-- A cada curso podem estar associadas várias turmas, mas cada turma está associada a apenas um curso.

-- Turmas -> Modulos: 1:N 
-- A cada turma podem estar associados vários módulos, mas cada módulo pertence a apenas uma turma.

-- Turmas -> FacilitadoresTurmas: 1:N
-- Uma turma pode ter várias relações com diferentes facilitadores, mas cada relação na tabela FacilitadoresTurmas refere-se a apenas uma turma.

-- Facilitadores -> FacilitadoresTurmas: 1:N 
-- Um facilitador pode estar associado a várias turmas através da tabela de relação, mas cada entrada nessa tabela de relação refere-se a apenas um facilitador.

-- Turmas -> Estudantes: 1:N 
-- Cada turma pode ter vários estudantes, mas um estudante pertence a apenas uma turma.

-- Modulos -> Estudantes: 1:N 
-- Um módulo pode ter vários estudantes nele, mas cada estudante está em apenas um módulo por vez.

-- Estudantes -> Endereco: 1:1 
-- Cada estudante tem apenas um endereço.

-- Facilitadores -> Endereco: 1:1 
-- Cada facilitador tem apenas um endereço.

-- Estudantes -> Telefone: 1:N 
-- Cada estudante pode ter mais de um telefones.

-- Facilitadores -> Telefone: 1:N
-- Cada facilitador pode ter mais de um telefones.

-- Modulos -> Atividades: 1:N 
-- Um módulo pode ter várias atividades, mas cada atividade pertence a apenas um módulo.

-- Estudantes -> Atividades: 1:N 
-- Um estudante pode ter várias atividades, mas cada atividade pertence a apenas um estudante.

-- Modulos -> Presencas: 1:N 
-- Um módulo pode ter vários registros de presença, mas cada registro de presença está relacionado a apenas um módulo.

-- Estudantes -> Presencas: 1:N 
-- Um estudante pode ter vários registros de presença, mas cada registro de presença está relacionado a apenas um estudante.

