require 'test_helper'
 
class CampaignTest < ActiveSupport::TestCase
  test 'should create campaign' do
    campaign = Campaign.new( name: 'Test Campaign', preliminary_day: DateTime.now - 1.month, election_day: DateTime.now, city: 'Reading', state: 'MA', country: 'United States', office_type: 'Municipal' )

    assert campaign.save
  end
end