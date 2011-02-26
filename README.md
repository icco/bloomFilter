# BloomFilter

I was reading [Al3x's post][], and I was all, "hey, that would be fun to implement." So, here I am, attempting to learn rails and implement a basic version of what Al3x was proposing.

First I need to learn rails. It seems pretty straight forward, but I'm going to go through [Rails For Zombies][] first, just for shits and giggles.

Alright, Rails "learned".

There seems to be a pretty heavy debate on notHn whether or not to allow voting. I think a system along the lines of the following might work:

 * User A submits a post
 * User B sees the post and goes "this is hot shit". He nominates it for featuring.
 * If 10% of the user base (determined by users reputation) nominates the post, the post gets featured and User A gets x rep (I'm thinking 10).

Monetization? I'm thinking of using the same pay system that [pinboard.in][] uses. It seems to work, although I might put a ceiling on it...

As for notHn, I'm seriously worried about the "design by commitee" issues that could come about. I'm going to implement this and throw the code at them, and see what they think.

[Rails For Zombies]: http://railsforzombies.org
[Al3x's Post]: http://al3x.net/2011/02/22/solving-the-hacker-news-problem.html
[pinboard.in]: http://pinboard.in/about/

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
   * direction will probably be an enum `{ 0 => flag, 1 => promote }`

