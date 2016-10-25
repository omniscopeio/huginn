require 'stripe_event'

module Koudoku
  mattr_accessor :stripe_publishable_key
  @@stripe_publishable_key = nil
  
  mattr_accessor :stripe_secret_key
  @@stripe_secret_key = nil

  mattr_accessor :prorate
  @@prorate = true

  
  @@layout = nil
  
  def self.layout
    @@layout || 'application'
  end
  
  def self.layout=(layout)
    @@layout = layout
  end

  def self.setup
    yield self
    
    # Configure the Stripe gem.
    Stripe.api_key = stripe_secret_key
  end
  
  # e.g. :users
  def self.owner_resource
    :users
  end
  
  # e.g. :user_id
  def self.owner_id_sym
    :user_id
  end
  
  # e.g. :user=
  def self.owner_assignment_sym
    :user=
  end

  # e.g. User
  def self.owner_class
    User
  end

  #
  # STRIPE_EVENT section
  #
  def self.subscribe(name, callable = Proc.new)
    StripeEvent.subscribe(name, callable)
  end

  def self.instrument(name, object)
    StripeEvent.backend.instrument(StripeEvent.namespace.call(name), object)
  end

  def self.all(callable = Proc.new)
    StripeEvent.all(callable)
  end

end
