-- Horizontal view
create or replace view good_reviews as
select
  *
from
  reviews
where
  rating = 'Good'
  -- Vertical view
create or replace view titles_books as
select
  book_id,
  title
from
  books
where
  publication_year > 1950
  --
  -- View that involves multiple tables
drop view if exists books_authors_categories_view;

create or replace view books_authors_categories_view as
select
  b.book_id,
  b.title,
  string_agg(distinct c.category_name, ', ') as categories,
  string_agg(distinct a.author_name, ', ') as author_name
from
  book_authors as ba
  left join books as b on ba.book_id = b.book_id
  left join authors as a on ba.author_id = a.author_id
  left join book_categories as bc on bc.book_id = b.book_id
  left join categories as c on c.category_id = bc.category_id
group by
  b.book_id,
  b.title;

-- Mixed view
create or replace view active_members as
select
  m.member_id,
  m.member_name,
  m.member_phone,
  count(l.loan_id) as loan_count
from
  members as m
  join loans as l on l.member_id = m.member_id
group by
  m.member_id,
  m.member_name,
  m.member_phone
having
  count(l.loan_id) >= 1;


-- View that uses subqueries
create or replace view book_avg_ratings as
select
  b.book_id,
  b.title,
  (
    select
      round(
        avg(
          case r.rating
            when 'Poor' then 1
            when 'Fair' then 2
            when 'Average' then 3
            when 'Good' then 4
            when 'Excellent' then 5
          end
        ),
        1
      )
    from
      reviews r
    where
      r.book_id = b.book_id
  ) as avg_rating
from
  books b
where
  (
    select
      round(
        avg(
          case r.rating
            when 'Poor' then 1
            when 'Fair' then 2
            when 'Average' then 3
            when 'Good' then 4
            when 'Excellent' then 5
          end
        ),
        1
      )
    from
      reviews r
    where
      r.book_id = b.book_id
  ) >= 4;


-- Past loans view 
create or replace view past_loans
as
select l.loan_id, l.copy_id, b.title, l.return_date
from loans l
join inventory as i on i.copy_id = l.copy_id
join books as b on b.book_id = i.book_id
where l.return_date IS NOT NULL;

-- Current loans view
create or replace view current_loans
as
select l.loan_id, l.copy_id, b.title, l.return_date
from loans l
join inventory as i on i.copy_id = l.copy_id
join books as b on b.book_id = i.book_id
where l.return_date IS NULL;

-- View with using UNION
select *
from past_loans
union all
select *
from current_loans;


-- The view that selects from another view
create or replace view book_and_categories
as
SELECT title, categories
from books_authors_categories_view;


-- The view with CHECK OPTION
create view available_inventory as
select copy_id, book_id, copy_status
from inventory
where copy_status = 'available'
with check option;





