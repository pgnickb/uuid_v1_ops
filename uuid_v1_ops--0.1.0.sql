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
    parallel safe
    as 'uuid_v1_ops', 'uuid_v1_cmp';


create or replace function uuid_v1_internalize(uuid)
    returns uuid
    language C immutable 
    parallel safe
    as 'uuid_v1_ops', 'uuid_v1_internalize';

create or replace function uuid_v1_to_timestamptz(uuid)
    returns timestamptz
    language c stable 
    parallel safe
    as 'uuid_v1_ops', 'uuid_v1_to_timestamptz';


create or replace function uuid_v1_lt(uuid,uuid)
    returns boolean
    language C immutable
    parallel safe
    as 'uuid_v1_ops', 'uuid_v1_lt';
create or replace function uuid_v1_le(uuid,uuid)
    returns boolean
    language C immutable
    parallel safe
    as 'uuid_v1_ops', 'uuid_v1_le';
create or replace function uuid_v1_eq(uuid,uuid)
    returns boolean
    language C immutable
    parallel safe
    as 'uuid_v1_ops', 'uuid_v1_eq';
create or replace function uuid_v1_ge(uuid,uuid)
    returns boolean
    language C immutable
    parallel safe
    as 'uuid_v1_ops', 'uuid_v1_ge';
create or replace function uuid_v1_gt(uuid,uuid)
    returns boolean
    language C immutable
    parallel safe
    as 'uuid_v1_ops', 'uuid_v1_gt';
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