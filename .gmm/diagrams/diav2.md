# Project Guidelines: Visualized

This document provides various diagrams to visualize the workflow, architecture, and management of the server installation and configuration project.

---

## 1. Project Workflow (Flowchart)

This flowchart illustrates the high-level, step-by-step process for completing the project from start to finish.

```mermaid
graph TD
    A([Start]) --> B([Install Linux/BSD OS])
    B --> C([Configure Network])
    C --> D([Install DBMS MariaDB/MySQL])
    D --> E([Install Java Environment e.g., OpenJDK])
    E --> F([Install Java Web Server e.g., Apache Tomcat])
    F --> G([Deploy Custom Java Web App])
    G --> H([Install HTTP Server e.g., Apache/Nginx])
    H --> I([Configure PHP Support])
    I --> J([Install Open Source Web App CMS, ERP, etc.])
    J --> K([Final Testing])
    K --> L([Document the Process])
    L --> M([End])
```

---

## 2. System Interaction (Sequence Diagram)

This diagram shows how different components of the system interact when a user accesses the Java web application.

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant TomcatServer as Apache Tomcat
    participant JavaWebApp as Java Web App
    participant Database as MariaDB/MySQL

    User->>Browser: Access Java App URL
    Browser->>TomcatServer: GET /webapp
    TomcatServer->>JavaWebApp: Process request
    JavaWebApp->>Database: SQL Query
    Database-->>JavaWebApp: Return results
    JavaWebApp-->>TomcatServer: Generate HTML response
    TomcatServer-->>Browser: Send HTML page
    Browser-->>User: Display page
```

---

## 3. Java Application (Simplified Class Diagram)

This is a simplified example of a class structure for the Java web application that interacts with the database.

```mermaid
classDiagram
    class User {
      -int userId
      -String username
      +getUserDetails()
    }
    class Product {
      -int productId
      -String name
      -float price
      +getProductInfo()
    }
    class Order {
      -int orderId
      -List~Product~ items
      +calculateTotal()
    }
    class DatabaseConnector {
      -Connection connection
      +connect()
      +executeQuery()
    }

    User "1" -- "0..*" Order : places
    Order "1" -- "1..*" Product : contains
    User ..> DatabaseConnector : uses
    Order ..> DatabaseConnector : uses
```

---

## 4. Server Setup (State Diagram)

This diagram represents the various states of the server throughout the installation and configuration process.

```mermaid
stateDiagram-v2
    [*] --> Off
    Off --> Installing_OS: Power On
    Installing_OS --> Configuring_Network: Installation Complete
    Configuring_Network --> Installing_Services: Network OK
    Installing_Services --> Deploying_Apps: Services Installed
    Deploying_Apps --> Running: Deployment Successful
    Running --> Maintenance: Take Offline for Updates
    Maintenance --> Running: Updates Complete
    Running --> Off: Shutdown
```

---

## 5. Database Schema (ERD)

An example Entity-Relationship Diagram for a simple Content Management System (CMS) that could be hosted on the server.

```mermaid
erDiagram
    USERS {
        int id PK
        varchar username
        varchar email
    }
    POSTS {
        int id PK
        varchar title
        text content
        int user_id FK
    }
    CATEGORIES {
        int id PK
        varchar name
    }
    POST_CATEGORIES {
        int post_id PK, FK
        int category_id PK, FK
    }

    USERS ||--|{ POSTS : writes
    POSTS }o--o{ POST_CATEGORIES : " "
    CATEGORIES }o--o{ POST_CATEGORIES : " "
```

---

## 6. Project Timeline (Gantt Chart)

This Gantt chart provides a sample timeline to help plan and manage the project tasks.

```mermaid
gantt
    title Project Timeline
    dateFormat  YYYY-MM-DD
    section Phase 1: Setup
    OS Installation       :done,    des1, 2024-10-21, 1d
    Network Configuration :done,    des2, 2024-10-22, 1d
    section Phase 2: Core Services
    Install DBMS          :active,  des3, 2024-10-23, 2d
    Install Java & Tomcat :         des4, 2024-10-25, 2d
    section Phase 3: Application Deployment
    Deploy Java Web App   :         des5, 2024-10-27, 3d
    Install Apache & PHP  :         des6, 2024-10-30, 2d
    Deploy PHP App        :         des7, 2024-11-01, 3d
    section Phase 4: Finalization
    System Testing        :         des8, 2024-11-04, 2d
    Create Documentation  :         des9, 2024-11-06, 3d
```

---

## 7. System Usage (UML Use Case Diagram)

This diagram shows the different ways users and administrators can interact with the fully configured server.

```mermaid
graph TD
    subgraph "System"
        UC1["Access Java App"]
        UC2["Access PHP App"]
        UC3["Manage Server"]
        UC4["Configure Services"]
        UC5["Deploy Applications"]
    end

    User["End User"]
    Admin["Administrator"]

    User --> UC1
    User --> UC2
    Admin --> UC3
    Admin --> UC4
    Admin --> UC5
```

---

## 8. Server Architecture Diagram

This diagram outlines the high-level architecture of the server, showing how the different software layers are stacked.

```mermaid
graph TD
    subgraph "User Layer"
        U[Users via Lab Network]
    end

    subgraph "Application Layer"
        JWA[Java Web App]
        PWA[Open Source PHP App]
    end

    subgraph "Web/App Server Layer"
        TC[Apache Tomcat]
        AS[Apache HTTP / Nginx]
    end

    subgraph "Service Layer"
        DB[(MariaDB)]
        Java[Java/JDK]
        PHP[PHP Engine]
    end

    subgraph "Operating System Layer"
        OS[Linux / BSD]
    end

    subgraph "Hardware Layer"
        HW[Physical Server or VM]
    end

    U --> TC
    U --> AS
    TC --> JWA
    AS --> PWA
    JWA --> Java
    JWA --> DB
    PWA --> PHP
    PWA --> DB
    TC & AS --> OS
    Java & PHP & DB --> OS
    OS --> HW
```
