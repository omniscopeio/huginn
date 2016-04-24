require 'rails_helper'

describe Permitable do
  let(:agent) { Agent.new {|agent| agent.user = user} }
  let(:user) { User.new }

  describe "when the user's plan supports immediate propagation" do
    it "respects the agent's value" do
      stub(user).can?(:propagate_immediately) { true }

      agent.propagate_immediately = true
      expect(agent.propagate_immediately).to eq(true)
      expect(agent.propagate_immediately?).to eq(true)
      agent.propagate_immediately = false
      expect(agent.propagate_immediately).to eq(false)
      expect(agent.propagate_immediately?).to eq(false)
    end
  end

  describe "when the user's plan does not support immediate propagation" do
    it "returns false" do
      stub(user).can?(:propagate_immediately) { false }

      agent.propagate_immediately = true
      expect(agent.propagate_immediately).to eq(false)
      expect(agent.propagate_immediately?).to eq(false)
      agent.propagate_immediately = false
      expect(agent.propagate_immediately).to eq(false)
      expect(agent.propagate_immediately?).to eq(false)
    end
  end
end
