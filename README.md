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


[srobo]: https://www.studentrobotics.org/
[jekyll]: http://jekyllrb.com/
[markdown]: http://daringfireball.net/projects/markdown/syntax
[gerrit-patch]: https://www.studentrobotics.org/trac/wiki/Gerrit
[build-badge]: https://circleci.com/gh/prophile/srweb-jekyll.png
[build-page]: https://circleci.com/gh/prophile/srweb-jekyll
