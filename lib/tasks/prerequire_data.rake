namespace :db do
  desc "Fill database with initial data"
  task populate: :environment do
    %w{ test staging production }.each do |env|
      Environment.find_or_create_by(name: env)
    end

    ["waiting to deploy", "deploying", "deployed", "rollback", "open", "finish", "cancelled"].each do |env|
      Status.find_or_create_by(name: env)
    end
  end

  desc "Populate repositories"
  task github_repo: :environment do
    client = Octokit::Client.new(
      :access_token => ENV["GITHUB_ACCESS_TOKEN"],
      :auto_paginate => true)

    client.org_repos(ReleasesHelper::ORGANISATION).each do |repo|
      Repository.find_or_create_by(name: repo.name)
    end
  end

  task :initialise => ["db:drop", "db:create", "db:migrate", "db:populate", "db:github_repo"]
end
