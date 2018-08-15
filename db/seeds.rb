superuser_campaign = Campaign.where(name: 'Superuser').first
if superuser_campaign.nil?
    superuser_campaign = Campaign.create!(name: 'Superuser', url: '', preliminary_day: DateTime.now - 1.month, election_day: DateTime.now, city: 'Reading', state: 'MA', country: 'United States', office_type: 'Municipal')
end

campaign = Campaign.where(name: 'Reading Democratic Committee').first
if campaign.nil?
    campaign = Campaign.create!(name: 'Reading Democratic Committee', url: 'https://demo.candidatexyz.com', preliminary_day: DateTime.now - 1.month, election_day: DateTime.now, city: 'Reading', state: 'MA', country: 'United States', office_type: 'Municipal')
end

if User.where(email: 'jake.kinsella@gmail.com').length == 0
    User.create!(email: 'jake.kinsella@gmail.com', password: 'password', password_confirmation: 'password', admin: true, superuser: true, campaign_id: superuser_campaign.id)
end

if User.where(email: 'demo@candidatexyz.com').length == 0
    User.create!(email: 'demo@candidatexyz.com', password: 'password', password_confirmation: 'password', admin: true, campaign_id: campaign.id)
end

if User.where(email: 'jake@candidatexyz.com').length == 0
    User.create!(email: 'jake@candidatexyz.com', password: 'password', password_confirmation: 'password', admin: true)
end

# testing stuff
test_campaign = Campaign.where(name: 'Test').first
if test_campaign.nil?
    test_campaign = Campaign.create!(name: 'Test', preliminary_day: DateTime.now - 1.month, election_day: DateTime.now, city: 'Test City', state: 'MA', country: 'United States', office_type: 'Municipal')
end

if User.where(email: 'test@gmail.com').length == 0
    User.create!(email: 'test@gmail.com', password: 'password', password_confirmation: 'password', admin: true, campaign_id: test_campaign.id)
end
