1..42
ok 1 - uuid_v1_cmp handles nulls properly
ok 2 - Less then works fine
ok 3 - Greater then works fine
ok 4 - Equals works fine
ok 5 - Zero-uuid is the start of Gregorian calendar
ok 6 - Timestamp of PostgreSQL Epoch
ok 7 - Some random timestamp
ok 8 - Zero-uuid is 0 int8
ok 9 - PostgreSQL Epoch is a proper int
ok 10 - Some random timestamp is a proper int8
ok 11 - This UUID is correctly recognized as v1
ok 12 - This UUID is correctly recognized as non-v1
ok 13 - This UUID is correctly recognized as non-v1
ok 14 - ~< handles null properly
ok 15 - ~<= handles null properly
ok 16 - = handles null properly
ok 17 - ~>= handles null properly
ok 18 - ~> handles null properly
ok 19 - All-zeroes node id address
ok 20 - All-ones node id address
ok 21 - Some random node id address
ok 22 - get_node_id handles nulls properly
ok 23 - All-zeroes clock-sequence
ok 24 - All-ones clock-sequence
ok 25 - Some random clock-sequence
ok 26 - get_clock_seq handles nulls properly
ok 27 - All-zeroes variant
ok 28 - Variant 1
ok 29 - Variant 2
ok 30 - Variant 3
ok 31 - get_variant handles nulls properly
ok 32 - create_from_ts handles nulls properly
ok 33 - Timestamptz UUID generation is consistent
ok 34 - int8 UUIDs generation is consistent
ok 35 - int8 UUIDs generation is consistent
ok 36 - create_from_int8 handles nulls properly
ok 37 - Planner recognizes uuid_v1_ops index as usable for the ~< operator
ok 38 - Planner recognizes uuid_v1_ops index as usable for the ~> operator
ok 39 - Planner recognizes uuid_v1_ops index as usable for the ~<= operator
ok 40 - Planner recognizes uuid_v1_ops index as usable for the ~>= operator
ok 41 - Planner recognizes uuid_v1_ops index as usable for the ~>= operator
ok 42 - UUID v1 are correctly reversed into components
