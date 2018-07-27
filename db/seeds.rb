
# post
# tagなし
(1..10).each do |n|
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

# tag
alcohols = ['ビール', '日本酒', '焼酎', 'ワイン', 'ウイスキー', 'サワー', 'カクテル']
alcohols.each do |alcohol|
  Tag.create!(name: alcohol)
end

# # post-tag
(1..5).each do |n|
  (1..3).each do |m|
    PostTag.create!(post_id: n,
                    tag_id: m)
  end
end

