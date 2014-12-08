module GeoSubsystem
    SYNTAX = /([[:graph:]]*)[[:blank:]]*,[[:blank:]]*([[:graph:]]*)/

    class ReverseGeocode < Liquid::Tag
        def initialize(tag_name, text, options)
            super
            m, @query, @component = *text.match(SYNTAX)
        end

        def render(context)
            raw_data = GeoLookup::lookup(context[@query])
            case @component
            when "address"
              raw_data['formatted_address']
            when "html_address"
              raw_data['formatted_address'].split(',').uniq.join('<br>')
            when "geo"
              coords = raw_data['geometry']['location']
              "#{coords['lat']},#{coords['lng']}"
            else
              "unknown location"
            end
        end
    end
end

Liquid::Template.register_tag('reverse_geocode',
                              GeoSubsystem::ReverseGeocode)
