require "rails_helper"

RSpec.describe Deployment, type: :model do
  let(:deployment) { described_class.new }

  subject { deployment }

  it { is_expected.to respond_to(:release_id) }
  it { is_expected.to respond_to(:release) }
  it { is_expected.to respond_to(:status_id) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:environment_id) }
  it { is_expected.to respond_to(:environment) }
  it { is_expected.to respond_to(:dev) }
  it { is_expected.to respond_to(:projects) }
  it { is_expected.to respond_to(:operation_logs) }

  describe "#notify_people?" do
    context "when status is OPEN" do
      before { deployment.status_id = Status::OPEN }

      it "returns false" do
        expect(deployment).not_to be_notify_people
      end
    end

    context "when status is DEPLOYED" do
      before { deployment.status_id = Status::DEPLOYED }

      it "returns true" do
        expect(deployment).to be_notify_people
      end
    end

    context "when status is ROLLBACK" do
      before { deployment.status_id = Status::ROLLBACK }

      it "returns true" do
        expect(deployment).to be_notify_people
      end
    end
  end

  describe "#repo_names" do
    let(:deployment) { create(:deployment) }
    let(:repositories) { create_list(:repository, 3) }
    let(:branches) do
      repositories.map do |repository|
        Branch.create!(:name => repository.name, :repository_id => repository.id)
      end
    end
    let(:projects) do
      branches.map do |branch|
        Project.create!(:sha => "1234", :deployment_id => deployment.id,
          :branch_id => branch.id, :deployment_order => deployment_order.id)
      end
    end

    context "when deployment has many projects" do
      before { deployment.projects = projects }

      it "joins names" do
        expected_names = repositories.map { |repo| repo.name }.join(",")
        expect(deployment.repo_names).to eq(expected_names)
      end
    end
  end
end
