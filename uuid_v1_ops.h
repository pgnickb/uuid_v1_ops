#ifndef UUID_V1_OPS_H
#define UUID_V1_OPS_H

#include "postgres.h"
#include "nodes/print.h"
#include "utils/builtins.h"
#include "utils/sortsupport.h"
#include "utils/uuid.h"
#include "utils/inet.h"
#include "utils/timestamp.h"

#define UUID_V1_100NS_TO_USEC 10L
#define UUID_V1_TIMESTAMP_LEN 8
#define GREGORIAN_BEGINNING_OFFSET_USEC 13165977600000000
#define UUID_VERSION_OFFSET 6

#define UUID_V1_NODE_OFFSET_A 10
#define UUID_V1_NODE_OFFSET_B 11
#define UUID_V1_NODE_OFFSET_C 12
#define UUID_V1_NODE_OFFSET_D 13
#define UUID_V1_NODE_OFFSET_E 14
#define UUID_V1_NODE_OFFSET_F 15

#define UUID_V1_SEQ_OFFSET 8

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(is_uuid_v1);
Datum		is_uuid_v1(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_cmp);
Datum		uuid_v1_cmp(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_internalize);
Datum		uuid_v1_internalize(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_to_timestamptz);
Datum		uuid_v1_to_timestamptz(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_lt);
Datum		uuid_v1_lt(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_le);
Datum		uuid_v1_le(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_eq);
Datum		uuid_v1_eq(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_ge);
Datum		uuid_v1_ge(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_gt);
Datum		uuid_v1_gt(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_get_node_id);
Datum		uuid_v1_get_node_id(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_get_clock_seq);
Datum		uuid_v1_get_clock_seq(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_get_variant);
Datum		uuid_v1_get_variant(PG_FUNCTION_ARGS);

static int	uuid_v1_internal_cmp(const pg_uuid_t *arg1, const pg_uuid_t *arg2);

static unsigned int order[UUID_LEN] = {6, 7, 4, 5, 0, 1, 2, 3, 8, 9, 10, 11, 12, 13, 14, 15};

#endif							/* UUID_V1_OPS_H */
