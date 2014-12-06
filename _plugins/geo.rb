require 'geocoder'

module GeoSubsystem
    class ReverseGeocode < Liquid::Tag
        def initialize(tag_name, text, options)
            super
            @query = text
        end

        def render(context)
            Geocoder.search(context[@query])[0].data['formatted_address']
        end
    end
end

Liquid::Template.register_tag('reverse_geocode',
                              GeoSubsystem::ReverseGeocode)
