json.committees @committees do |committee|
    json.partial! 'committees/committee', committee: committee
end
