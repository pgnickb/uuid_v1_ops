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
uuid_v1_get_timestamptz(PG_FUNCTION_ARGS)
{
	pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
	uint64		res = 0;
	uint64		gns;			/* number of 100ns intervals since EPOCH */

	gns = ((uint64) ((arg1->data[order[0]]) & 0x0F)) << 56;
	for (int i = 1; i < UUID_V1_TIMESTAMP_LEN; ++i)
	{
		/* this conversion is safe regardless of the endiannes */
		gns += ((uint64) arg1->data[order[i]]) << ((UUID_V1_TIMESTAMP_LEN - i - 1) * 8);
	}

	res = (gns / UUID_V1_100NS_TO_USEC) - GREGORIAN_BEGINNING_OFFSET_USEC;
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
	int			res;

	for (int i = 0; i < UUID_LEN; ++i)
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

Datum
uuid_v1_get_node_id(PG_FUNCTION_ARGS)
{
	pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
	macaddr    *result;

	result = (macaddr *) palloc(sizeof(macaddr));

	result->a = arg1->data[UUID_V1_NODE_OFFSET_A];
	result->b = arg1->data[UUID_V1_NODE_OFFSET_B];
	result->c = arg1->data[UUID_V1_NODE_OFFSET_C];
	result->d = arg1->data[UUID_V1_NODE_OFFSET_D];
	result->e = arg1->data[UUID_V1_NODE_OFFSET_E];
	result->f = arg1->data[UUID_V1_NODE_OFFSET_F];

	PG_RETURN_MACADDR_P(result);
}

Datum
uuid_v1_get_clock_seq(PG_FUNCTION_ARGS)
{
	pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
	int16		seq;

	seq = ((int16) ((arg1->data[UUID_V1_SEQ_OFFSET]) & 0x3F)) << 8;
	seq += arg1->data[UUID_V1_SEQ_OFFSET + 1];

	PG_RETURN_INT16(seq);
}

Datum
uuid_v1_get_variant(PG_FUNCTION_ARGS)
{
	pg_uuid_t  *arg1 = PG_GETARG_UUID_P(0);
	int16		v;

	v = ((int16) ((arg1->data[UUID_V1_SEQ_OFFSET]) & 0xC0)) >> 6;

	PG_RETURN_INT16(v);
}


Datum
uuid_v1_create_from(PG_FUNCTION_ARGS)
{
	TimestampTz ts = PG_GETARG_TIMESTAMPTZ(0);
	int16		clock_seq = PG_GETARG_INT16(1);
	macaddr    *node = PG_GETARG_MACADDR_P(2);
	pg_uuid_t  *res;

	res = (pg_uuid_t *) palloc(sizeof(*res));

	/*
	 * Convert PostgreSQL epoch usec timestamptz to the UUID v1 Gregorian
	 * epoch 0.1usec This can overflow, so we need to be careful. UUID v1
	 * Timestamp is unsigned and thus can't represent dates before it's epoch.
	 */

	if (ts > UUID_V1_GREATEST_SUPPORTED_TIMESTAMP ||
		ts < UUID_V1_LEAST_SUPPORTED_TIMESTAMP)
	{
		ereport(ERROR,
				(errcode(ERRCODE_DATETIME_VALUE_OUT_OF_RANGE),
				 errmsg("timestamp value out of range for UUID v1")));
	}

	ts = (ts + GREGORIAN_BEGINNING_OFFSET_USEC) * UUID_V1_100NS_TO_USEC;

	/* We try to keep further modifications endiannes-neutral */

	/* timestamp low bytes */
	res->data[0] = (uint8) ((ts & 0xff000000) >> 24);
	res->data[1] = (uint8) ((ts & 0xff0000) >> 16);
	res->data[2] = (uint8) ((ts & 0xff00) >> 8);
	res->data[3] = (uint8) ((ts & 0xff));

	/* timestamp mid bytes */
	res->data[4] = (uint8) ((ts & 0xff0000000000) >> 40);
	res->data[5] = (uint8) ((ts & 0xff00000000) >> 32);

	/* timestamp hi bytes and version */
	res->data[6] = (uint8) ((ts & 0x0f00000000000000) >> 56);
	/* append version to the upper MSB of timestamp hi */
	res->data[6] |= (1 << 4);
	res->data[7] = (uint8) ((ts & 0xff000000000000) >> 48);

	/* clock seq hi and reserved */
	res->data[8] = (uint8) ((clock_seq & 0x3f00) >> 8);
	/* append reserver to the clock seq high */
	res->data[8] |= 0x80;
	/* clock seq low */
	res->data[9] = (uint8) (clock_seq & 0xff);

	/* node id */
	res->data[10] = node->a;
	res->data[11] = node->b;
	res->data[12] = node->c;
	res->data[13] = node->d;
	res->data[14] = node->e;
	res->data[15] = node->f;

	PG_RETURN_UUID_P(res);
}
