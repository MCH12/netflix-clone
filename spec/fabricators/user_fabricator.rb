Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  full_name { Faker::Name.name }
  token { SecureRandom.urlsafe_base64 }
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end
