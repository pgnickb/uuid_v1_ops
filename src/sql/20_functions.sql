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
