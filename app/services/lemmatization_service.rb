class LemmatizationService
	FIIT_LEMMATIZATOR_SERVICE_URL = 'http://vm23.ucebne.fiit.stuba.sk:9000/lematizer/services/lematizer/lematize/fast'

	def initialize
	end

	def lemmatize(words)
		response = Faraday.post { |req| 
			req.url FIIT_LEMMATIZATOR_SERVICE_URL
			req.headers['Content-Type'] = 'text/plain'
			req.body = words.join(' ')
		}
		if response.success?
			response.body.split
		else
			raise 'Lemmatization service error.'
		end
	end
end