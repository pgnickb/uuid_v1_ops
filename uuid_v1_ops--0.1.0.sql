/* uuid_v1_ops--0.1.0.sql */

-- complain if script is sourced in psql, rather than via create extension
\echo Use "create extension uuid_v1_ops version '0.1.0'" to load this file. \quit
/* src/sql/00_ddl.sql */
/* src/sql/05_type.sql */
/* src/sql/10_tables.sql */
/* src/sql/10_functions.sql */

create or replace function uuid_v1_cmp(uuid, uuid)
    returns int4
    language C immutable 
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_cmp';

create or replace function uuid_v1_get_timestamptz(uuid)
    returns timestamptz
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_get_timestamptz';

create or replace function uuid_v1_get_timestamp_as_int8(uuid)
    returns int8
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_get_timestamp_as_int8';

create or replace function is_uuid_v1(uuid)
    returns boolean
    language c immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'is_uuid_v1';

create or replace function uuid_v1_lt(uuid,uuid)
    returns boolean
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_lt';
create or replace function uuid_v1_le(uuid,uuid)
    returns boolean
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_le';
create or replace function uuid_v1_eq(uuid,uuid)
    returns boolean
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_eq';
create or replace function uuid_v1_ge(uuid,uuid)
    returns boolean
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_ge';
create or replace function uuid_v1_gt(uuid,uuid)
    returns boolean
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_gt';

create or replace function uuid_v1_get_node_id(uuid)
    returns macaddr
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_get_node_id';

create or replace function uuid_v1_get_clock_seq(uuid)
    returns int2
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_get_clock_seq';

create or replace function uuid_v1_get_variant(uuid)
    returns int2
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_get_variant';

create or replace function uuid_v1_create_from_ts(timestamptz, int2, macaddr)
    returns uuid
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_create_from_ts';

create or replace function uuid_v1_create_from_int8(int8, int2, macaddr)
    returns uuid
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_create_from_int8';

/* src/sql/025_operators */

create operator ~< (
	function = uuid_v1_lt,
	leftarg = uuid,
	rightarg = uuid,
	commutator = >,
	negator = >=,
	restrict = scalarltsel,
	join = scalarltjoinsel);
create operator ~<= (
	function = uuid_v1_le,
	leftarg = uuid,
	rightarg = uuid,
	commutator = >=,
	negator = >,
	restrict = scalarltsel,
	join = scalarltjoinsel);
create operator = (
	function = uuid_v1_eq,
	leftarg = uuid,
	rightarg = uuid,
	commutator = =,
	negator = <>,
	restrict = eqsel,
	join = eqjoinsel,
	merges,
	hashes);
create operator ~>= (
	function = uuid_v1_ge,
	leftarg = uuid,
	rightarg = uuid,
	commutator = <=,
	negator = <,
	restrict = scalargtsel,
	join = scalargtjoinsel );
create operator ~> (
	function = uuid_v1_gt,
	leftarg = uuid,
	rightarg = uuid,
	commutator = <,
	negator = <=,
	restrict = scalargtsel,
	join = scalargtjoinsel );

create operator class  uuid_v1_ops
    for type uuid using btree as
    operator    1   ~<  (uuid, uuid),
    operator    2   ~<= (uuid, uuid),
    operator    3   =  (uuid, uuid),
    operator    4   ~>= (uuid, uuid),
    operator    5   ~>  (uuid, uuid),
    function    1   uuid_v1_cmp(uuid, uuid);
/* src/sql/20_misc.sql */
