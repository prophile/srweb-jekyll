require 'open-uri'

module DownloadPlugin

    # A Jekyll converter which takes files with names that end with '.download'
    # and which contain a single URL, and downloads them and puts them in the
    # site.
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
