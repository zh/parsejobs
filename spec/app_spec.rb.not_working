require ::File.expand_path('../spec_helper.rb', __FILE__)

describe 'parse jobs' do
  include Rack::Test::Methods

  let(:app) { ParseJobs.new }

  context 'main page' do
    before { get '/' }

    it 'display the page' do
      last_response.should be_ok
      last_response.headers["Content-Type"].should == "text/html;charset=utf-8"
    end
  end

  context 'apply page' do
    before { get '/apply' }

    it 'display apply form' do
      last_response.should be_ok
      last_response.headers["Content-Type"].should == "text/html;charset=utf-8"
      last_response.body.should match %r/<form action/i
    end
  end

  context 'non-existing page' do
    before { get '/non-exists' }

    it 'return 404' do
      last_response.status.should == 404
    end
  end

  context 'apply form' do

    it 'return 404 on missing data (about, links)' do
      post '/apply', :name => 'The User', :email => 'user@test.com'
      last_response.status.should == 404
    end
  end
end
