/* uuid_v1_ops--1.0.sql */

-- complain if script is sourced in psql, rather than via create extension
\echo Use "create extension uuid_v1_ops version '1.0'" to load this file. \quit
/* src/sql/00_ddl.sql */
/* src/sql/05_type.sql */
/* src/sql/10_tables.sql */
/* src/sql/10_functions.sql */

create or replace function uuid_v1_cmp(uuid, uuid)
    returns int4
    language C immutable as 'uuid_v1_ops', 'uuid_v1_cmp';


create or replace function uuid_v1_internalize(uuid)
    returns uuid
    language C immutable as 'uuid_v1_ops', 'uuid_v1_internalize';

create or replace function uuid_v1_to_timestamptz(uuid)
    returns int8
    language c stable as 'uuid_v1_ops', 'uuid_v1_to_timestamptz';
/* src/sql/025_operators */

create operator class  uuid_v1_ops
    for type uuid using btree as
    operator    1   <  (uuid, uuid),
    operator    2   <= (uuid, uuid),
    operator    3   =  (uuid, uuid),
    operator    4   >= (uuid, uuid),
    operator    5   >  (uuid, uuid),
    function    1   uuid_v1_cmp(uuid, uuid);
/* src/sql/20_misc.sql */
