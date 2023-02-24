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
    operator    3   =   (uuid, uuid), /* built in uuid equality operator */
    operator    4   ~>= (uuid, uuid),
    operator    5   ~>  (uuid, uuid),
    function    1   uuid_v1_cmp(uuid, uuid);
