# Get simple statistics from downloaded tumblr data

These tools will generate basic statistics about how much each blog had been reblogged, and how ofthen they appear in the trail of a blog post

Usage:

* `generate_stats.rb` will extract some statistic as JSON from the data dump. It will use CLD to determine the language of the blog posts.
* `filter_stats.rb` will filter out the statistics so it only contains blog that are at least somewhat active and in the proper language
* `extract_from_stats.rb` will take the filtered statistics and present it ordered as four distinct lists