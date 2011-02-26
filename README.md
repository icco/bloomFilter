# BloomFilter

I was reading [Al3x's post][], and I was all, "hey, that would be fun to implement." So, here I am, attempting to learn rails and implement a basic version of what Al3x was proposing.

First I need to learn rails. It seems pretty straight forward, but I'm going to go through [Rails For Zombies][] first, just for shits and giggles.

[Rails For Zombies]: http://railsforzombies.org
[Al3x's Post]: http://al3x.net/2011/02/22/solving-the-hacker-news-problem.html


## Features / Brainstorming

 * moderators
 * invite only?
   * benefit - helps limit users.
   * hash of invitee and invitor
 * submit links
 * show cliks and votes
 * show domain
 * show rules if you haven't posted in a month
    * make rules short
 * comment on links
 * vote on links
 * promote highly technical content

## Data

 * Items
   * a url, text, parent, a userid, and a date
   * if url, parent must be 0.
   * if url text must be null
   * if text, url must be null
 * Users
   * name, userid, date joined, email, hashed pw
 * votes
   * direction, item id, userid, date
