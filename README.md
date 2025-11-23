# Computer Networks Projects

Instituto Federal de Educação, Ciência e Tecnologia de São Paulo - Campus São João da Boa Vista  
Unidade Curricular: Laboratório de Redes de Computadores

Data: Novembro de 2025

---

## 📌 Overview / Visão Geral

Este repositório contém os projetos desenvolvidos para a disciplina de Redes de Computadores, divididos em duas partes principais:

- **Projeto Prático:** Implementação de um servidor web Linux completo usando Microsserviços e Docker.
- **Projeto de Pesquisa:** Estudo sobre Redes Definidas por Software (SDN).

This repository contains projects related to **Computer Networks**, including a practical project on Linux server setup and a research project on Software-Defined Networking (SDN).

---

## 🖥️ Parte 1: Projeto Prático - Servidor Web (Microsserviços)

### Descrição

Esta implementação demonstra uma infraestrutura de servidor web robusta, segura e baseada em microsserviços, orquestrada via Docker Compose. O sistema atende aos requisitos da disciplina integrando tecnologias heterogêneas (Java/Spring e PHP/Moodle) atrás de um único gateway (NGINX), com isolamento de redes e persistência de dados.

#### 🏗️ Arquitetura e Topologia

O projeto segue uma arquitetura onde o NGINX atua como o único ponto de entrada (Reverse Proxy) na porta 8080. Para garantir o "Princípio do Menor Privilégio", foram criadas duas redes internas isoladas:

- **backend (Rede Java):** Conecta NGINX ↔ Spring Petclinic ↔ PostgreSQL.
- **moodle_net (Rede PHP):** Conecta NGINX ↔ Moodle ↔ MariaDB.

#### 📦 Pilha Tecnológica (Versões Exatas)

| Serviço      | Tecnologia       | Versão       | Função                                |
| ------------ | ---------------- | ------------ | ------------------------------------- |
| Web Gateway  | NGINX            | latest       | Proxy Reverso e Servidor de Estáticos |
| LMS App      | Moodle           | 4.5-latest   | Plataforma de Ensino (PHP/Apache)     |
| LMS DB       | MariaDB          | 10.6         | Banco de dados para o Moodle          |
| Java App     | Spring Petclinic | Custom Build | Aplicação de exemplo Spring Boot      |
| Runtime Java | Eclipse Temurin  | JDK/JRE 25   | Runtime para o Petclinic              |
| Java DB      | PostgreSQL       | 15-alpine    | Banco de dados para o Petclinic       |

#### 🚀 Como Executar

Pré-requisitos: Docker e Docker Compose.

1. Clone o repositório e verifique as configurações:
   - Certifique-se de que o arquivo `./config/config.env` existe com as credenciais.
2. Suba os contêineres:

   ```sh
   docker compose up -d --build
   ```

3. Acesse as aplicações:
   - 🏠 Docs: http://localhost:8080
   - 🐶 Spring Petclinic: http://localhost:8080/petclinic
   - 🎓 Moodle LMS: http://localhost:8080/moodle

#### ⚙️ Destaques Técnicos da Implementação

- **Java Multi-Stage Build:** O Dockerfile compila o Java 25 em um estágio e executa em outro mais leve, otimizando segurança e tamanho.
- **NGINX Context Path:** Configuração avançada de `proxy_pass` (sem trailing slash) para garantir que o Moodle (PHP) resolva corretamente suas URIs internas.
- **Persistência:** Uso de volumes nomeados para garantir a integridade dos bancos de dados.

#### ✅ Requisitos do Projeto (EN)

- Server accessible through the laboratory network.
- Use of a **Linux or BSD operating system** chosen by the group.
- Installation and configuration of a **DBMS** (Database Management System).
- Support for **Java applications with database access** and deployment of a **Java Web application** (e.g., Tomcat).
- HTTP server configured with support for **PHP and database** (e.g., Apache HTTP, Nginx).
- Installation and availability of an **open source web application** via network (ERP, CRM, CMS, or LMS).
- All systems and applications must be installed and configured by the group members.
- Delivery of detailed documentation with the **step-by-step process** or optionally a video link demonstrating the execution.

#### 🛠️ Tecnologias Utilizadas

- Sistema Operacional: Ubuntu Server 22.04 LTS (exemplo)
- DBMS: PostgreSQL 15, MariaDB 10.6
- Java Web Server: Spring Petclinic (Eclipse Temurin JDK 25)
- HTTP Server: NGINX (Reverse Proxy)
- Aplicação Web Open Source: Moodle 4.5

---

## 📚 Parte 2: Projeto de Pesquisa - Software-Defined Networking (SDN)

### 📌 Visão Geral

Esta seção contém o projeto de pesquisa sobre Redes Definidas por Software (SDN), explorando seus conceitos, arquitetura, benefícios e aplicações no mundo real.

This repository contains a research project on **Software-Defined Networking (SDN)**, exploring its concepts, architecture, benefits, and applications.

#### ✅ Objetivos

- Compreender os fundamentos de SDN.
- Analisar a arquitetura: Plano de Controle, Plano de Dados e Plano de Aplicação.
- Discutir vantagens e desafios de SDN em redes modernas.
- Explorar casos de uso reais e ferramentas (ex: OpenFlow, Mininet, ONOS).

- Understand the fundamentals of SDN.
- Analyze the architecture: Control Plane, Data Plane, and Application Plane.
- Discuss advantages and challenges of SDN in modern networks.
- Explore real-world use cases and tools (e.g., OpenFlow, Mininet, ONOS).

#### 📂 Conteúdo / Contents

- `docs/labProject/` → Laboratory project documentation.
- `docs/SDNReport/` → SDN research report and slides.
- `relatorio_servidor_web.tex` → Relatório técnico do servidor web.

---

## 👨‍💻 Autores / Team Members

- Fernanda Martins da Silva ([Sunref](https://github.com/Sunref))
- Gabriel Maia Miguel ([gm64x](https://github.com/gm64x))
- Samuel Oliveira Lopes ([Samuskox](https://github.com/Samuskox))

Projeto desenvolvido para fins acadêmicos.
