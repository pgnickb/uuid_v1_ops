# UUID v1 Opclass

This extension provides the `uuid_v1_ops` opclass for indexes over UUID type. This enables a custom sorting order based on the timestamp encoded within the UUID.

The benefit of having this over a normal `uuid_ops` is the monotonically increasing nature of the timestamp (under intended workloads). Thus the index in question has values appeneded to its end. This in turn significantly reduces WAL traffic and results in up to 2x performance increase for ingest-heavy workloads.

Otherwise the performance penalty is negligible. 
