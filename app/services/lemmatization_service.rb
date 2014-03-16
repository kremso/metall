class LemmatizationService
	FIIT_LEMMATIZATOR_SERVICE_URL = 'http://text.fiit.stuba.sk:8080/lematizer/services/lemmatizer/lemmatize/fast'

	def initialize
	end

	def lemmatize(words)
		response = Faraday.post { |req| 
			req.url FIIT_LEMMATIZATOR_SERVICE_URL
			req.headers['Content-Type'] = 'text/plain'
			req.body = words.join(' ')
		}
		if response.success?
			response.body.split.map { |word|
				word.force_encoding('utf-8')
			}
    else
			raise 'Lemmatization service error.'
		end
	end
end