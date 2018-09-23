var Tumblr = require('tumblr.js');
var eachLimit = require('async/eachLimit');
var fs = require('fs');
var util = require('util');

var log_file = fs.createWriteStream(__dirname + '/debug.log', {flags : 'w'});

function logging() {
  data = util.format.apply({},arguments);
  console.log(data);
  log_file.write(data + '\n');
}

function findRateLimitHeader(headers, name) {
  return Object.keys(headers).filter(header => header.match('ratelimit') && header.match(name)).map(header => headers[header])[0];
}

var fs = require('fs');
var usernames = fs.readFileSync('blogs.dat').toString().split("\n");

var client = Tumblr.createClient({
  consumer_key: '',
  consumer_secret: '',
  token: '',
  token_secret: ''
});

var searchForPosts = (username, options, finishCallback, retries = 0) => {
  client.blogPosts(username, options, function(err, body, resp) {
    if (err) {
      if (!resp) {
        logging("Connection error, waiting 1 minute!");
        setTimeout(() => searchForPosts(username, options, finishCallback), 60000);
      } else if (resp.statusCode == 429) {
        logging(resp.headers);
        // just rate limiting, wait and retry
        const limit = findRateLimitHeader(resp.headers, '-limit');
        const remaining = findRateLimitHeader(resp.headers, '-remaining');
        const reset = findRateLimitHeader(resp.headers, '-reset');

        var timeout = 1000;
        if (remaining == 0) {
          timeout = reset;
        }
        logging("API limit exceeded, waiting " + timeout + "ms");
        setTimeout(() => searchForPosts(username, options, finishCallback), timeout);
      } else {
        if (retries < 4) {
          logging("Connection error, waiting 10 sec! Try #" + retries);
          setTimeout(() => searchForPosts(username, options, finishCallback, retries + 1), 10000);
        } else {
          // some other issue, return error to display handler
          logging("ERROR %s %j %j", username, err, resp);
          finishCallback();
        }
      }
    } else {
      // happy path
      if (options.offset===0) {
        logging("BLOG %s", username);
      }

      logging("PRG %s %s", username, ((options.offset / body.blog.total_posts)*100).toFixed(3) + "%");
      var json = JSON.stringify(body);
      fs.writeFile('dump/'+username+'/dump-'+options.offset+'.json', json, 'utf8', function() {});

      if (body.posts.length >= options.limit) {
        var newOptions = Object.assign({}, options);
        newOptions.offset += newOptions.limit;
        searchForPosts(username, newOptions,finishCallback);
      } else {
        logging("DONE %s", username);
        finishCallback();
      }
    }
  });
};

if (!fs.existsSync("dump")){
  fs.mkdirSync("dump");
}

eachLimit(usernames, 10, function(u,cb) {
  if (!fs.existsSync("dump/"+u)){
    fs.mkdirSync("dump/"+u);
  }
  logging("START %s", u);
  var options = {
    limit: 50,
    offset: 0,
    reblog_info: true
  }
  searchForPosts(u,options,cb);
}, function(err) {
  logging(err);
  logging("Fully finished!");
});
