class BatchKeywordRequest < ActiveRecord::Base
  attr_accessible :uid, :callback_url

  has_many :document_keywords

  before_create :generate_uid

  def num_documents_requested
    document_keywords.count
  end

  def num_documents_done
    document_keywords.where(done: true).count
  end

  def done?
    num_documents_requested == num_documents_done
  end

  def notify_callback_url
    if callback_url.present?
      begin
        Faraday.get(callback_url)
      rescue
      end
    end
  end

  def results
    document_keywords.where(done: true).map do |dk|
      if dk.result.present?
        dk.result
      else
        dk.error
      end
    end
  end

  private

    def generate_uid
      self.uid = loop do
        random_uid = SecureRandom.hex(4)
        break random_uid unless self.class.exists?(uid: random_uid)
      end
    end

end
