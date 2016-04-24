module Permitable
  extend ActiveSupport::Concern

  def propagate_immediately
    return(read_attribute(:propagate_immediately) && user.can?(:propagate_immediately))
  end

  def propagate_immediately?
    return propagate_immediately
  end
end
