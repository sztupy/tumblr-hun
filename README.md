# Hungarian Tumblr

This repository contains various statistics about the Hungarian Tumblr community as of September 2018.

## `blog-list.txt`

This file contains the list of active Hungarian blogs that were active on 23 September 2018.

The current list of top Hungarian blogs have been obtained the following way:

* The top 1000 blogs from the [tumblr-node-map](https://github.com/madbence/node-tumblr-map) run from August 2016 have been fully downloaded if they still exist.
* Based on the first downloaded set the 250 most-reblogged-from blogs (see `Is reblogged from` below), that were not yet downloaded have been added as well.
* Based on the first and second downloaded set the 400 blogs that had the most reblogged content (see `Hungarian content appears in trai` below, excluding blogs that have already been downloaded or don't exist anymore) had been added as well.

To determine which blogs are Hungarian [Compact Language Detector](https://github.com/google/cld3) was used. Only blogs that contain at least one reblog that was determined by CLD to be Hungarian is considered as a Hungarian blog, all others (including commonly reblogged blogs from the community like `ruinedchildhood`) are discarded.

From the result blogs that have been taken over by spam bots have been removed giving an end result of 1251 blogs.

## `blog-toplist.md`

Top 1000 blogs based on the blogs in the `blog-list.txt` based on the following criteria:

- `Hungarian content appears in trail`: how many times a Hungarian text content from the blogger appeared in someone else's blog as trail
- `Hungarian content appears as the root content`: how many times Hungarian text content posted by the blogger was reblogged by others
- `Is reblogged from`: how many times any content was reblogged from this user directly
- `The root content that is reblogged`: how many times any content posted by this user was reblogged by others


## `download`

Tool to mass-download blogs through the API based on usernames.

## `get_stats`

Tools to get some crude statistics from the downloaded JSON files