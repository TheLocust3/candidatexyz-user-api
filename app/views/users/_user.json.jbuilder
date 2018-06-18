if user.nil?
    return
end

json.id user.id
json.email user.email
json.firstName user.first_name
json.lastName user.last_name
