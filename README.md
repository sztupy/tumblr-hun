# Hungarian Tumblr

This repository contains various statistics about the Hungarian Tumblr community as of September 2018.

## `blog-list.txt`

This file contains the list of active Hungarian blogs that were active on 23 September 2018.

The current list of top Hungarian blogs have been obtained the following way:

* The top 1000 blogs from the [tumblr-node-map](https://github.com/madbence/node-tumblr-map) run from August 2016 have been fully downloaded if they still exist.
* Based on the first downloaded set the 250 most-reblogged-from blogs, that were not yet downloaded have been added as well.
* Based on the first and second downloaded set the 400 blogs that had the most reblogged content (and not yet downloaded already) had been added as well.

To determine which blogs are Hungarian [Compact Language Detector](https://github.com/google/cld3) was used. Only blogs that contain at least one reblog that was determined by CLD to be Hungarian is considered as a Hungarian blog, all others (including commonly reblogged blogs from the community like `ruinedchildhood`) are discarded.

From the result blogs that have been taken over by spam bots have been removed giving an end result of 1251 blogs.

## `download`

Tool to mass-download blogs through the API based on usernames.