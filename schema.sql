-- Enumerated types capture consistent value sets used across tables.
create type rating_enum as enum('Poor', 'Fair', 'Average', 'Good', 'Excellent');
create type copy_status_enum as enum('available', 'unavailable');
create type reservation_status_enum as enum('active', 'completed', 'canceled');

-- Library members who borrow or review books.
create table members (
  member_id SERIAL primary key,
  member_name VARCHAR(255) not null,
  member_phone VARCHAR(20) not null
);

-- Core book metadata tracked in the catalog.
create table books (
  book_id SERIAL primary key,
  title varchar(255) not null,
  publication_year smallint,
  isbn varchar(13) unique
);

-- Author reference data.
create table authors (
  author_id SERIAL primary key,
  author_name varchar(255) not null
);

-- Category reference data (e.g., genre or shelving group).
create table categories (
  category_id serial primary key,
  category_name varchar(20)
);

-- Many-to-many links between books and authors.
create table book_authors (
  book_id int references books (book_id),
  author_id int references authors (author_id),
  primary key (book_id, author_id)
);

-- Many-to-many links between books and categories.
create table book_categories (
  book_id int references books (book_id),
  category_id int references categories (category_id),
  primary key (book_id, category_id)
);

-- Member-submitted ratings and optional review text for books.
create table reviews (
  member_id int references members (member_id),
  book_id int references books (book_id),
  rating rating_enum not null,
  review_text text
);

-- Physical or digital copies tracked for availability.
create table inventory (
  copy_id serial primary key,
  book_id int references books (book_id),
  copy_status copy_status_enum not null
);

-- Book reservations placed by members.
create table reservations (
  reservation_id serial primary key,
  member_id int references members (member_id),
  book_id int references books (book_id),
  reservation_date date,
  reservation_status reservation_status_enum not null
);

-- Loan records for checked-out copies, including return tracking.
create table loans (
  loan_id serial primary key,
  copy_id int references inventory (copy_id),
  member_id int references members (member_id),
  checkout_date date,
  due_date date,
  return_date date
);



