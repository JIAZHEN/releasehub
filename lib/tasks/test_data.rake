namespace :db do
  desc "Fill database with sample data"
  task populate_test: :environment do
    release_status = [5,6]
    deployment_status = [1,2,3,4]
    statuses = Status.all
    environments = Environment.all
    notification_list = ["#test", Faker::Lorem.word, Faker::Lorem.words(3).join(",")]

    releases = []
    100.times do
      releases << Release.create(name: Faker::App.name,
       status_id: release_status.sample,
       summary: Faker::Lorem.sentence,
       created_at: Faker::Date.backward(rand(90))
       )
    end

    deployments = []
    100.times do
      deployments << Deployment.create(release: releases.sample,
        environment: environments.sample,
        status_id: deployment_status.sample,
        dev: Faker::Name.name,
        notification_list: notification_list.sample,
        created_at: Faker::Date.backward(rand(90))
        )
    end

    client = Octokit::Client.new(
      :access_token => ENV["GITHUB_ACCESS_TOKEN"],
      :auto_paginate => true)

    repositories = Repository.where(
      :name => ["scribe","releasehub",
        "payment-app","payment-gateway","cas"]
    ).all

    branches = repositories.reduce([]) do |result, repo|
      client.branches("#{ReleasesHelper::ORGANISATION}/#{repo.name}").each do |branch|
        result << repo.branches.find_or_create_by(name: branch.name)
      end
      result
    end

    shas = {}
    projects = []
    deployments.each do |deployment|
      branch = branches.sample
      shas[branch] ||= client.branch("#{ReleasesHelper::ORGANISATION}/#{branch.repository.name}", branch.name).commit[:sha]
      projects << Project.create(deployment: deployment,
        branch: branch, sha: shas[branch],
        deployment_instruction: Faker::Lorem.sentences.join("."),
        rollback_instruction: Faker::Lorem.sentences.join("."),
        created_at: Faker::Date.backward(rand(90))
        )
    end

    100.times do
      branch = branches.sample
      shas[branch] ||= client.branch("#{ReleasesHelper::ORGANISATION}/#{branch.repository.name}", branch.name).commit[:sha]
      projects << Project.create(deployment: deployments.sample,
        branch: branch, sha: shas[branch],
        deployment_instruction: Faker::Lorem.sentences.join("."),
        rollback_instruction: Faker::Lorem.sentences.join("."),
        created_at: Faker::Date.backward(rand(90))
        )
    end
  end
end
