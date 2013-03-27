# encoding: UTF-8

module CorpusExtractors
  module Wikipedia
    class CategoryCrawler
      MAX_DEPTH = 10
      MAX_PAGE_ID = 474110
      MAX_ARTICLES = 500000

      def self.get_base_categories(lang)
        if lang == 'en'
          [
              {id: 1, name: 'Agriculture', page_id: 694871},
              {id: 2, name: 'Arts', page_id: 4892515},
              {id: 3, name: 'Belief', page_id: 956054},
              {id: 4, name: 'Business', page_id: 771152},
              {id: 5, name: 'Chronology', page_id: 1013214},
              {id: 6, name: 'Culture', page_id: 694861},
              {id: 7, name: 'Education', page_id: 696763},
              {id: 8, name: 'Environment', page_id: 3103170},
              {id: 9, name: 'Geography', page_id: 693800},
              {id:10, name: 'Health', page_id: 751381},
              {id:11, name: 'History', page_id: 693555},
              {id:12, name: 'Humanities', page_id: 1004110},
              {id:13, name: 'Language', page_id: 8017451},
              {id:14, name: 'Law', page_id: 691928},
              {id:15, name: 'Life', page_id: 2389032},
              {id:16, name: 'Mathematics', page_id: 690747},
              {id:17, name: 'Medicine', page_id: 692348},
              {id:18, name: 'Nature', page_id: 696603},
              {id:19, name: 'People', page_id: 691008},
              {id:20, name: 'Politics', page_id: 695027},
              {id:21, name: 'Science', page_id: 691182},
              {id:22, name: 'Society', page_id: 1633936},
              {id:23, name: 'Sports', page_id: 693708},
              {id:24, name: 'Technology', page_id: 696648}
          ]
        elsif lang == 'sk'
          [
              {id: 25, name: 'Príroda', page_id: 5586},
              {id: 26, name: 'Veda', page_id: 4931},
              {id: 27, name: 'Človek', page_id: 7162}
          ]
        end
      end

      def self.mysql_connect
        @con = ActiveRecord::Base.establish_connection(
            "adapter" => "mysql2",
            "database" => "wikipedia_sk",
            "user" => "root",
            "password" => "password",
            "host" => "127.0.0.1",
            "port" => 3306,
            "socket" => "mysql"
        )
      end

      def self.crawl_category(top_cat, page_name, page_id, depth)
        unless @visited[page_id] or depth > MAX_DEPTH or @added > MAX_ARTICLES

          sql = "
            SELECT p.page_namespace, p.page_title, p.page_id FROM categorylinks AS cl
            INNER JOIN page AS p ON cl.cl_from = p.page_id
            WHERE cl.cl_to = '#{page_name.gsub(/'/, '\'\'')}' AND (p.page_namespace = 0 or p.page_namespace = 14)
          "

          @con.connection.execute(sql).each do |page|
            if page[0] == 0 # article
              @con.connection.execute("INSERT INTO topcategories2 (page_id, category) VALUES (#{page[2]}, #{top_cat})")
              @added += 1
            else # category
              crawl_category(top_cat, page[1], page[2], depth+1)
            end
          end

          @visited[page_id] = true
        end
      end

      def self.crawl_all(lang)
        old_logger = ActiveRecord::Base.logger
        ActiveRecord::Base.logger = nil

        mysql_connect

        get_base_categories(lang).each do |cat|
          puts "starting category #{cat[:name]}, #{Time.now}"

          @added = 0
          @visited = Array.new(MAX_PAGE_ID, false)
          crawl_category(cat[:id], cat[:name], cat[:page_id], 0)

          puts "ending category #{cat[:name]}, #{Time.now}"
        end
      end

    end
  end
end