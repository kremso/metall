module CorpusExtractors
  module Sav
    class Extractor
      DUMP_PATH = 'dumps/sav_corpae/prim-6.0_2grams.txt'
      TABLE_NAME = 'corpus_2gram_sk'

      def self.proper_word(word)
        not (word.size == 1 and (/\W/ =~ word) == 0)
      end

      def self.extract
        old_logger = ActiveRecord::Base.logger
        ActiveRecord::Base.logger = nil

        file = File.open(DUMP_PATH)

        while (line = file.gets)
          toks = line.split
          if proper_word(toks[1]) and proper_word(toks[2])
            ActiveRecord::Base.connection.execute("INSERT INTO #{TABLE_NAME} (words, count) VALUES ('#{toks[1]} #{toks[2]}', #{toks[0].to_i})")
          end
        end

        file.close
      end
    end
  end
end