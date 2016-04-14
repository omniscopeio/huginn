class Policy
  def initialize(user)
    self.user = user
  end

  def check
    raise 'implement in subclass'
  end

  private
  attr_accessor :user
end
