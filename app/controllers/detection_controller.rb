class DetectionController < ServiceController
  before_filter :prepare_content, only: :service
  before_filter :prepare_language, only: :service
  before_filter :prepare_tokens, only: :service

  respond_to :json
  respond_to :xml

  def service
    detection = DetectionService.new(@tokens)

    category_scores = detection.category_scores(@language).sort_by { |score_category|
      score_category[:score]
    }.map { |score_category|
      [score_category[:category].name, score_category[:score]]
    }.reverse

  	response = {
  		success: true,
      language: @language, 
      category_scores: category_scores
  	}
  	respond_with(response, location: nil)
  end
end
