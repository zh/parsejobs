require ::File.expand_path('../spec_helper.rb', __FILE__)

describe 'parse jobs' do
  include Rack::Test::Methods

  let(:app) { ParseJobs.new }
end
