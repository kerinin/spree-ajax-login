Factory.define :role do |r|
end

Factory.define :user do |u|
  u.sequence(:email) { |n| "person#{n}@email.com" }
  u.sequence(:login) { |n| "login#{n}" }
  u.password "A really long password1234"
  u.password_confirmation "A really long password1234"
  u.roles { [Role.find_by_name("user") || Factory(:user_role) ] }
end

Factory.define(:user_role, :parent => :role) do |r|
  r.name "user"
end

Factory.define(:admin_role, :parent => :role) do |r|
  r.name "admin"
end

Factory.define(:admin_user, :parent => :user) do |u|
  u.roles { [Role.find_by_name("admin") || Factory(:admin_role)]}
end

