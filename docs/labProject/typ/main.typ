#import "@preview/apa7-ish:0.2.2": *


#show: conf.with(
  title: "Implementation and Configuration of a Web Server",
  subtitle: "Practical Approach with PostgreSQL, NGINX, Apache, and Open Source Applications",
  documenttype: "Technical Report",
  anonymous: false,
  authors: (
    (
      name: "Fernanda Martins da Silva",
      affiliation: "Federal Institute of São Paulo, São João da Boa Vista Campus",
    ),
    (
      name: "Gabriel Maia Miguel",
      affiliation: "Federal Institute of São Paulo, São João da Boa Vista Campus",
      corresponding: true,
    ),
    (
      name: "Samuel Oliveira Lopes",
      affiliation: "Federal Institute of São Paulo, São João da Boa Vista Campus",
    ),
  ),
  abstract: [This report presents a practical approach to the implementation and configuration of web servers using open-source technologies such as DBMS, NGINX, Apache, and various web applications. The project demonstrates the step-by-step setup of a robust and modular environment, leveraging containerization with Docker Compose to orchestrate multiple interconnected services. Key challenges, technical decisions, and integration strategies are discussed, providing a comprehensive guide for replicating and understanding the deployment of modern web infrastructures.],
  //date: "October 20, 2025",
  keywords: [web server, NGINX, Apache, DBMS, PostgreSQL, open source, implementation, configuration],
  //  funding: [Funding Statement],

  resumo: [This report presents a practical approach to the implementation and configuration of web servers using open-source technologies such as DBMS, NGINX, Apache, and different web applications. The project demonstrates the step-by-step setup of a robust and modular environment, using containers orchestrated by Docker Compose to integrate multiple services. The main challenges, technical decisions, and integration strategies are discussed, offering a complete guide for replicating and understanding the deployment process of modern web infrastructures.
],
palavras-chave: [web server, NGINX, Apache, DBMS, PostgreSQL, open source, implementation, configuration]
)

= 1. Objectives

== 1.1 General Objective:
#label("general-objective")
Demonstrate the step-by-step implementation and configuration of a web server. For this, we will follow the requirements requested by the professor responsible for the Computer Networks Laboratory course. They are:

1. Implementation of a DBMS (Database Management System).
2. Host a Java Web application that interacts with the DBMS.
3. Configure an HTTP server with PHP support and integration with the DBMS.
4. The project must be accessible from the Laboratory network (LAN).
5. Use and provide open-source software from one of the following categories:
  - ERP (Enterprise Resource Planning)
  - CMS (Content Management System)
  - CRM (Customer Relationship Management)
  - LMS (Learning Management System)
6. Document the entire process of implementing and configuring the web server, including technical details, challenges faced, and solutions adopted.
7. (Optionally) Present the finished project for evaluation, highlighting the implemented features and the integration between the web server components through demonstration videos.

== 1.2 Specific Objectives
#label("specific-objectives")
- Understand in practice the concepts of computer networks applied to the implementation of web servers.
- Develop technical skills in configuring HTTP servers, DBMS, and web applications.
- Integrate different open-source technologies to create a functional and efficient solution.
- Document the implementation process, facilitating replication and learning by other students.
- Improve presentation and technical communication skills.

#pagebreak()


= 2. General Considerations
#label("general-considerations")
This section briefly presents the main networking concepts used in the development of the project. In the following sections, the difficulties faced and the reasons for the group's tool choices will be detailed. The aim is to provide a comprehensive view of the theoretical foundations applied, the challenges overcome, and the reasons that guided technical decisions throughout the implementation.

== 2.1 Related Work
The implementation of web servers is a fundamental practice in IT infrastructure. Traditionally, solution stacks such as LAMP (Linux, Apache, MySQL, PHP) or LEMP (Linux, Nginx, MySQL, PHP) have been widely used to host dynamic applications. These stacks provide a solid foundation, integrating operating system, web server, database management system, and scripting language.

However, with the evolution of cloud computing and the need for scalability and portability, container-based approaches such as Docker have gained prominence. Unlike traditional installations directly on the operating system ("bare metal"), the use of containers allows dependency isolation, making it easier to replicate the development environment to production and avoiding conflicts between libraries of different applications. This project adopts this modern approach, using Docker Compose to orchestrate multiple interconnected services.

== 2.2 Database Management Systems
Database Management Systems (DBMS) are critical components for data persistence and integrity in web applications. In this project, we chose to use two widely adopted open-source relational DBMS:

- *MariaDB*: A fork of MySQL, known for its robustness and compatibility. It is used here as the database for Moodle, ensuring native support and high performance for LMS operations.
- *PostgreSQL*: An advanced object-relational DBMS, recognized for its SQL standards compliance and extensibility. It is used by the Spring Petclinic application, demonstrating the server's ability to manage multiple types of databases simultaneously.

The choice to use separate containers for each database reinforces the principle of decoupling, allowing each application to have its own lifecycle and storage configuration.

== 2.3 Distributed vs. Monolithic Systems
Software architecture has shifted from monolithic models to distributed systems and microservices.

