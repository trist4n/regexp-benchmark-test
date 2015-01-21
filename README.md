regexp-benchmark-test
=====================

testing different regexp approaches to matches a largeish corpus of strings against web pages.

page that DOES match
========================================

perls builtin regexp engine
---------------------------
* iterate over each regexp (lazy stop on first match): 3.5198994 seconds
* iterate over each regexp: 
* one big (thing|thing2) regexp: 9.1522887 seconds
* one big assembled (Regexp::Assemble) regexp: 0.0006374 seconds (?? seems suspicious but it matched)

googles re2 regexp engine
-------------------------
* iterate over each regexp (lazy stop on first match):
* one big (thing|thing2) regexp:
* one big assembled (Regexp::Assemble) regexp:

