(1..5).each do |n|
  User.where(name: "develop0#{n}").first_or_create!
end
