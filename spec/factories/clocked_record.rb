FactoryBot.define do
  factory :clocked_record do
    clocked_in { Time.current }
    user { create(:user) }
  end
end
