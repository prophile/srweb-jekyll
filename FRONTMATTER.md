Custom front matter
===================

We have a number of custom front matter attributes, described below:

General
-------

- `angular_controller`: the name of an AngularJS controller to use for the page, defined in the named file in `/js/controllers/`. (For example, the `FooBar` controller should be defined in `/js/controllers/FooBar.js`.)

- `description`: a value for the `description` meta tag included in the HTML meta data.

- `extra_css`: a list of extra stylesheets to include.

- `itemtype`: adds an `itemtype` attribute (and `itemscope`) to the page body, allowing a [microdata](http://www.w3.org/TR/microdata/) vocabulary URL to be specified for the page.

Events
------

On pages in the `_events` directory, the following can be used:

- `title` is the title of the event.
- `layout` should be set to `event`.
- `branch` is the human-readable name of the branch, i.e. Southampton, Bristol, London, etc.
- `location` is a location that can be reverse geocoded.
- `dates` is a list of days where each day is a list of three elements being the date, the start time and the end time. For example, for the 2015 competition:

	```yaml
	dates:
		- ['2015-04-25', '9:00', '17:30']
		- ['2015-04-26', '9:00', '18:00']
	```

- `override` can be used to override some of the event details, such as `where`.
- `hidemap`, when set, hides the Google Map.

Redirects
---------

Attributes for the URL redirect plugin, which (if possible) creates an Apache `.htaccess` file, or falls back to creating redirection HTML pages.

- `redirect_from`: a list of URLs on the site which should redirect to this page.
- `redirect_to`: a URL to which visitors to this page should be redirected.
