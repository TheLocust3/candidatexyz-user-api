campaign = Campaign.where(name: 'Reading Democratic Committee').first
if campaign.nil?
    campaign = Campaign.create!(name: 'Reading Democratic Committee')
end

if User.where(email: 'jake.kinsella@gmail.com').length == 0
    User.create!(email: 'jake.kinsella@gmail.com', password: 'password', password_confirmation: 'password', admin: true, superuser: true, campaign_id: campaign.id)
end

if User.where(email: 'demo@candidatexyz.com').length == 0
    User.create!(email: 'demo@candidatexyz.com', password: 'password', password_confirmation: 'password', admin: true, campaign_id: campaign.id)
end
