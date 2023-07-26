Circumnavigator: A DNS Comparator
=================================

Overview
--------
This is a simple script to check lists of domains against a DNS resolver to determine their rough effectiveness of proclaimed blocking capabilities.

Use
---
- source test.sh; #grab the functions
- downloadLists; #download the bad lists
- runAllTests; #start all tests in background
- collateResults; #use to combine the final results after all tests complete
- haltTests; #use to abort all the background threads

Limitations
-----------
- Doesn't account for domains that are actually dead

Credits
-------
- domains-good.txt is from Wikipedia (CC BY-SA 4.0): https://en.wikipedia.org/wiki/List_of_most_visited_websites
- domains-bad.txt is from:
  - Abuse.ch (CC0): https://urlhaus.abuse.ch/api/
  - CERT.PL ("free to use for everyone"): https://cert.pl/en/posts/2020/03/malicious_domains/
  - Disconnect (GPL-3.0): https://disconnect.me/trackerprotection

Donate
------
- https://divested.dev/donate
