DUMP_PATH = 'dumps/enwiki-20121201-pages-articles-multistream.xml'
LANG = 'en'
MAX_WORD_LENGTH = 30

module CorpusExtractors
  class WikiExtractor
    def self.clean_word(word)
      word = word.downcase.gsub(/\A[\d_\W]+|[\d_\W]+\Z/, '').gsub(/\A&[a-z0-9]+;|&[a-z0-9]+\Z/, '').gsub(/\A[\d_\W]+|[\d_\W]+\Z/, '')

      return nil if word.match(/http:\/\//) or word.length > MAX_WORD_LENGTH

      word.stem
    end

    def self.parse_page(text)
      text.gsub!(/{{.*}}/, '')

      page_words = {}
      text.split(/[\s:;|]/).each do |w|
        cw = clean_word(w)
        page_words[cw.gsub(/'/, '\'\'')] = true unless cw.blank?
      end

      # using direct sql for performance
      if page_words.size > 0
        ActiveRecord::Base.connection.execute("UPDATE total_documents SET number = number+1 WHERE language = '#{LANG}'")

        page_words.each_key do |word|
          res = ActiveRecord::Base.connection.execute("SELECT id FROM corpus WHERE language = '#{LANG}' AND word = '#{word}' LIMIT 1")
          if res.first.blank?
            ActiveRecord::Base.connection.execute("INSERT INTO corpus (language, word, count) VALUES ('#{LANG}', '#{word}', 1)")
          else
            ActiveRecord::Base.connection.execute("UPDATE corpus SET count = count+1 WHERE id = #{res.first['id'].to_i}")
          end
        end
      end
    end

    def self.extract
      old_logger = ActiveRecord::Base.logger
      ActiveRecord::Base.logger = nil

      file = File.open(DUMP_PATH)

      page_text = ''
      reading_page = false

      while (line = file.gets)
        if line.match(/<text/)
          unless line.match(/<\/text>/)
            self.delay.parse_page(page_text) unless page_text.blank?

            page_text = ''
            reading_page = true
          end

        elsif line.match(/<\/text>/) or line.match(/== *See also *==/) or line.match(/== *References *==/) or line.match(/== *Further reading *==/) or line.match(/== *External links *==/)
          reading_page = false

        elsif reading_page
          page_text << ' ' + line
        end
      end
      self.delay.parse_page(page_text) unless page_text.blank?

      file.close
    end
  end
end