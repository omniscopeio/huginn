module Authorizable
  extend ActiveSupport::Concern

  def can?(policy_symbol)
    policy_name = "#{policy_symbol}_policy".camelize
    begin
      policy = policy_name.constantize
    rescue NameError
      raise PolicyNotFoundError.new("#{policy_name} is not defined")
    end
    policy.new(self).check
  end

  alias allowed_to? can?
end
