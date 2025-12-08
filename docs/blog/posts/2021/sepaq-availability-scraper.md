---
categories:
  - Projects
date:
  created: 2021-05-12
  updated: 2021-05-12
migrated: true
slug: sepaq-availability-scraper
tags:
  - open source
  - projects
  - python
  - scraping
---

# SEPAQ Availability Scraper

Recently, we were trying to find an available camp site on [SEPAQ](https://www.sepaq.com) during the summer.
We were late to the party, though, and most (interesting) sites were already booked or had single days left here and there.

Finding the remaining sites at flexible dates is actually quite cumbersome since you need to go to each camp site (and click through a calendar week by week there) or go to a single spot of a camp site to see its availability calendar.
This is especially cumbersome if you are flexible in terms of the dates and the park.

Long story short, I looked at how to get the availability of the camp sites and hacked together a scraper.
It recursively finds all camping spots and downloads the availability for each of them.
Once they are downloaded it can parse them and filter for available spots (with minimum days and a desired date range).

You can find the code here: https://github.com/mschoettle/sepaq-availability-scraper

There's definitely some things that could be improved but it got the job done.

<!-- more -->

## Details

Here is what I found out about how the reservation system works.
The reservation system makes heavy use of session cookies.
A request to the same URL is different depending on the current state of the session.
This means that you need to make a request (e.g., a search) to set/update your cookie.
So for example, if you want to find _Prêt-à-camper_, you need to start with a call to `https://www.sepaq.com/en/reservation/camping/init?type=Pr%C3%AAt%20%C3%A0%20camper`.

I found an API endpoint to get the availability of a specific camp site: `https://www.sepaq.com/en/reservation/availabilities`.
It returns a JSON with a list of dictionaries.
Each item represents one day and contains all the required information (date, availability, price etc.).
I also noticed additional calls with query parameters (`?year=2021&month=5`), however, the full 3 years were still returned.