- *Monolithic Architecture*: Traditionally, web applications were built as a single indivisible unit. Although simpler to develop initially, they become difficult to maintain and scale as they grow, since any change requires recompiling and deploying the entire system.
- *Distributed Architecture (Microservices)*: The approach adopted in this project reflects distributed systems concepts. By separating the web server (NGINX), applications (Moodle, Petclinic), and databases into distinct containers, a modular environment is created. This allows, for example, updating the Java version of Petclinic without affecting Moodle's operation, or horizontally scaling the web server without unnecessarily replicating the databases. Docker Compose acts as the local orchestrator, defining the topology of this network of services.


= 3. Implementation
#label("implementation")

The project was implemented using Docker container technology, orchestrated by Docker Compose. This approach allows services to be isolated, simplifies configuration, and ensures environment portability. The project structure was organized into directories containing the specific configurations for each service.

Below, we detail the steps and configurations adopted for each component of the solution.

== 3.1 Solution Architecture
The architecture consists of five main containers, divided into internal networks for security and organization:

#figure(
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    [*Service*], [*Technology*], [*Function*],
    [web], [NGINX], [Reverse Proxy and Web Server],
    [moodle], [Moodle (Apache/PHP)], [Learning Management System (LMS)],
    [moodle-db], [MariaDB], [Moodle Database],
    [petclinic], [Spring Boot (Java)], [Sample Application (Java Web)],
    [petclinic-db], [PostgreSQL], [Petclinic Database],
  ),
  caption: [Server Architecture Components]
)

== 3.2 Reverse Proxy Configuration (NGINX)
NGINX acts as the entry point (Gateway) for the server. It listens on port 8080 (mapped to port 80 of the container) and redirects requests based on the accessed URL.

- *Route `/`*: Serves static HTML files located in `./html`.
- *Route `/moodle/`*: Redirects to the Moodle container.
- *Route `/petclinic/`*: Redirects to the Spring Petclinic application container.

The configuration was defined in the `nginx/default.conf` file, using the `proxy_pass` directive to forward traffic to the service hostnames defined in Docker Compose (`http://moodle` and `http://petclinic:8080`).

== 3.3 LMS Implementation (Moodle)
To meet the open-source software requirement (LMS), we used Moodle.
- *Database*: A `mariadb:10.6` container (`moodle-db`) was configured, with data persistence ensured by the `moodle_db_data` volume.
- *Application*: The `moodle` container uses the `brandkern/moodle:4.5-latest` image.
- *Configuration*: Environment variables (database, user, password, base URL) were externalized to the `config/moodle-db.env` and `config/moodle.env` files.
- *Apache Adjustment*: It was necessary to map a custom configuration file (`apache/000-default.conf`) to define the `Alias /moodle /var/www/html`, ensuring the application responds correctly in the subdirectory expected by the reverse proxy.

== 3.4 Java Application Implementation (Spring Petclinic)
The chosen Java application was *Spring Petclinic*, a classic example of a corporate application.
- *Database*: We used PostgreSQL (`petclinic-db`) version 15, with data persisted in the `petclinic_db_data` volume.
- *Application Build*: Unlike other ready-made images, the Java application is built locally using a multi-stage `Dockerfile`:
  1.  *Build Stage*: Uses a JDK image (Eclipse Temurin 25) to compile the project with Maven (`./mvnw package`).
  2.  *Execution Stage*: Uses a lighter JRE image to run the generated `.jar`.
- *Context Path*: The application was configured to run at the `/petclinic` context through the `server.servlet.context-path` property and environment variables in the `Dockerfile` and `config/petclinic.env`.

== 3.5 Orchestration with Docker Compose
The `compose.yml` file at the root of the project defines all services, networks, and volumes.
- **Networks**:
  - `backend`: Connects NGINX, Petclinic, and Petclinic-DB.
  - `moodle_net`: Connects NGINX, Moodle, and Moodle-DB.
  This segmentation prevents, for example, Moodle from directly accessing the Petclinic database and vice versa.
- **Volumes**: Named volumes (`moodle_data`, `moodle_db_data`, `petclinic_db_data`) ensure that data is not lost if containers are recreated.

To start the entire environment, use the command:
```bash
docker compose up -d --build
```

== 4. Conclusions and Recommendations
The development of this project successfully achieved the objective of implementing and configuring a functional and robust web server, integrating various open-source technologies. The use of Docker and Docker Compose proved to be a wise choice, drastically simplifying the deployment and configuration process of complex environments involving multiple languages (PHP, Java) and databases (MariaDB, PostgreSQL).

Among the main challenges overcome, the configuration of the reverse proxy with NGINX for correct traffic routing and the management of Docker's internal networks to ensure secure communication between applications and their respective databases stand out. The implementation of Moodle as LMS and Spring Petclinic as a Java application demonstrated the server's versatility in hosting different types of workloads.

As recommendations for future work and improvements to the current environment, it is suggested:
- *HTTPS Implementation*: Configure SSL/TLS certificates (for example, with Let's Encrypt) in NGINX to ensure data security in transit.
- *Monitoring and Logs*: Integrate tools such as Prometheus and Grafana for resource monitoring and centralized logging of containers.
- *Automated Backup*: Implement periodic backup scripts for the database data volumes and Moodle files.
- *CI/CD*: Establish a Continuous Integration and Delivery pipeline to automate application updates.

This project served as an excellent practical foundation for consolidating knowledge in computer networks, operating systems, and systems administration.

#pagebreak()


= Conflict of Interest Statement
#label("conflict-of-interest-statement")
The authors declare that there are no conflicts of interest to declare.

#pagebreak()

// add your .bib file here
//#bibliography("references.bib")
