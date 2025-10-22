#import "@preview/apa7-ish:0.2.2": *

#show: conf.with(
  title: "Implementação e Configuração de um Servidor Web",
  subtitle: "Abordagem Prática com PostgreeSQL, NGINX, Apache e Aplicações de Código Aberto",
  documenttype: "Relatório Técnico",
  anonymous: false,
  authors: (
    (
      name: "Fernanda Martins da Silva",
      affiliation: "Instituto Federal de São Paulo, Campus São João da Boa Vista",
    ),
    (
      name: "Gabriel Maia Miguel",
      affiliation: "Instituto Federal de São Paulo, Campus São João da Boa Vista",
      corresponding: true,
    ),
    (
      name: "Samuel Oliveira Lopes",
      affiliation: "Instituto Federal de São Paulo, Campus São João da Boa Vista",
    ),
  ),
  abstract: [Este relatório apresenta uma abordagem prática para a implementação e configuração de servidores web, utilizando SGBD, NGINX, Apache e aplicações de código aberto.],
  //date: "20 de outubro de 2025",
  keywords: [servidor web, NGINX, Apache, SGBD, PostgreeSQL, código aberto, implementação, configuração],
  //  funding: [Declaração de Financiamento],
)


= 1. Objetivos

== 1.1 Objetivo Geral:
#label("objetivo-geral")
Demonstrar a implementação e configuração passo a passo de um servidor web. Para isso, seguiremos os seguintes requisitos solicitados pelo professor responsável pela disciplina de Laboratório de Redes de Computadores. São eles:

1. Implementação de um SGBD (Sistema de Gerenciamento de Banco de Dados).
2. Hospedar uma aplicação Java Web que interaja com o SGBD.
3. Configurar um servidor HTTP com suporte a PHP e integração com o SGBD.
4. O Projeto deve estar acessível a partir da rede do Laboratório (LAN).
5. Utilizar e disponibilizar software de código aberto de uma das seguintes categorias:
  - ERP (Enterprise Resource Planning)
  - CMS (Content Management System)
  - CRM (Customer Relationship Management)
  - LMS (Learning Management System)
6. Documentar todo o processo de implementação e configuração do servidor web, incluindo detalhes técnicos, desafios enfrentados e soluções adotadas.
7. (Opcionalmente) Apresentar o projeto finalizado para avaliação, destacando as funcionalidades implementadas e a integração entre os componentes do servidor web por meio de vídeos demonstrativos.

== 1.2 Objetivos Específicos
#label("objetivos-especificos")
- Compreender de forma pratica os conceitos de redes de computadores aplicados na implementação de servidores web.
- Desenvolver habilidades técnicas na configuração de servidores HTTP, SGBD e aplicações web.
- Integrar diferentes tecnologias de código aberto para criar uma solução funcional e eficiente.
- Documentar o processo de implementação, facilitando a replicação e o aprendizado por parte de outros estudantes.
- Melhorar as habilidades de apresentação e comunicação técnica.

#pagebreak()

= 2. Considerações Gerais
#label("consideracoes-gerais")
Esta seção apresenta os principais conceitos de redes utilizados no desenvolvimento do projeto de forma breve. Nas seções seguintes, serão detalhadas as dificuldades enfrentadas e justificadas as escolhas das ferramentas adotadas pelo grupo. De modo a fornecer uma visão abrangente dos fundamentos teóricos aplicados, dos desafios superados e dos motivos que orientaram as decisões técnicas ao longo da implementação.

== 2.1 Trabalhos Correlatos
#lorem(200)

== 2.2 Sistemas Gerenciadores de Banco de Dados
#lorem(120)

== 2.3 Sistemas Distribuídos vs. Monolíticos
#lorem(180)



== 3. Metodologia
#lorem(30)

#lorem(50)

#lorem(70)

#lorem(90)

== 4. Conclusões e recomendações
#lorem(50)

#lorem(120)

#lorem(90)

#pagebreak()

= Declaração de Conflito de Interesses
#label("declaracao-de-conflito-de-interesses")
Os autores declaram não haver conflitos de interesse a declarar.

#pagebreak()

// adicione seu arquivo .bib aqui
//#bibliography("references.bib")
