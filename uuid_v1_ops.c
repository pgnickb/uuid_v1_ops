#include <uuid_v1_ops.h>

Datum 
is_uuid_v1(PG_FUNCTION_ARGS)
{
    pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
    PG_RETURN_BOOL(
        (arg1->data[UUID_VERSION_OFFSET] & 0xf0) == 0x10
        );
}

Datum 
uuid_v1_to_timestamptz(PG_FUNCTION_ARGS)
{
    pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
    uint64 res = 0;
    uint64 gns; /* number of 100ns intervals since EPOCH */
    gns = ((uint64) ((arg1->data[order[0]]) & 0x0F)) << 56;
    for (int i=1; i<UUID_V1_TIMESTAMP_LEN; ++i)
    {
        /* this conversion is safe regardless of the endiannes */
        gns += ((uint64) arg1->data[order[i]]) << ((UUID_V1_TIMESTAMP_LEN-i-1) * 8);
    }

    res = (gns/UUID_V1_100NS_TO_USEC)-GREGORIAN_BEGINNING_OFFSET_USEC;
    PG_RETURN_TIMESTAMPTZ(res);
}

Datum
uuid_v1_cmp(PG_FUNCTION_ARGS)
{
	pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
	pg_uuid_t  *arg2 = PG_GETARG_UUID_P(1);

	PG_RETURN_INT32(uuid_v1_internal_cmp(arg1, arg2));
}

static int
uuid_v1_internal_cmp(const pg_uuid_t *arg1, const pg_uuid_t *arg2)
{
    int res;

    for (int i=0;i<UUID_LEN;++i)
    {
        res = arg1->data[order[i]] - arg2->data[order[i]];
        if (res != 0)
            break;
    }

	return res;
}

Datum
uuid_v1_lt(PG_FUNCTION_ARGS)
{
	pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
	pg_uuid_t  *arg2 = PG_GETARG_UUID_P(1);

	PG_RETURN_BOOL(uuid_v1_internal_cmp(arg1, arg2) < 0);
}

Datum
uuid_v1_le(PG_FUNCTION_ARGS)
{
	pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
	pg_uuid_t  *arg2 = PG_GETARG_UUID_P(1);

	PG_RETURN_BOOL(uuid_v1_internal_cmp(arg1, arg2) <= 0);
}

Datum
uuid_v1_eq(PG_FUNCTION_ARGS)
{
	pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
	pg_uuid_t  *arg2 = PG_GETARG_UUID_P(1);

	PG_RETURN_BOOL(uuid_v1_internal_cmp(arg1, arg2) == 0);
}

Datum
uuid_v1_ge(PG_FUNCTION_ARGS)
{
	pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
	pg_uuid_t  *arg2 = PG_GETARG_UUID_P(1);

	PG_RETURN_BOOL(uuid_v1_internal_cmp(arg1, arg2) >= 0);
}

Datum
uuid_v1_gt(PG_FUNCTION_ARGS)
{
	pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
	pg_uuid_t  *arg2 = PG_GETARG_UUID_P(1);

	PG_RETURN_BOOL(uuid_v1_internal_cmp(arg1, arg2) > 0);
}
