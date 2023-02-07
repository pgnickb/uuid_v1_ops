\unset ECHO

/* setup */
\i test_setup.sql


/* try and create extension */
create extension uuid_v1_ops;

/* seed random for consistent dataset */
select setseed(0.2);

select plan(3);
/* tests */
select is(uuid_v1_cmp(uuid'00000000-0000-0000-0000-000000000000', uuid'bc2cd750-a63b-11ed-84a2-6930cf67f2dc') < 0, true, 'Less then works fine');
select is(uuid_v1_cmp(uuid'bc2cd750-a63b-11ed-84a2-6930cf67f2dc', uuid'00000000-0000-0000-0000-000000000000') > 0, true, 'Greater then works fine');
select is(uuid_v1_cmp(uuid'00000000-0000-0000-0000-000000000000', uuid'00000000-0000-0000-0000-000000000000') = 0, true, 'Equals works fine');

select * from finish();
