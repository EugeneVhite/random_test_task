require 'rails_helper'

RSpec.describe FetchRepos do
  let(:instance) { FetchRepos.new }
  describe '#call' do
    it 'is successful' do
      allow_any_instance_of(GithubClient).to receive(:search_repo).and_return(Dry::Monads::Success(['something']))

      expect(instance.call('term')).to be_success
    end

    it 'fails if client fails' do
      allow_any_instance_of(GithubClient).to receive(:search_repo).and_return(Dry::Monads::Failure('something'))

      expect(instance.call('term')).to_not be_success
    end

    it 'fails if none was found' do
      allow_any_instance_of(GithubClient).to receive(:search_repo).and_return(Dry::Monads::Success([]))

      expect(instance.call('term')).to_not be_success
    end
  end
end
