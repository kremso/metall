class DocumentKeyword < ActiveRecord::Base
  attr_accessible :batch_keyword_request_id, :options, :result, :error, :done

  belongs_to :batch_keyword_request

  after_save :notify_if_request_finished

  serialize :options
  serialize :result
  serialize :error

  def extract!
    begin
      self.result = DocumentKeywordExtractor.new(options).extract
    rescue => e
      self.error = {
        success: false,
        url: options[:url],
      }
    end

    self.done = true
    save
  end

  private

    def notify_if_request_finished
      batch_keyword_request.notify_callback_url if batch_keyword_request.done?
    end

end
