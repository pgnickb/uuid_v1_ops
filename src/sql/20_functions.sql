/* src/sql/10_functions.sql */

create or replace function uuid_v1_cmp(uuid, uuid)
    returns int4
    language C immutable 
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_cmp';

create or replace function uuid_v1_to_timestamptz(uuid)
    returns timestamptz
    language C stable 
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_to_timestamptz';

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

