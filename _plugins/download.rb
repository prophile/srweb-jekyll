require 'open-uri'

module DownloadPlugin
    class DownloadConverter < Jekyll::Converter
        def matches(ext)
            ext =~ /^\.download$/i
        end

        def output_ext(ext)
            ''
        end

        def convert(content)
            uri = URI(content.strip)
            open(uri).read
        end
    end
end

