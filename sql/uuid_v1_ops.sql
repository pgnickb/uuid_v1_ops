\unset ECHO

/* setup */
\i test_setup.sql

/* try and create extension */
create extension uuid_v1_ops;

/* seed random for consistent dataset */
select setseed(0.2);

select plan(36);
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

/* get_timesamptz tests*/

select is(
            uuid_v1_get_timestamptz(uuid'00000000-0000-0000-0000-000000000000') at time zone 'UTC', 
            timestamp'1582-10-15 00:00:00', 
            'Zero-uuid is the start of Gregorian calendar');

select is(
            uuid_v1_get_timestamptz(uuid'63b00000-bfde-11d3-0000-000000000000') at time zone 'UTC', 
            timestamp'2000-01-01 00:00:00', 
            'Timestamp of PostgreSQL Epoch');
select is(
            uuid_v1_get_timestamptz(uuid'bc2cd750-a63b-11ed-84a2-123456789112') at time zone 'UTC', 
            timestamp'2023-02-06 16:31:40.869', 
            'Some random timestamp');

/* get_timesamptz tests*/

select is(
            uuid_v1_get_timestamp_as_int8(uuid'00000000-0000-0000-0000-000000000000'), 
            0::int8, 
            'Zero-uuid is 0 int8');

select is(
            uuid_v1_get_timestamp_as_int8(uuid'63b00000-bfde-11d3-0000-000000000000'), 
            131659776000000000::int8, 
            'PostgreSQL Epoch is a proper int');
select is(
            uuid_v1_get_timestamp_as_int8(uuid'bc2cd750-a63b-11ed-84a2-123456789112'), 
            138949939008690000::int8,
            'Some random timestamp is a proper int8');

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

/* get_node_id tests */
select is(uuid_v1_get_node_id('00000000-0000-1000-b000-000000000000'), '00:00:00:00:00:00',  'All-zeroes node id address');
select is(uuid_v1_get_node_id('00000000-0000-1000-b000-ffffffffffff'), 'ff:ff:ff:ff:ff:ff',  'All-ones node id address');
select is(uuid_v1_get_node_id('00000000-0000-0000-0000-123456789abc'), '12:34:56:78:9a:bc',  'Some random node id address');
select is(uuid_v1_get_node_id(null), null,  'get_node_id handles nulls properly');

/* get_clock_seq tests */
select is(uuid_v1_get_clock_seq('00000000-0000-1000-8000-000000000000'), 0::int2,  'All-zeroes clock-sequence');
select is(uuid_v1_get_clock_seq('00000000-0000-1000-7fff-000000000000'), 16383::int2,  'All-ones clock-sequence');
select is(uuid_v1_get_clock_seq('00000000-0000-1000-9357-000000000000'), 4951::int2,  'Some random clock-sequence');
select is(uuid_v1_get_clock_seq(null), null,  'get_clock_seq handles nulls properly');

/* get_variant tests */
select is(uuid_v1_get_variant('00000000-0000-1000-0000-000000000000'), 0::int2,  'All-zeroes variant');
select is(uuid_v1_get_variant('00000000-0000-1000-4000-000000000000'), 1::int2,  'Variant 1');
select is(uuid_v1_get_variant('00000000-0000-1000-8000-000000000000'), 2::int2,  'Variant 2');
select is(uuid_v1_get_variant('00000000-0000-1000-c000-000000000000'), 3::int2,  'Variant 3');
select is(uuid_v1_get_variant(null), null,  'get_variant handles nulls properly');

/* create_from_ts tests */

select is(
        uuid_v1_create_from_ts(now(), null, null),
        null,
        'create_from_ts handles nulls properly');

/* xxx in principle this is a strict test, as precision of 
 * the PostgreSQL timestamptz type is lower that that of the
 * UUID v1 (1usec vs 0.1usec respectively).
 * Meaning if the UUID was created using this function,
 * it is inevitably going to be consistently reversible.
 */

with gen as (
    select
            u,
            uuid_v1_create_from_ts(
                        uuid_v1_get_timestamptz(u),
                        uuid_v1_get_clock_seq(u),
                        uuid_v1_get_node_id(u)) as g
        from generate_series('2020-10-20 00:00:00 UTC',
                             '2020-10-30 00:00:00 UTC',
                             interval'20 minutes') as f(x),
        uuid_v1_create_from_ts(x,
                            0::int2,
                            macaddr'12:34:56:78:91:12') as g(u)
), cnt as(
    select count(*) as c
        from gen
        where u != g
)
select is(c, 0::int8, 'Timestamptz UUID generation is consistent') from cnt;

/* create_from_int8 tests */

select is(
        uuid_v1_create_from_int8(
                uuid_v1_get_timestamp_as_int8(u),
                uuid_v1_get_clock_seq(u),
                uuid_v1_get_node_id(u)),
        u,
        'int8 UUIDs generation is consistent')
    from (values (uuid'c7485dbc-ae15-11ed-a708-012345678901'),
                 (uuid'c7e73842-ae15-11ed-be05-012345678901'))
         as f(u);

select is(
        uuid_v1_create_from_int8(null, null, null),
        null,
        'create_from_int8 handles nulls properly');

select * from finish();
