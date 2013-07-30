videos = [
  ["Intro to Ruby Programming", "Learn Ruby programming basics", ["Ruby"]],
  ["OOP Programming in Ruby", "Learn the basics of OOP using Ruby", ["Ruby"]],
  ["Command Line Applications with Ruby", "Learn how to build useful CLI applications using Ruby", ["Ruby"]],
  ["Advanced Ruby Programming", "Take your Ruby programming to the next level!", ["Ruby"]],
  ["Metaprogramming with Ruby", "Program programs using your program with Ruby!", ["Ruby"]],
  ["iOS Programming with Ruby Motion", "Learn to build iPhone applications with Ruby using Ruby Motion", ["Ruby"]],

  ["Getting started with Sublime Text", "Install Sublime Text 2/3 and learn the basics of this popular editor", ["Sublime Text", "Text Editors"]],
  ["Intermediate Sublime Text", "Learn more advanced setup and techniques for working in Sublime Text", ["Sublime Text", "Text Editors"]],
  ["Sublime Text Addons", "Overview of the best Sublime Text plugins, addons, color schemes, and snippets", ["Sublime Text", "Text Editors"]],
  ["Master Sublime Text", "Learn how to make your own Sublime Text plugins, snippets, and color schemes", ["Sublime Text", "Text Editors"]],

  ["Vim Basics", "Learn the basics of why Vim is the best editor. Go away, Emacs.", ["Vim", "Text Editors"]],
  ["Next level Vim", "Take your Vim Basics to the next level with advanced movement and editing techniques", ["Vim", "Text Editors"]],
  ["Vim Customization", "Take a tour of the best Vim addons and colorschemes", ["Vim", "Text Editors"]],
  ["Advanced Vim", "Learn how to effectively use advanced vim features and write your own addons, snippets, and color schemes", ["Vim", "Text Editors"]],

  ["Beginning Rails", "Get a brief introduction to Rails and learn why it's such a powerful framework", ["Rails"]],
  ["Rails 2", "This second Rails screencast goes more in depth into rails and teaches useful tips for working with this framework", ["Rails"]],
  ["Rails 3", "Overview of Rails best practices and some advanced techniques", ["Rails"]],
  ["Rails+ 1", "Learn how to use Rails most effectively with other technologies. In this screencast: javascript", ["Rails"]]
  ]

categories = ["Ruby", "Rails", "Sublime Text", "Vim", "Text Editors"]

categories.each do |title|
  Category.create(title: title)
end

videos.each do |title, description, categories|
  video = Video.new(title: title, description: description)

  categories.each do |category|
    video.categories << Category.where(title: category)
  end

  video.save!
end

users = ["joe", "jim", "jack", "jane"]

users.each do |user|
  u = User.create(email: "#{user}@example.com", password: "password", full_name: "#{user} Lastname")

  Review.create(user: u, video: Video.first, rating: 4, body: "text")
end
