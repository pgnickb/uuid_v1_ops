/* setup */
\unset ECHO
\set QUIET 1
/* Turn off echo and keep things quiet. */

/* Format the output. */
\pset format unaligned
\pset tuples_only true
\pset pager off

/* Revert all changes on failure. */
\set ON_ERROR_ROLLBACK 1
\set ON_ERROR_STOP true

/* We're in a new session now, so we should set session variables */
set client_min_messages = 'error';
/* this is necessary because that is what ajtime expects */
set datestyle = 'iso';
set log_statement = 'none';

begin;

/* initialize testing environment */

/* helper functions that might be useful for testing: */

/* hackrandom(anyelement) returns float8
 *
 * The purpose of this function is to reference a column of an arbitrary
 * type yet simply return a random() float8.
 * This is useful when one needs to generate a random value and use it in
 * several places within the same query. In such a case, if the `lateral`
 * function call doesn't reference any columns, then pg actually ends up
 * calling the function only once per query. Contrary, when there is a
 * reference to a column, the function is called for each row.
 *
 * Example of usage:
 * select x, r
 *   from generate_series(1, 10) as f(x),
 *        hackrandom(x) as g(r);
 *
 * Naive implementation for comparison:
 * select x, r
 *   from generate_series(1, 10) as f(x),
 *        random() as g(r);
 *
 * (Note how latter has same random number for each row)
 */

create or replace function public.hackrandom(x anyelement)
    returns float8
    language sql volatile as
$sql$
    select random() + 0 * (x is null)::int;
$sql$;


/* get_plan_jsonb(text) returns jsonb
 * Get jsonb-plan of the supplied query.
 * 
 * No effort is put into making sure the query is valid or to protect 
 * against SQLi. It is the caller's responsibility to sanitize the input.
 */
create or replace function public.explain_plan_jsonb(q text)
    returns jsonb
    language plpgsql volatile as
$fnc$
declare
    _plan jsonb;
begin
    execute format('explain (costs off, format json) %s', q) into _plan;
    return _plan;
end;
$fnc$;



/* Load the pgTAP functions. */
\i pgtap.sql
