require "rails_helper"

RSpec.describe SlackHelper, type: :helper do
  describe "#slack_notify_list" do
    before do
      Rails.cache.clear
      ENV["SLACK_TOKEN"] = "token"
      stub_request(:post, "https://slack.com/api/users.list").with(:body => {"token"=>true}).
        to_return(:status => 200, :body => '{"members":[{"name":"release"},{"name":"hub"}]}')

      stub_request(:post, "https://slack.com/api/channels.list").
        with(:body => {"exclude_archived"=>"1", "token"=>true}).
        to_return(:status => 200, :body => '{"channels":[{"name":"release"},{"name":"hub"}]}')
    end

    it "pulls members and channels from api" do
      expect(helper.slack_notify_list).to eq('[{"name":"@release"},{"name":"@hub"},{"name":"#release"},{"name":"#hub"}]')
    end
  end
end
