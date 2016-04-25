require 'rails_helper'

describe SubscriptionsController do
  describe "GET index" do
    it "only returns active plans for selection" do
      inactive_plan = plans(:hobby_plan)
      sign_in users(:bob)
      get :index
      expect(assigns(:plans).map(&:stripe_id)).not_to include(inactive_plan.stripe_id)
    end
  end

  describe "GET edit" do
    it "only returns active plans for selection" do
      inactive_plan = plans(:hobby_plan)
      user = users(:bob)
      sign_in user
      get :edit, owner_id: user.id, id: user.subscription.id
      expect(assigns(:plans).map(&:stripe_id)).not_to include(inactive_plan.stripe_id)
    end
  end
end
