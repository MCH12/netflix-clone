Fabricator(:invitation) do
  recipient_name { Faker::Name.name }
  recipient_email { Faker::Internet.email }
  message { Faker::Lorem.paragraph(1) }
  token { SecureRandom.urlsafe_base64 }
  inviter_id { 1 }
end
