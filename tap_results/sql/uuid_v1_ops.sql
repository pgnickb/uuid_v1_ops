1..48
ok 1 - > comparison works
ok 2 - < comparison works
ok 3 - >= comparison works
ok 4 - <= comparison works
ok 5 - uuid_v1_cmp handles nulls properly
ok 6 - Less then works fine
ok 7 - Greater then works fine
ok 8 - Equals works fine
ok 9 - Zero-uuid is the start of Gregorian calendar
ok 10 - Timestamp of PostgreSQL Epoch
ok 11 - Some random timestamp
ok 12 - Zero-uuid is 0 int8
ok 13 - PostgreSQL Epoch is a proper int
ok 14 - Some random timestamp is a proper int8
ok 15 - This UUID is correctly recognized as v1
ok 16 - This UUID is correctly recognized as non-v1
ok 17 - This UUID is correctly recognized as non-v1
ok 18 - ~< handles null properly
ok 19 - ~<= handles null properly
ok 20 - = handles null properly
ok 21 - ~>= handles null properly
ok 22 - ~> handles null properly
ok 23 - All-zeroes node id address
ok 24 - All-ones node id address
ok 25 - Some random node id address
ok 26 - get_node_id handles nulls properly
ok 27 - All-zeroes clock-sequence
ok 28 - All-ones clock-sequence
ok 29 - Some random clock-sequence
ok 30 - get_clock_seq handles nulls properly
ok 31 - All-zeroes variant
ok 32 - Variant 1
ok 33 - Variant 2
ok 34 - Variant 3
ok 35 - get_variant handles nulls properly
ok 36 - create_from_ts handles nulls properly
ok 37 - Timestamptz UUID generation is consistent
ok 38 - UUID v1 from PostgreSQL timestamptz overflows as expected
ok 39 - UUID v1 from PostgreSQL int8 overflows as expected
ok 40 - int8 UUIDs generation is consistent
ok 41 - int8 UUIDs generation is consistent
ok 42 - create_from_int8 handles nulls properly
ok 43 - Planner recognizes uuid_v1_ops index as usable for the ~< operator
ok 44 - Planner recognizes uuid_v1_ops index as usable for the ~> operator
ok 45 - Planner recognizes uuid_v1_ops index as usable for the ~<= operator
ok 46 - Planner recognizes uuid_v1_ops index as usable for the ~>= operator
ok 47 - Planner recognizes uuid_v1_ops index as usable for the = operator
ok 48 - UUID v1 are correctly reversed into components
