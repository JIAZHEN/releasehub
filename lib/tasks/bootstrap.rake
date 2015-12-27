task :bootstrap => "bootstrap:config"

namespace :bootstrap do
  desc "Setup config files, based on examples"
  task :config => FileList["config/*.env.example"].ext("")
end

rule ".env" => ".env.example" do |task|
  cp task.source, task.name
end
