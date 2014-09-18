FactoryGirl.define do
  factory :campaign do
    sequence(:name) { |n| "campaign_#{n}" }
    missionhub_token 'missionhub_token'
    status 'opened'
    url { Faker::Internet.domain_name }
    subdomain false
    locale
  end
end
