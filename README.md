# Artur Omelian — Data Engineering Portfolio

**Email:** harturicko@gmail.com | **LinkedIn:** linkedin.com/in/harturicko |

---

## Library Management System Database

A comprehensive relational database design for managing library operations including book inventory, member loans, reservations, and reviews.

### Project Overview

This project demonstrates practical database design skills including normalization, relationship modeling, and advanced SQL querying. The system handles real-world library scenarios such as tracking book copies, managing member borrowing history, and aggregating book ratings.

---

### Database Schema

**Core Entities:**

| Table | Purpose | Key Features |
|-------|---------|--------------|
| `members` | Library member records | Contact information tracking |
| `books` | Book catalog metadata | ISBN validation, publication year |
| `authors` | Author reference data | Normalized from books |
| `categories` | Genre/shelving groups | Flexible categorization |
| `inventory` | Physical/digital copies | Availability status tracking |
| `loans` | Checkout records | Due date and return tracking |
| `reservations` | Book hold requests | Status workflow management |
| `reviews` | Member ratings & feedback | Enum-based rating system |

**Relationship Tables:**

- `book_authors` — Many-to-many link between books and authors
- `book_categories` — Many-to-many link between books and categories

---

### Technical Highlights

**Custom ENUM Types for Data Integrity:**
```sql
create type rating_enum as enum('Poor', 'Fair', 'Average', 'Good', 'Excellent');
create type copy_status_enum as enum('available', 'unavailable');
create type reservation_status_enum as enum('active', 'completed', 'canceled');
```

**Normalized Design:**
- 3NF normalization separating authors and categories from books
- Junction tables with composite primary keys for many-to-many relationships
- Foreign key constraints enforcing referential integrity

**Appropriate Data Types:**
- `SERIAL` for auto-incrementing primary keys
- `VARCHAR(13)` for ISBN (standard length)
- `SMALLINT` for publication year (space-efficient)
- `TEXT` for variable-length review content

---

### SQL Views Demonstrating Query Skills

**1. Multi-Table JOIN with Aggregation:**
```sql
create or replace view books_authors_categories_view as
select
  b.book_id,
  b.title,
  string_agg(distinct c.category_name, ', ') as categories,
  string_agg(distinct a.author_name, ', ') as author_name
from book_authors as ba
  left join books as b on ba.book_id = b.book_id
  left join authors as a on ba.author_id = a.author_id
  left join book_categories as bc on bc.book_id = b.book_id
  left join categories as c on c.category_id = bc.category_id
group by b.book_id, b.title;
```

**2. Subquery with CASE Statement for Rating Calculation:**
```sql
create or replace view book_avg_ratings as
select
  b.book_id,
  b.title,
  (
    select round(avg(
      case r.rating
        when 'Poor' then 1
        when 'Fair' then 2
        when 'Average' then 3
        when 'Good' then 4
        when 'Excellent' then 5
      end
    ), 1)
    from reviews r
    where r.book_id = b.book_id
  ) as avg_rating
from books b
where (...) >= 4;
```

**3. Active Members with Loan Count (HAVING clause):**
```sql
create or replace view active_members as
select
  m.member_id,
  m.member_name,
  m.member_phone,
  count(l.loan_id) as loan_count
from members as m
  join loans as l on l.member_id = m.member_id
group by m.member_id, m.member_name, m.member_phone
having count(l.loan_id) >= 1;
```

**4. View with CHECK OPTION for Data Integrity:**
```sql
create view available_inventory as
select copy_id, book_id, copy_status
from inventory
where copy_status = 'available'
with check option;
```

**5. UNION for Combined Loan History:**
```sql
create or replace view all_loans as
select * from past_loans
union all
select * from current_loans;
```

---

### Skills Demonstrated

| Category | Skills |
|----------|--------|
| **Database Design** | Normalization (3NF), ER modeling, relationship mapping |
| **SQL DDL** | CREATE TABLE, ENUM types, PRIMARY/FOREIGN keys, constraints |
| **SQL DML** | Complex JOINs, aggregations, subqueries, CASE statements |
| **Advanced SQL** | Views, STRING_AGG, HAVING, UNION, WITH CHECK OPTION |
| **Data Integrity** | Foreign key constraints, ENUM validation, CHECK options |

---

### Entity-Relationship Diagram

The database follows a normalized structure with clear entity relationships:

- **One-to-Many:** Books → Inventory, Members → Loans, Members → Reviews
- **Many-to-Many:** Books ↔ Authors (via book_authors), Books ↔ Categories (via book_categories)

*See attached ER diagram (er-diagram.pdf)*

---

### Source Files

1. `schema.sql` — Database schema creation script
2. `views.sql` — View definitions and queries
3. `er-diagram.pdf` — Entity-relationship diagram

---

**Technologies:** PostgreSQL, SQL, Database Design

