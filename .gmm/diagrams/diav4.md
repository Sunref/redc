Let me update the diagrams to reflect a containerized architecture using Docker and Docker Compose.

First, let's look at the high-level container architecture:

```mermaid
flowchart TD
    classDef client fill:#f9f,stroke:#333,color:#000
    classDef docker fill:#69f,stroke:#333,color:#fff
    classDef container fill:#9ff,stroke:#333,color:#000
    
    subgraph Client["Client Layer"]
        Browser["Web Browser"]:::client
        Mobile["Mobile Apps"]:::client
    end
    
    subgraph DockerHost["Docker Host"]
        DockerEngine["Docker Engine<br/><i>Container Runtime</i>"]:::docker
        
        subgraph Containers["Container Network"]
            Apache["Apache Container<br/><i>HTTP & PHP</i>"]:::container
            Tomcat["Tomcat Container<br/><i>Java Apps</i>"]:::container
            MariaDB["MariaDB Container<br/><i>Data Storage</i>"]:::container
            PHPMyAdmin["phpMyAdmin Container<br/><i>DB Admin</i>"]:::container
        end
        
        DockerCompose["docker-compose.yml<br/><i>Orchestration</i>"]:::docker
    end
    
    Browser --> DockerEngine
    Mobile --> DockerEngine
    DockerEngine --> Apache
    DockerEngine --> Tomcat
    DockerEngine --> MariaDB
    DockerEngine --> PHPMyAdmin
    DockerCompose -.-> Apache
    DockerCompose -.-> Tomcat
    DockerCompose -.-> MariaDB
    DockerCompose -.-> PHPMyAdmin
```

In this containerized architecture:

- Purple components represent client applications
- Blue components show Docker infrastructure managing containers
- Light blue components represent individual containers running specific services
- Dotted lines indicate Docker Compose's orchestration control over containers

All containers communicate through Docker's internal network, while Docker Engine manages their lifecycle and resources. Docker Compose orchestrates the entire stack through a single configuration file.

Let's examine how these containers interact with each other:

```mermaid
sequenceDiagram
    participant C as Client
    participant DE as Docker Engine
    participant AC as Apache Container
    participant TC as Tomcat Container
    participant MC as MariaDB Container
    participant PM as phpMyAdmin
    
    Note over C,PM: Secure Connection Establishment
    C->>+DE: HTTPS Request
    DE->>-C: TLS Handshake
    
    alt PHP Application Path
        C->>+DE: HTTP Request
        DE->>+AC: Route to Apache
        AC->>+MC: MySQL Query
        MC-->>-AC: Query Result
        AC-->>-DE: Processed Response
        DE-->>-C: HTTP Response
    else Java Application Path
        C->>+DE: HTTP Request
        DE->>+TC: Route to Tomcat
        TC->>+MC: JDBC Query
        MC-->>-TC: Query Result
        TC-->>-DE: Processed Response
        DE-->>-C: HTTP Response
    else Admin Access
        C->>+DE: phpMyAdmin Request
        DE->>+PM: Route to phpMyAdmin
        PM->>+MC: Database Admin
        MC-->>-PM: Admin Response
        PM-->>-DE: UI Response
        DE-->>-C: HTTP Response
    end
```

This sequence diagram illustrates three main request flows through the containerized system:

1. PHP Application Path: Handles PHP-based applications running in Apache container
2. Java Application Path: Manages Java applications running in Tomcat container
3. Admin Access: Provides secure database administration through phpMyAdmin

Docker Engine acts as a central router, directing traffic to appropriate containers while maintaining security through TLS encryption. Each container operates independently but communicates securely through Docker's internal network.

Let's examine the system lifecycle in a containerized environment:

```mermaid
stateDiagram-v2
    [*] --> Init: docker-compose up
    
    state "Container Initialization" as Init {
        Init --> PullImages: Pull Docker Images
        PullImages --> CreateNetwork: Create Network
        CreateNetwork --> StartDB: Start MariaDB
        
        state "Database Setup" as DBSetup {
            StartDB --> DBReady: Wait for DB Ready
            DBReady --> InitSchema: Initialize Schema
            InitSchema --> DBConfigured: Configure Users
        }
        
        state "Web Services" as WebServices {
            StartDB --> StartApache: Start Apache
            StartApache --> ConfigPHP: Configure PHP-FPM
            ConfigPHP --> StartTomcat: Start Tomcat
            StartTomcat --> DeployApps: Deploy Applications
        }
        
        DBSetup --> WebServices
    }
    
    Init --> Running: All Containers Up
    Running --> Maintenance: docker-compose exec
    Maintenance --> Running: Updates Applied
    
    state "Error Handling" as Error {
        Running --> ContainerError: Container Failure
        ContainerError --> Recovery: docker-compose restart
        Recovery --> Running: Container Restored
    }
```

The state diagram shows the container lifecycle where:

- Image pulling creates local copies of container templates
- Network creation enables secure communication between containers
- DB Ready state waits for MariaDB to accept connections before proceeding
- PHP-FPM (FastCGI Process Manager) handles PHP processing separately from Apache for better performance

Error handling automatically restarts failed containers while maintaining data consistency through persistent volumes.

Finally, let's look at the physical deployment architecture:

```mermaid
flowchart LR
    classDef hardware fill:#f96,stroke:#333,color:#000
    classDef docker fill:#69f,stroke:#333,color:#fff
    classDef container fill:#9ff,stroke:#333,color:#000
    
    subgraph Host["Host Machine"]
        CPU["CPU"]:::hardware
        RAM["RAM"]:::hardware
        DISK["Storage"]:::hardware
    end
    
    subgraph DockerEnv["Docker Environment"]
        DE["Docker Engine"]:::docker
        NET["Bridge Network"]:::docker
        VOLS["Volume Storage"]:::docker
    end
    
    subgraph Containers["Application Containers"]
        direction TB
        WEB["Web Server<br/><i>Apache/Nginx</i>"]:::container
        APP["App Server<br/><i>Tomcat</i>"]:::container
        DB["Database<br/><i>MariaDB</i>"]:::container
        ADMIN["Admin Tools<br/><i>phpMyAdmin</i>"]:::container
    end
    
    CPU --> DE
    RAM --> DE
    DISK --> VOLS
    DE --> NET
    NET --> WEB & APP & DB & ADMIN
    VOLS -.-> DB
    VOLS -.-> WEB
```

This deployment diagram shows the complete container infrastructure where:

- Orange components represent host machine resources
- Blue components indicate Docker infrastructure
- Light blue components show individual application containers
- Dotted lines to Volumes indicate persistent storage mounts for data preservation

The Bridge Network enables secure communication between containers, while Volume Storage maintains data persistence across container restarts. Each container runs isolated processes but shares necessary resources through controlled interfaces.

These diagrams together provide a complete picture of your containerized server infrastructure project. They show how Docker and Docker Compose simplify deployment while maintaining the robust architecture of the previous design. Each component now runs in isolation, improving security and maintainability while preserving all required functionality.
