# Sources

These files are concatenated together to create the `$(EXTENSION)--$(EXTVERSION).sql` file.
The order is ensured by the numeric prefixes. The goal is to have readable diff. The cost is having to maintain changes in both upgrade script and here.
