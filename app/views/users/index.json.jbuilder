json.users @users do |user|
    json.partial! 'users/user', user: user
end
