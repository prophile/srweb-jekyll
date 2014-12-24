require 'geocoder'
require 'facets/string/titlecase'

module EventsSubsystem
    class GetEventType < Liquid::Tag
        def render(context)
            type = context['page']['relative_path'].split('/')[-2]
            type.gsub(/_/, ' ').titlecase
        end
    end

    def self.format_date(year, month, day)
        year  = year.to_i
        month = month.to_i
        day   = day.to_i

        months = %w[?? January February March
                    April May June
                    July August September
                    October November December]
        suffix = %w[th st nd rd th th th th th th
                    th th th th th th th th th th
                    th st nd rd th th th th th th
                    th st]
        "#{day}<sup>#{suffix[day]}</sup> #{months[month]}, #{year}"
    end

    def self.format_date_ics(year, month, day)
        "#{year}#{month}#{day}"
    end

    def self.format_date_iso(year, month, day)
        '%02i-%02i-%02i' % [year, month, day]
    end

    class GetDate < Liquid::Tag
        MATCHER = /^.*\/(\d+)-(\d+)-(\d+)-(.*)\..*$/

        def initialize(tag_name, text, options)
            super

            tokens = text.split(' ')
            event_name = tokens[0]

            format = tokens[1]
            @event_name = if event_name.nil? || event_name.empty? then nil else event_name end
            @format = if format.nil? || format.empty? then nil else format end
        end

        def render(context)
            page = if @event_name then context[@event_name] else context['page'] end
            m, year, month, day, slug = *page['relative_path'].match(MATCHER)
            case @format
            when "ics"
              EventsSubsystem::format_date_ics(year, month, day)
            when "iso"
              EventsSubsystem::format_date_iso(year, month, day)
            when "human"
            else
              EventsSubsystem::format_date(year, month, day)
            end
        end
    end

    class HomeEvents < Liquid::Tag
        MATCHER = /^(\/.+)*\/(\d+)-(\d+)-(\d+)-(.*)$/
        SYNTAX = /(.*)[[:blank:]]*,[[:blank:]]*(.*)[[:blank:]]*,[[:blank:]]*(.*)[[:blank:]]*,[[:blank:]]*(.*)/

        def initialize(tag_name, markup, options)
            super
            m, @type, @branch, @default, @incl_locations = *markup.match(SYNTAX)
        end

        def render(context)
            sr_year = context['site.sr.year']

            branches = context['site.sr.branches']
            content = []

            branch = if @branch == 'all' then 'all' else context[@branch] end

            content << '<ul>'
            matched_any = false
            context['site.events'].each do |event|
                m, cats, year, month, day, slug = *event.cleaned_relative_path.match(MATCHER)
                cats = cats.split('/').drop(1)
                # filter by year
                next unless cats.include? "sr#{sr_year}"
                # filter by branch
                next unless event.data['branch'] == branch || branch == 'all'
                # filter by type
                next unless cats.include? @type
                pretty_date = EventsSubsystem::format_date(year, month, day)
                if @incl_locations.rstrip == "true" then
                    loc = event.data['geo']
                    search_data = GeoLookup::lookup(loc)
                    name = nil
                    search_data['address_components'].each do |component|
                        name = component['short_name'] if component['types'].include?('establishment')
                    end
                    name = search_data['formatted_address'] if name.nil?
                    extra_goo = ", #{name}"
                end
                formatted_event = "<li><a href=\"#{event.url}\">#{pretty_date}</a>#{extra_goo}</li>"
                content << formatted_event
                matched_any = true
            end

            content << "<li>#{@default}</li>" unless matched_any
            content << "</ul>"

            content.join "\n"
        end

        private
        def make_list(elems)
            return "TBA" if elems.empty?
            "<ul>" + (elems.map {|x| "<li>#{x}</li>"}).join + "</ul>"
        end
    end
end

Liquid::Template.register_tag('events_list',
                              EventsSubsystem::HomeEvents)
Liquid::Template.register_tag('event_date',
                              EventsSubsystem::GetDate)
Liquid::Template.register_tag('event_type',
                              EventsSubsystem::GetEventType)
