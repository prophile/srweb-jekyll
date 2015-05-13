srweb
=====

srweb is the website of [Student Robotics][srobo]. It is written in [Jekyll][jekyll], and uses [Markdown][markdown] syntax.

[![Build status][build-badge]][build-page]

Setting up
----------

To set up srweb:

1. Clone the repo.
2. Run `bundler` to install the dependencies, including Jekyll itself.

Making Changes
--------------

To make changes:

1. Modify the Markdown file for the page you want to change,
2. Run `jekyll serve`,
3. Go to the URL that `jekyll serve` reports,
4. If you are happy with how it renders, submit a [Gerrit patch][gerrit-patch].

Events
------

The events system is a thin layer on top of Jekyll collections.

Each event has some YAML frontmatter which is used to generate the events page.

- `title` is the title of the event.
- `description` is included in the HTML meta data.
- `layout` should be set to `event`.
- `branch` is the human-readable name of the branch, i.e. Southampton, Bristol, London, etc.
- `location` is a location that can be reverse geocoded.
- `dates` is a list of days where each day is a list of three elements being the date, the start time and the end time.
- `override` can be used to override some of the event details, such as `where`.

The events page will automatically insert the `what`, `when` and `where` fields, any other fields should be in the body of the event. Stylistically, the field names should be bold.

[srobo]: https://www.studentrobotics.org/
[jekyll]: http://jekyllrb.com/
[markdown]: http://daringfireball.net/projects/markdown/syntax
[gerrit-patch]: https://www.studentrobotics.org/trac/wiki/Gerrit
[build-badge]: https://circleci.com/gh/prophile/srweb-jekyll.png
[build-page]: https://circleci.com/gh/prophile/srweb-jekyll
