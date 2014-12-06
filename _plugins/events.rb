module EventsSubsystem
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
            if @format == 'ics' then
                EventsSubsystem::format_date_ics(year, month, day)
            else
                EventsSubsystem::format_date(year, month, day)
            end
        end
    end

    class HomeEvents < Liquid::Tag
        MATCHER = /^(\/.+)*\/(\d+)-(\d+)-(\d+)-(.*)$/
        def initialize(tag_name, markup, options)
            super
        end

        def render(context)
            sr_year = context['site']['sr']['year']

            branches = Set.new

            context['site']['events'].each do |event|
                branches << event.data['branch'] if event.data['branch']
            end

            content = []

            events = lambda do |dfl, &predicate|
                matched_any = false
                content << '<ul>'
                context['site']['events'].each do |event|
                    m, cats, year, month, day, slug = *event.cleaned_relative_path.match(MATCHER)
                    cats = cats.split('/').drop(1)
                    # filter by year
                    next unless cats.include? "sr#{sr_year}"
                    # filter by passed condition
                    next unless predicate.call(cats, event.data['branch'])
                    pretty_date = EventsSubsystem::format_date(year, month, day)
                    formatted_event = "<li><a href=\"#{event.url}\">#{pretty_date}</a></li>"
                    content << formatted_event
                    matched_any = true
                end
                content << "<li>#{dfl}</li>" unless matched_any
                content << '</ul>'
            end

            branches = branches.to_a
            branches.sort_by! { |branch| -branch.length }

            # Open the div
            content << '<div id="date_tabs">'
            content << '<ul>'
            branches.each do |branch|
                content << "<li><a href=\"#date_#{branch}\">#{branch}</a></li>"
            end
            content << '</ul>'
            branches.each do |branch|
                content << "<div id=\"date_#{branch}\">"
                content << '<a href="/events/kickstart">Kickstart:</a>'
                events.call("Not hosted here") { |cats, event_branch|
                    event_branch == branch && cats.include?('kickstart')
                }
                content << '<a href="/events/tech_days">Tech Days:</a>'
                events.call("TBA") { |cats, event_branch|
                    event_branch == branch && cats.include?('tech_day')
                }
                content << "</div>"
            end
            content << '</div>'
            content << '<div>'
            content << '<a href="/events/competition">Competition:</a>'
            events.call("April #{sr_year}") { |cats, event_branch|
                cats.include?('competition')
            }
            content << '</div>'
            content.join "\n"
        end

        private
        def make_list(elems)
            return "TBA" if elems.empty?
            "<ul>" + (elems.map {|x| "<li>#{x}</li>"}).join + "</ul>"
        end
    end
end

Liquid::Template.register_tag('home_events',
                              EventsSubsystem::HomeEvents)
Liquid::Template.register_tag('event_date',
                              EventsSubsystem::GetDate)
