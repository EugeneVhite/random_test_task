class HomeController < ApplicationController
  def index
    return unless params[:q].present?

    @query = params[:q]
    result = ::FetchRepos.new.call(@query) if @query.present?

    case result
    in Dry::Monads::Success
      @repo_names = result.value!.map { |repo| repo['name'] }
    in Dry::Monads::Failure
      @error = result.failure
    end
  end
end
