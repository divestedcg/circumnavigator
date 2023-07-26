Circumnavigator: A DNS Comparator
=================================

Overview
--------
This is a simple script to check a list of domains against a DNS resolver to determine their rough effectiveness of proclaimed blocking capabilities. 

Use
---
- source test.sh; #grab the functions
- downloadLists; #download the bad lists
- runAllTests; #start all tests in background
- haltTests; #use to abort all the background threads

Credits
-------
- domains-good.txt is from Wikipedia (CC BY-SA 4.0): https://en.wikipedia.org/wiki/List_of_most_visited_websites
- domains-bad.txt is from:
  - Abuse.ch (CC0): https://urlhaus.abuse.ch/api/
  - CERT.PL ("free to use for everyone"): https://cert.pl/en/posts/2020/03/malicious_domains/

Donate
------
- https://divested.dev/donate
