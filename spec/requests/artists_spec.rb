require 'spec_helper'

vcr_options = { cassette_name: 'artists', record: :new_episodes }
describe 'Scraping Artists', vcr: vcr_options do
  it 'collects artists' do
    get '/artists?name=Cher'

    last_response.status.should == 200
    expect(decoded_response).to have_key(:results)
  end

  it 'collects artists at a specific page' do
    get '/artists?name=Cher&page=20'

    last_response.status.should == 200
    expect(decoded_response).to have_key(:results)
    expect(decoded_response[:results]['opensearch:Query'][:startPage]).to eq('20')
  end
end
