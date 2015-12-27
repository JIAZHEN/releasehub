FactoryGirl.define do
  factory :user do
    sequence(:github_login) { |n| "github_login_#{n}" }
    sequence(:name) { |n| "name_#{n}" }
    sequence(:slack_username) { |n| "slack_username_#{n}" }
  end

  factory :operation_log do
    username "MyString"
    status_id 1
    deployment_id 1
  end

  factory :project do
    association :deployment, :factory => :deployment
    association :branch, :factory => :branch
    sequence(:sha) { |n| "sha_#{n}" }
    sequence(:deployment_instruction) { |n| "deployment_instruction_#{n}" }
    sequence(:rollback_instruction) { |n| "rollback_instruction_#{n}" }
  end

  factory :deployment do
    association :release, :factory => :release
    association :environment, :factory => :environment
    association :status, :factory => :status
    sequence(:notification_list) { |n| "notification_list_#{n}" }
    sequence(:dev) { |n| "dev_#{n}" }

    factory :deployment_with_projects do
      transient do
        projects_count 3
      end

      after(:create) do |deployment, evaluator|
        create_list(:project, evaluator.projects_count, deployment: deployment)
      end
    end
  end

  factory :repository do
    sequence(:name) { |n| "repo_name_#{n}" }

    factory :repository_with_branches do
      transient do
        branches_count 3
      end

      after(:create) do |repository, evaluator|
        create_list(:branch, evaluator.branches_count, repository: repository)
      end
    end
  end

  factory :environment do
    sequence(:name) { |n| "env_name_#{n}" }
  end

  factory :status do
    sequence(:name) { |n| "status_name_#{n}" }
  end

  factory :branch do
    sequence(:name) { |n| "branch_name_#{n}" }
    active true
    association :repository, :factory => :repository
  end

  factory :release do
    sequence(:name) { |n| "release_name_#{n}" }
    sequence(:summary) { |n| "release_summary_#{n}" }
    association :status, :factory => :status
  end
end
