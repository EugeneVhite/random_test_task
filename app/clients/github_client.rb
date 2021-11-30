class GithubClient
  include Dry::Monads[:result]

  def search_repo(term)
    response =
      connection.get('/search/repositories') do |req|
        req.params[:q] = term
      end

    return Success(response.body['items']) if response.success?
    return Failure(format_error(response.body['errors'])) if response.status == 422
    return Failure('You are not allowed to see this!') if response.status == 403

    Failure('Uknown failure... Try again later.')
  rescue Faraday::TimeoutError
    Failure('Timeout error')
  end

  private

  def format_error(errors)
    ['GitHub thinks your query is broken.',
    *errors.map { |error| error['message'] }].join(' ')
  end

  def connection
    @connection ||= Faraday.new(url: 'https://api.github.com') do |f|
      f.response :json
    end
  end
end
