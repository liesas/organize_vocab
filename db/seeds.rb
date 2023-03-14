# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Doorkeeper::Application.count.zero?
  Fabricate(:application, name: 'client')
end

unless User.find_by email: 'test@user.com'
  user = Fabricate(:user, email: 'test@user.com', password: 'password')
  %w[啊 阿姨 矮 爱好 安静 把 搬 班 办法 办公室 半 帮忙].map { |str| Fabricate(:word, dictionary_form: str) }.each do |word|
    Fabricate(:vocabulary_word, user: user, word: word)
  end
end
