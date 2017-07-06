class DeployCommand
  attr_reader :environment
  attr_reader :repository
  attr_reader :branch

  def self.for(environment, repository, branch)
    new(environment, repository, branch).all
  end

  def initialize(environment, repository, branch)
    @environment = environment
    @repository = repository
    @branch = branch
  end

  def all
    return [] unless usable_commands?

    if repository.wld?
      [wld_deploy_command]
    else
      [revisions_command, puppet_command]
    end
  end

  private

  def usable_commands?
    environment.qa?
  end

  def wld_deploy_command
    "sudo /usr/local/bin/cap-deploy #{branch.name}"
  end

  def revisions_command
    "sudo -u dev update_revisions_cloud.sh #{environment.name} #{repository.name} #{branch.name}"
  end

  def puppet_command
    "sudo puppet agent -t --tags #{repository.puppet_tag}"
  end
end
