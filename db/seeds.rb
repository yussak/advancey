# メインのサンプルユーザー
User.create!(name: 'Yusuke1',
             email: 'rocketpeace1753@gmail.com',
             password: 'rocketpeace1753@gmail.com',
             password_confirmation: 'rocketpeace1753@gmail.com')

User.create!(name: 'Yusuke2',
             email: 'yusuke.sakuraba0213@gmail.com',
             password: 'yusuke.sakuraba0213@gmail.com',
             password_confirmation: 'yusuke.sakuraba0213@gmail.com')

# その他ユーザー作成
99.times do |n|
  name = Faker::Name.name
  email = "user#{n + 1}@example.com"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end

# 投稿を作成
users = User.order(:created_at).take(6)
10.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(content: content) }
end

# リレーションを作成
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
