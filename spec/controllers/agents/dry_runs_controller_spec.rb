require 'rails_helper'

describe Agents::DryRunsController do
  def valid_attributes(options = {})
    {
      type: "Agents::WebsiteAgent",
      name: "Something",
      options: agents(:bob_website_agent).options,
      source_ids: [agents(:bob_weather_agent).id, ""]
    }.merge(options)
  end

  before do
    sign_in users(:bob)
  end

  describe "GET index" do
    it "does not load any events without specifing sources" do
      get :index, type: 'Agents::WebsiteAgent', source_ids: []
      expect(assigns(:events)).to eq([])
    end

    context "does not load events when the agent is owned by a different user" do
      before do
        @agent = agents(:jane_website_agent)
        @agent.sources << @agent
        @agent.save!
        expect(@agent.events.count).not_to be(0)
      end

      it "for new agents" do
        get :index, type: 'Agents::WebsiteAgent', source_ids: [@agent.id]
        expect(assigns(:events)).to eq([])
      end

      it "for existing agents" do
        expect(@agent.events.count).not_to be(0)
        expect { get :index, agent_id: @agent }.to raise_error(NoMethodError)
      end
    end

    context "loads the most recent events" do
      before do
        @agent = agents(:bob_website_agent)
        @agent.sources << @agent
        @agent.save!
      end

      it "load the most recent events when providing source ids" do
        get :index, type: 'Agents::WebsiteAgent', source_ids: [@agent.id]
        expect(assigns(:events)).to eq([@agent.events.first])
      end

      it "loads the most recent events for a saved agent" do
        get :index, agent_id: @agent
        expect(assigns(:events)).to eq([@agent.events.first])
      end
    end
  end

  describe "POST create" do
    before do
      stub_request(:any, /xkcd/).to_return(body: File.read(Rails.root.join("spec/data_fixtures/xkcd.html")), status: 200)
    end

    it "does not actually create any agent, event or log" do
      expect {
        post :create, agent: valid_attributes
      }.not_to change {
        [users(:bob).agents.count, users(:bob).events.count, users(:bob).logs.count]
      }
      results = assigns(:results)
      expect(results[:log]).to be_a(String)
      expect(results[:log]).to include('Extracting html at')
      expect(results[:events]).to be_a(Array)
      expect(results[:events].length).to eq(1)
      expect(results[:events].map(&:class)).to eq([ActiveSupport::HashWithIndifferentAccess])
      expect(results[:memory]).to be_a(Hash)
    end

    it "does not actually update an agent" do
      agent = agents(:bob_weather_agent)
      expect {
        post :create, agent_id: agent, agent: valid_attributes(name: 'New Name')
      }.not_to change {
        [users(:bob).agents.count, users(:bob).events.count, users(:bob).logs.count, agent.name, agent.updated_at]
      }
    end

    it "accepts an event" do
      agent = agents(:bob_website_agent)
      agent.options['url_from_event'] = '{{ url }}'
      agent.save!
      url_from_event = "http://xkcd.com/?from_event=1".freeze
      expect {
        post :create, agent_id: agent, event: { url: url_from_event }
      }.not_to change {
        [users(:bob).agents.count, users(:bob).events.count, users(:bob).logs.count, agent.name, agent.updated_at]
      }
      results = assigns(:results)
      expect(results[:log]).to match(/^\[\d\d:\d\d:\d\d\] INFO -- : Fetching #{Regexp.quote(url_from_event)}$/)
    end
  end
end
