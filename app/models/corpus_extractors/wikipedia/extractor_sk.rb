# encoding: utf-8

module CorpusExtractors
  module Wikipedia
    class ExtractorSk
      DUMP_PATH = 'dumps/wiki_sk/skwiki-20130221-pages-articles-multistream.xml'
      LANG = 'sk'
      MAX_WORD_LENGTH = 30

      def self.clean_word(word)
        word = word.downcase.gsub(/\A[\d_\W]+|[\d_\W]+\Z/, '').gsub(/\A&[a-z0-9]+;|&[a-z0-9]+\Z/, '').gsub(/\A[\d_\W]+|[\d_\W]+\Z/, '')

        return nil if word.match(/http:\/\//) or word.length > MAX_WORD_LENGTH
        word
      end

      def self.parse_page(text, categories)
        text.gsub!(/{{.*}}/, '')

        page_words = {}
        text.split(/[\s:;|]/).each do |w|
          cw = clean_word(w)
          page_words[cw.gsub(/'/, '\'\'')] = true unless cw.blank?
        end

        lemmas = LemmatizationService.new.lemmatize(page_words.keys)
        page_words = Hash[lemmas.collect{ |w| [w, true] }]

        # using direct sql for performance
        if page_words.size > 0
          categories.each do |c|
            ActiveRecord::Base.connection.execute("UPDATE total_documents SET number = number+1 WHERE language = '#{LANG}' AND category_id = '#{c}'")
          end

          page_words.each_key do |word|
            categories.each do |c|
              CorpusSk.transaction do
                res = ActiveRecord::Base.connection.execute("SELECT id FROM corpus_sk WHERE category_id = '#{c}' AND word = '#{word}' LIMIT 1")
                if res.first.blank?
                  ActiveRecord::Base.connection.execute("INSERT INTO corpus_sk (category_id, word, count) VALUES ('#{c}', '#{word}', 1)")
                else
                  ActiveRecord::Base.connection.execute("UPDATE corpus_sk SET count = count+1 WHERE id = #{res.first['id'].to_i}")
                end
              end
            end
          end
        end
      end

      def self.get_categories(id)
        res = ActiveRecord::Base.connection.execute("SELECT DISTINCT(category) FROM topcategories2 WHERE page_id = #{id}")
        res.collect {|r| r['category'].to_i}
      end

      def self.extract
        old_logger = ActiveRecord::Base.logger
        ActiveRecord::Base.logger = nil

        file = File.open(DUMP_PATH)

        page_text = ''
        page_id = -1
        reading_text = false

        while (line = file.gets)
          if line.match(/<\/page/)
            page_id = -1
          elsif line.match(/<id>/)
            if page_id < 0
              page_id = line.match(/<id>([0-9]+)<\/id>/)[1].to_i
            end
          elsif line.match(/<text/)
            unless line.match(/<\/text>/)
              page_text = ''
              reading_text = true
            end

          elsif line.match(/<\/text>/) or line.match(/== *Pozri aj *==/) or line.match(/== *Referencie *==/) or line.match(/== *Ďalšie čítanie *==/) or line.match(/== *Externé odkazy *==/)
            reading_text = false
            cats = get_categories(page_id)
            self.delay.parse_page(page_text, cats) if not page_text.blank? and not cats.blank?

          elsif reading_text
            page_text << ' ' + line
          end
        end

        file.close
      end
    end
  end
end