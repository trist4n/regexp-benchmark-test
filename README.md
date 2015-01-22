regexp-benchmark-test
=====================

testing different regexp approaches to matches a largeish corpus of strings against web pages.

page that DOES match, full list 
========================================

perls builtin regexp engine
---------------------------
* iterate over each regexp (lazy stop on first match): 3.5198994 seconds (this is only 'fast' because a regexp early in the list hits)
* iterate over each regexp: 865.303898 seconds (...)
* one big (thing|thing2) regexp: 9.1522887 seconds
* one big assembled (Regexp::Assemble) regexp: 0.0006374 seconds (?? seems suspicious but it matched)
* one big compressed assembled (Regexp::Assemble::Compressed) regexp: 0.0006388
