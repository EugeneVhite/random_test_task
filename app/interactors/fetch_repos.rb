require 'dry/monads/do'

class FetchRepos
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  def call(query_term)
    repos = yield GithubClient.new.search_repo(query_term)

    return Failure('Nothing found!') if repos.empty?

    Success(repos)
  end
end
