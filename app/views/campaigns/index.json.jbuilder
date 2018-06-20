json.campaigns @campaigns do |campaign|
    json.partial! 'campaigns/campaign', campaign: campaign
end
