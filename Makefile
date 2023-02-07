EXTENSION = uuid_v1_ops
EXTVERSION = 1.0

DATA = $(filter-out $(DATA_built), $(wildcard *--*.sql))
PGFILEDESC = "$(EXTENSION) v$(EXTVERSION)"

TESTS        = $(wildcard sql/*.sql)
REGRESS      = $(patsubst sql/%.sql,%,$(TESTS))
# REGRESS_OPTS = --inputdir=test --load-language=plpgsql

MODULE_big = $(EXTENSION)
	OBJS = \
		$(WIN32RES) \
		$(EXTENSION).o

define CONTROL_FILE_CONTENT
# $(EXTENSION) extension
comment = '$(EXTENSION) - adds support for UUID v1 specific btree operator'
default_version = '1.0'
relocatable = true
module_pathname = '$libdir/$(EXTENSION)'
endef

define EXT_PREFIX
/* $(EXTENSION)--$(EXTVERSION).sql */

-- complain if script is sourced in psql, rather than via create extension
\echo Use "create extension $(EXTENSION) version '$(EXTVERSION)'" to load this file. \quit
endef

export CONTROL_FILE_CONTENT
export EXT_PREFIX

DATA_built = $(CONTROL_FILE_NAME) $(EXTENSION)--$(EXTVERSION).sql
CONTROL_FILE_NAME := $(addsuffix .control, $(EXTENSION))

PG_CONFIG ?= pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

#GOOD_RESULTS = $(wildcard tap_results/sql/*.sql)
#RESULT_TARGET = $(patsubst tap_results/sql/%.sql,expected/%.out,$(wildcard tap_results/sql/*.sql))

ifdef VERBOSE
ARGS="--verbose"
endif

$(EXTENSION)--$(EXTVERSION).sql : src/sql/00_schemas.sql src/sql/05_types.sql src/sql/10_tables.sql src/sql/20_functions.sql src/sql/25_operators.sql src/sql/30_misc.sql
	@echo "$$EXT_PREFIX" > $@
	cat $^ >> $@


$(CONTROL_FILE_NAME):
	@echo "$$CONTROL_FILE_CONTENT" > $@

test:
	pg_prove $(ARGS) -a ./tap_results/ $(TESTS)

