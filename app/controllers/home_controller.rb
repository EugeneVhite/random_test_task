class HomeController < ApplicationController
  def index
    return unless params[:q].present?

    @query = params[:q]
    result = ::FetchRepos.new.call(@query) if @query.present?

    case result
    in Dry::Monads::Success(repos)
      @repo_names = repos.map { |repo| repo['name'] }
    in Dry::Monads::Failure(failure)
      @error = failure
    end
  end
end
