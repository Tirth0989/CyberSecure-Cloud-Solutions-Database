# CyberSecure Cloud Solutions Database

A Microsoft SQL Server portfolio project covering relational database modelling, normalization, ERD development, implementation, stored procedures, views, triggers, and testing.

## Assessment results

Both stages of this INFO601 project received full marks.

### Assessment 1 - Data Modelling

**Grade: 100/100**  
**Graded: 1 June 2026**

> Excellent understanding of ERD shown in your assignment. Each section is well explained.

The design report covers entity and attribute identification, primary and foreign keys, relationship cardinality, normalization through Third Normal Form, indexing strategies, an entity-relationship diagram, and draft data-entry forms.

### Assessment 2 - Advanced SQL

**Grade: 100/100**  
**Graded: 11 June 2026**

> Excellent creation of Views, stored procedures and Triggers. Each section is validated with screenshots so well done.

| Assessment area | Score |
|---|---:|
| Tables, relationships, keys, data types, and population | 30/30 |
| Views | 25/25 |
| Stored procedures | 25/25 |
| Triggers | 10/10 |
| Testing evidence | 10/10 |
| **Total** | **100/100** |

## Database features

- Six related tables: clients, accounts, services, subscriptions, billing, and cybersecurity incidents
- Primary and foreign keys enforcing one-to-many relationships
- Account-to-service many-to-many relationship resolved through subscriptions
- Normalized relational design through 3NF
- Check, unique, default, and positive-value constraints
- Indexes supporting common account, subscription, billing, and incident queries
- Four views for client accounts, subscribed services, billing, and incident reporting
- Stored procedures for inserting, updating, and deleting records
- Triggers that maintain account modification dates and enforce business rules
- Seed data for testing and demonstration

## Repository files

| File | Purpose |
|---|---|
| [01_Create_Populate.sql](01_Create_Populate.sql) | Creates the database, tables, constraints, indexes, and sample data |
| [02_Views_Procedures_Triggers.sql](02_Views_Procedures_Triggers.sql) | Creates reporting views, CRUD procedures, and business-rule triggers |
| [Assessment 1 - Data Modelling report](docs/Tirth_Patel_INFO601_Assessment1_Data_Modelling_Report.pdf) | Documents the ERD, relationships, normalization, indexing, and proposed forms |
| [Assessment 2 - Advanced SQL report](docs/Tirth_Patel_INFO601_Assessment2_Report.pdf) | Contains implementation and testing evidence with screenshots |

## Running the SQL implementation

Requirements:

- Microsoft SQL Server
- SQL Server Management Studio, Azure Data Studio, or another compatible T-SQL client

Run the scripts in this order:

1. Execute `01_Create_Populate.sql`.
2. Execute `02_Views_Procedures_Triggers.sql`.
3. Query the views or execute the stored procedures to validate the installation.

The first script creates and selects `CyberSecureCloudSolutionsDB`. The second script expects that database to exist.

## Project context

This repository combines the design and implementation stages of the INFO601 Data Modelling and SQL project. The Assessment 2 public report has its student ID removed for privacy; the Assessment 1 report did not contain a numeric student ID.

No open-source license is applied because this repository is an academic portfolio submission.
