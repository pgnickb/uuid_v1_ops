# Disclaimer

The extension is still under development. You are welcome to test it and submit feedback either via issues or via #postgresql on Libera.chat @nickb.
# UUID v1 Opclass

This extension provides the `uuid_v1_ops` opclass for indexes over UUID type. This enables a custom sorting order based on the timestamp encoded within the UUID.

For an introduction refer to the [wiki page](https://github.com/pgnickb/uuid_v1_ops/wiki)

The benefit of having this over a normal `uuid_ops` is the monotonically increasing nature of the timestamp (under intended workloads). Thus the index in question has values appeneded to its end. This in turn significantly reduces WAL traffic and results in up to 2x performance increase for ingest-heavy workloads.

Otherwise the performance penalty is negligible. 

# Installation

Simply run:
```bash
make
sudo make install
```

As long as you have `pg_config` in your path, this should just work. Drop the `sudo` if your PostgreSQL is running in the userspace.

# Tests

To run the standard regression test suite simply do:

```
make installcheck
```

If you have `pg_prove` available and like `pgTap` then you need to create a database named `test_uuid_v1_ops` and run:
```
make test
```

# Benchmarks

Below are results of a fairly primitive benchmark with a dataset of 40mil UUIDs. This is a "happy" path for our extension, but it's purpose is to demostrate the advantage of using a time UUID in its natural context.

```SQL
create table u(u uuid);
create index on u(u);

\copy u from ~/temp/40_mil_uuids
```

```
Total WAL generated: 7560 MB 
Time:                120115.153 ms (02:00.115) 
btree FPI %:         100.0
total FPI %:          39.3 
```
```SQL
create table v1(u uuid);
create index on v1(u uuid_v1_ops);

\copy v1 from ~/temp/40_mil_uuids
```

```
Total WAL generated: 3818 MB 
Time:                55582.802 ms (00:55.583) 
btree FPI %:         51.23 
total FPI %:          0.01 
```

