class CatchWrongFormat

  def initialize(app)
    @app = app
  end

  def call(env)
    if env['REQUEST_METHOD'] =~ /POST/
      if env['CONTENT_TYPE'] =~ /application\/json/ || env['CONTENT_TYPE'] =~ /application\/xml/
        @app.call(env)
      else
        return [
          415, { "Content-Type" => "application/json" },
          [ { success: false, error: 'You must specify Content-Type in a POST request: application/json or application/xml.' }.to_json ]
        ]
      end
    else
      @app.call(env)
    end
  end

end
