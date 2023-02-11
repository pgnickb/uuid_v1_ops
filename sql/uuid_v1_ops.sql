\unset ECHO

/* setup */
\i test_setup.sql

/* try and create extension */
create extension uuid_v1_ops;

/* seed random for consistent dataset */
select setseed(0.2);

select plan(15);
/* tests: */

/* comparison */

select is(
            uuid_v1_cmp(uuid'00000000-0000-0000-0000-000000000000',
                        null::uuid
                        ), 
            null, 
            'uuid_v1_cmp handles nulls properly');

select is(
            uuid_v1_cmp(uuid'00000000-0000-0000-0000-000000000000',
                        uuid'bc2cd750-a63b-11ed-84a2-123456789112'
                        ) < 0, 
            true, 
            'Less then works fine');
select is(
            uuid_v1_cmp(uuid'bc2cd750-a63b-11ed-84a2-123456789112', 
                        uuid'00000000-0000-0000-0000-000000000000'
                        ) > 0, 
            true, 
            'Greater then works fine');
select is(
            uuid_v1_cmp(uuid'00000000-0000-0000-0000-000000000000', 
                        uuid'00000000-0000-0000-0000-000000000000'
                      ) = 0, 
            true, 
            'Equals works fine');
select is(
            uuid_v1_to_timestamptz(uuid'00000000-0000-0000-0000-000000000000') at time zone 'UTC', 
            timestamp'1582-10-15 00:00:00', 
            'Zero-uuid is the start of Gregorian calendar');
select is(
            uuid_v1_to_timestamptz(uuid'63b00000-bfde-11d3-0000-000000000000') at time zone 'UTC', 
            timestamp'2000-01-01 00:00:00', 
            'Timestamp of PostgreSQL Epoch');
select is(
            uuid_v1_to_timestamptz(uuid'bc2cd750-a63b-11ed-84a2-123456789112') at time zone 'UTC', 
            timestamp'2023-02-06 16:31:40.869', 
            'Some random timestamp');

/* is_uuid works fine */

select is(
            is_uuid_v1(uuid'00000000-0000-1000-0000-000000000000'),
            true,
            'This UUID is correctly recognized as v1');

select is(
            is_uuid_v1(uuid'00000000-0000-2000-0000-000000000000'),
            false,
            'This UUID is correctly recognized as non-v1');

select is(
            is_uuid_v1(null::uuid),
            null,
            'This UUID is correctly recognized as non-v1');

/* tests with various operators and their interactions with nulls */

select is(uuid'00000000-0000-2000-0000-000000000000' ~<  null, null,  '~< handles null properly');
select is(uuid'00000000-0000-2000-0000-000000000000' ~<= null, null, '~<= handles null properly');
select is(uuid'00000000-0000-2000-0000-000000000000' =   null, null,   '= handles null properly');
select is(uuid'00000000-0000-2000-0000-000000000000' ~>= null, null, '~>= handles null properly');
select is(uuid'00000000-0000-2000-0000-000000000000' ~>  null, null,  '~> handles null properly');


select * from finish();
