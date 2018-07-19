# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do |n|
  user_id = 1
  content = "#{n}投稿目, 新規投稿ユーザーID_#{user_id}"
  Post.create!(content: content,
               user_id: user_id)
end

10.times do |n|
  user_id = 2
  content = "#{n}投稿目, 新規投稿ユーザーID_#{user_id}"
  Post.create!(content: content,
               user_id: user_id)
end