/* src/sql/025_operators */

create operator class  uuid_v1_ops
    for type uuid using btree as
    operator    1   <  (uuid, uuid),
    operator    2   <= (uuid, uuid),
    operator    3   =  (uuid, uuid),
    operator    4   >= (uuid, uuid),
    operator    5   >  (uuid, uuid),
    function    1   uuid_v1_cmp(uuid, uuid);
