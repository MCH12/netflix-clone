Fabricator(:video) do
  title { Faker::Lorem.words(3) }
  description { Faker::Lorem.paragraph(1) }
  video_url { Faker::Internet.domain_name }
end
