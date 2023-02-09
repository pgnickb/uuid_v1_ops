#ifndef UUID_V1_OPS_H
#define UUID_V1_OPS_H

#include "postgres.h"
#include "nodes/print.h"
#include "utils/builtins.h"
#include "utils/sortsupport.h"
#include "utils/uuid.h"
#include "utils/timestamp.h"

#define UUID_V1_100NS_TO_USEC 10L
#define UUID_V1_TIMESTAMP_LEN 8
#define GREGORIAN_BEGINNING_OFFSET_USEC 13165977600000000

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(uuid_v1_cmp);
Datum uuid_v1_cmp(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_internalize);
Datum uuid_v1_internalize(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(uuid_v1_to_timestamptz);
Datum uuid_v1_to_timestamptz(PG_FUNCTION_ARGS);

static int uuid_v1_internal_cmp(const pg_uuid_t *arg1, const pg_uuid_t *arg2);

static unsigned int order[UUID_LEN] = {6,7,4,5,0,1,2,3,8,9,10,11,12,13,14,15};

#endif /* UUID_V1_OPS_H */
