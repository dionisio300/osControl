-- Cria o banco de dados
CREATE DATABASE IF NOT EXISTS oscontrol
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE oscontrol;

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Tabela de clientes
CREATE TABLE IF NOT EXISTS clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  telefone VARCHAR(30),
  email VARCHAR(150),
  documento VARCHAR(20),
  endereco VARCHAR(255),
  observacoes TEXT,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Tabela de veículos
CREATE TABLE IF NOT EXISTS veiculos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT NOT NULL,
  placa VARCHAR(20),
  modelo VARCHAR(100),
  marca VARCHAR(100),
  ano INT,
  observacoes TEXT,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT fk_veiculos_clientes
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela de mecânicos
CREATE TABLE IF NOT EXISTS mecanicos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  especialidade VARCHAR(150),
  telefone VARCHAR(30),
  observacoes TEXT,
  ativo TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- Tabela de peças (estoque)
CREATE TABLE IF NOT EXISTS pecas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  codigo VARCHAR(50),
  quantidade_estoque INT NOT NULL DEFAULT 0,
  custo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  preco_venda DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  observacoes TEXT,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Tabela de ordens de serviço
CREATE TABLE IF NOT EXISTS ordens_servico (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT NOT NULL,
  veiculo_id INT NOT NULL,
  usuario_abertura_id INT NOT NULL,
  mecanico_id INT,
  data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  data_prevista_entrega DATE,
  data_conclusao DATETIME,
  status VARCHAR(20) NOT NULL DEFAULT 'ABERTA',
  problema_relatado TEXT,
  diagnostico TEXT,
  observacoes TEXT,
  valor_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  CONSTRAINT fk_os_clientes
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_os_veiculos
    FOREIGN KEY (veiculo_id) REFERENCES veiculos(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_os_usuarios
    FOREIGN KEY (usuario_abertura_id) REFERENCES usuarios(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_os_mecanicos
    FOREIGN KEY (mecanico_id) REFERENCES mecanicos(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela de itens da OS (peças e serviços)
CREATE TABLE IF NOT EXISTS os_itens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  os_id INT NOT NULL,
  peca_id INT NULL,
  descricao VARCHAR(255) NOT NULL,
  tipo ENUM('PECA', 'SERVICO') NOT NULL,
  quantidade DECIMAL(10,2) NOT NULL DEFAULT 1.00,
  valor_unitario DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  valor_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  CONSTRAINT fk_os_itens_os
    FOREIGN KEY (os_id) REFERENCES ordens_servico(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_os_itens_pecas
    FOREIGN KEY (peca_id) REFERENCES pecas(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela de pagamentos (opcional)
CREATE TABLE IF NOT EXISTS pagamentos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  os_id INT NOT NULL,
  data_pagamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  forma_pagamento VARCHAR(30),
  valor_pago DECIMAL(10,2) NOT NULL,
  observacoes TEXT,
  CONSTRAINT fk_pagamentos_os
    FOREIGN KEY (os_id) REFERENCES ordens_servico(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;
