1..30
ok 1 - uuid_v1_cmp handles nulls properly
ok 2 - Less then works fine
ok 3 - Greater then works fine
ok 4 - Equals works fine
ok 5 - Zero-uuid is the start of Gregorian calendar
ok 6 - Timestamp of PostgreSQL Epoch
ok 7 - Some random timestamp
ok 8 - This UUID is correctly recognized as v1
ok 9 - This UUID is correctly recognized as non-v1
ok 10 - This UUID is correctly recognized as non-v1
ok 11 - ~< handles null properly
ok 12 - ~<= handles null properly
ok 13 - = handles null properly
ok 14 - ~>= handles null properly
ok 15 - ~> handles null properly
ok 16 - All-zeroes node id address
ok 17 - All-ones node id address
ok 18 - Some random node id address
ok 19 - get_node_id handles nulls properly
ok 20 - All-zeroes clock-sequence
ok 21 - All-ones clock-sequence
ok 22 - Some random clock-sequence
ok 23 - get_clock_seq handles nulls properly
ok 24 - All-zeroes variant
ok 25 - Variant 1
ok 26 - Variant 2
ok 27 - Variant 3
ok 28 - get_variant handles nulls properly
ok 29 - create_from handles nulls properly
ok 30 - For some crude timestampts UUID generation is reversible
