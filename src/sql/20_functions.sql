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
