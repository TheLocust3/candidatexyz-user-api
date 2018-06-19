if User.where(email: 'jake.kinsella@gmail.com').length == 0
    User.create!(email: 'jake.kinsella@gmail.com', password: 'password', password_confirmation: 'password', admin: true, superuser: true)
end

if User.where(email: 'demo@candidatexyz.com').length == 0
    User.create!(email: 'demo@candidatexyz.com', password: 'password', password_confirmation: 'password', admin: true)
end
