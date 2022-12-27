FactoryBot.define do
  factory :following do
    follower { create(:user) }
    followed { create(:user) }
  end
end
