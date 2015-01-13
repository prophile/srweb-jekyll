module TeamStatusSubsystem
    class PageWithoutAFile < Jekyll::Page
        def read_yaml(*)
            @data ||= {}
        end
    end

    class TeamStatus < Jekyll::Generator
        def generate(site)
            @site = site

            @site.data['teams'].each do |tla, team|
                generate_team_status tla, team
            end
        end

        def generate_team_status(tla, team)
            # generate the page contents
            status_page = PageWithoutAFile.new(@site, File.dirname(__FILE__), "", "team.php")
            status_page.content = File.read(source_path)
            status_page.data['layout'] = 'site'
            status_page.data['team'] = tla
            status_page.data['title'] = team['name']
            status_page.render(@site.layouts, @site.site_payload)
            content = status_page.output.gsub(/[\s\n]*\n+/, "\n")
            # write the contents into the target
            base_path = "teams/#{tla}/index.php"
            destination_path = @site.in_dest_dir(base_path)
            FileUtils.mkdir_p File.dirname(destination_path)
            File.open(destination_path, 'w') { |f| f.write(content) }
            # make sure Jekyll doesn't clobber it
            @site.keep_files ||= []
            @site.keep_files << base_path
        end

        def source_path
            File.expand_path "team.php", File.dirname(__FILE__)
        end
    end
end

