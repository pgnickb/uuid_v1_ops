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

comment on function uuid_v1_get_timestamptz(uuid) is
$cmnt$
Returns PostgreSQL `timestamp with time zone` which corresponds to the timestamp encoded within the UUID supplied. It's callers responsibility to ensure the UUID is indeed v1. One option for that would be the to call `is_uuid_v1(uuid)` function.
NOTE: PostgreSQL `timestamptz` type has 1us precision, whereas the UUID v1 has 0.1us precision, thus there is some loss of precision. Users who are interested in preserving the original timestamp are encouraged to use `uuid_v1_get_timestamp_as_int8(uuid)` which returns an int8 (aka bigint) and deal with it according to their needs.
$cmnt$;

create or replace function uuid_v1_get_timestamp_as_int8(uuid)
    returns int8
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_get_timestamp_as_int8';

comment on function uuid_v1_get_timestamp_as_int8(uuid) is
$cmnt$
Returns the timestamp encoded within the UUID supplied as in `int8`. The number returned is guaranteed to be positive and fit into an `int8` positive range. The value represents the number of 100ns (or 0.1us) intervals from the beginning of the Gregorian calendar: 1582-10-15 00:00:00 UTC
$cmnt$;

create or replace function is_uuid_v1(uuid)
    returns boolean
    language c immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'is_uuid_v1';

comment on function is_uuid_v1(uuid) is
$cmnt$
Checks the version byte of the UUID supplied and returns true if it's v1.
$cmnt$;

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

comment on function uuid_v1_get_node_id(uuid) is
$cmnt$
Returns the last 6 bytes of the UUID as PostgreSQL `macaddr` type. RFC 4122 specifies these bytes as Node ID, however most implementations of UUID v1 generators use MAC address to populate these bytes.
$cmnt$;

create or replace function uuid_v1_get_clock_seq(uuid)
    returns int2
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_get_clock_seq';

comment on function uuid_v1_get_clock_seq(uuid) is
$cmnt$
Returns the clock sequence of the UUID v1. As per the spec:

> For UUID version 1, the clock sequence is used to help avoid
> duplicates that could arise when the clock is set backwards in time
> or if the node ID changes.

Usually these are just some random bits. The value is between 0 and 16383 (0x3fff).
$cmnt$;

create or replace function uuid_v1_get_variant(uuid)
    returns int2
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_get_variant';

comment on function uuid_v1_get_variant(uuid) is
$cmnt$
Returns the variant byte of the UUID. 
Refer to RFC 4122 paragraph 4.1.1. for more details.
$cmnt$;

create or replace function uuid_v1_create_from_ts(timestamptz, int2, macaddr)
    returns uuid
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_create_from_ts';

comment on function uuid_v1_create_from_ts(timestamptz, int2, macaddr) is
$cmnt$
Creates a UUID v1 from the supplied timestamp, clock sequence and MAC address. While this is enough to populate the UUID, it is worth mentioning that PostgreSQL timestamps have lower precision than that encoded within UUID v1, thus lowest 3-4 bits of the timestamp are going to be zero. If you're aiming to utilize the entire 16-bytes, consider using the `uuid_v1_create_from_int8` counterpart of this function.
$cmnt$;

create or replace function uuid_v1_create_from_int8(int8, int2, macaddr)
    returns uuid
    language C immutable
    parallel safe strict leakproof
    as 'uuid_v1_ops', 'uuid_v1_create_from_int8';

comment on function uuid_v1_create_from_int8(int8, int2, macaddr) is
$cmnt$
Creates a UUID v1 from the supplied timestamp as an int8, clock sequence and MAC address. This version of the `create_from` function allows utilizing all 60 bits of the timestamp field within UUID v1. 
NOTE: Since UUID v1 timestamp is only 60 bits wide the 4 most significant bits of the int8 should be 0 to avoid overflowing. Thus the int8 should be in the range: [0..1152921504606846975] or [0x0..0x 0f ff ff ff ff ff ff ff]
$cmnt$;

