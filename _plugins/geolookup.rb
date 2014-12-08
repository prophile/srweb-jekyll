require 'geocoder'
require 'digest/sha1'
require 'json'

module GeoLookup
    CACHE_DIR = "/tmp/jekyll-geo-cache"

    def self.lookup(query)
        Dir.mkdir(CACHE_DIR) if not Dir.exists?(CACHE_DIR)
        hash = Digest::SHA1.hexdigest query.inspect
        cache_file = "#{CACHE_DIR}/#{hash}"
        return JSON.parse(File.read(cache_file)) if File.exists?(cache_file)
        puts "Querying for geo information on #{query.inspect}"
        Geocoder::configure(
            :timeout => 15,
            :lookup  => :google
        )
        response = Geocoder::search(query)
        results = response[0].data
        File.write cache_file, JSON.generate(results)
        results
    end
end

