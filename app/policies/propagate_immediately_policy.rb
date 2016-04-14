class PropagateImmediatelyPolicy < Policy
  def check
    user.subscription && user.subscription.plan && ['hobby-plan', 'hobby-fast-11'].include?(user.subscription.plan.stripe_id)
  end
end
