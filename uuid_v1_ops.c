#include <uuid_v1_ops.h>

Datum 
uuid_v1_internalize(PG_FUNCTION_ARGS)
{
    pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
    unsigned char a1s[UUID_LEN];

    for (int i=0;i<UUID_LEN;++i)
    {
        a1s[i] = arg1->data[order[i]];
    }

    memcpy(arg1->data, a1s, UUID_LEN);

    PG_RETURN_UUID_P(arg1);

}

Datum 
uuid_v1_to_timestamptz(PG_FUNCTION_ARGS)
{
    pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
    uint64 gns; /* number of 100ns intervals since EPOCH */

    gns = (uint64)((uint8) *(arg1 -> data) & 15) << 56;
    for (int i=1; i<UUID_V1_TIMESTAMP_LEN; ++i)
    {
        gns += arg1->data[order[i]] << ((UUID_V1_TIMESTAMP_LEN-i-1) * 8);
    }

    PG_RETURN_TIMESTAMPTZ(gns);
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
    /* MSB ......... LSB
     * 0809 0607 0405 00010203
     */
    unsigned char a1s[UUID_LEN];
    unsigned char a2s[UUID_LEN];

    for (int i=0;i<UUID_LEN;++i)
    {
        a1s[i] = arg1->data[order[i]];
        a2s[i] = arg2->data[order[i]];
    }

	return memcmp(a1s, a2s, UUID_LEN);
}
