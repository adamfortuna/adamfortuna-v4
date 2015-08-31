---
title: "Fulltext and Distance in MySQL"
permalink: fulltext-distance-in-mysql
tags: Technical, SQL
---

Ok, so not completely — but one fix broke another on [ArcadeFly] You can no longer filter for multiple games at a location — instead you'll get locations with *any* of the selected games instead of all of those selected. But in taking that out for the time-being there's now a way to filter by the number of games at an arcade and, most importantly, zip code filtering (up to 500 miles from a zip code)! Zip code filtering is so much fun and easy to code (well, assuming you don't need pinpoint accuracy). Just grab a [MySQL table of zip codes] and add in a little ugly formula (for me it's something like

```sql
SELECT (
    3958.75 *
    acos(sin(lat/57.2958) *
    sin(#{local.zip.lat}/57.2958)
  ) + (
    cos(lat/57.2958) *
    cos(#{local.zip.lat}/57.2958) *
    cos(#{local.zip.lng}/57.2958)
  ) - lng/57.2958 AS distance
FROM arcade
HAVING distance < #{criteria.range}
```

(where local.zip.lat/lng are the lat/lng of the zip code being searched for), and watch it go! I decided to update the arcades table to include the lat/lng too, rather than join the zip code on the zip table, which sped things up tremendously. To my dismay, however, Godaddy doesn't seem to like the idea of caching queries (cachedwithin). Nothing surprising there for a shared host. The "quick filter" box uses some simple MySQL feature I've never had the need to mess with — MATCH AGAINST. The idea is that that box will search the arcade name, address, city, state, zip and country fields the text entered. Instead of doing this with something with 5 AND statements (name like ‘search' and address like ‘search'), MySQL has a cool feature where you can just say…

```sql
MATCH (name, address, city, state, zip)
AGAINST ('search')
```

You can also change it to…

```sql
MATCH (name, address, city, state, zip)
AGAINST ('search' IN BOOLEAN MODE)
```

If you want to use search strings like "Virginia -West". Very nifty and extremely fast feature. Getting back in the habit of coding without subselects for this project. It's been a welcomed change too, because they really allow lazy programming. For instance, for getting the count of games at an arcade, I think it's faster to INNER JOIN on the arcade to games mapping table, and group by name, selecting count(mapping\_table.id) as the count of records that exist in the 2nd table. Not difficult stuff, but really optimizes the database calls, for which there are a lot of in this little app. Next on the list will be cleaning up the rest of the app. Tidied up the filtering section today, probably be able to do the rest tomorrow.

  [ArcadeFly]: http://www.arcadefly.com
  [MySQL table of zip codes]: http://www.darkshire.org/~jhkim/public_html/programming/zipcodes/
