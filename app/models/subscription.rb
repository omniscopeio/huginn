class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  attr_accessor :credit_card_token

  before_destroy :cancel_subscription!
  before_save :processing!

  def processing!

    # if their package level has changed ..
    if changing_plans?

      prepare_for_plan_change

      # and a customer exists in stripe ..
      if stripe_id.present?

        # fetch the customer.
        customer = Stripe::Customer.retrieve(self.stripe_id)

        # if a new plan has been selected
        if self.plan.present?

          # Record the new plan pricing.
          self.current_price = self.plan.price

          prepare_for_downgrade if downgrading?
          prepare_for_upgrade if upgrading?

          # update the package level with stripe.
          customer.update_subscription(:plan => self.plan.stripe_id, :prorate => Koudoku.prorate)

          finalize_downgrade! if downgrading?
          finalize_upgrade! if upgrading?


        else # if no plan has been selected.

          prepare_for_cancelation

          # Remove the current pricing.
          self.current_price = nil

          # delete the subscription.
          customer.cancel_subscription

          finalize_cancelation!

        end
      else # when customer DOES NOT exist in stripe ..
        # if a new plan has been selected
        if self.plan.present?

          # Record the new plan pricing.
          self.current_price = self.plan.price

          prepare_for_new_subscription
          prepare_for_upgrade

          begin

            customer_attributes = {
              description: subscription_owner_description,
              email: subscription_owner_email,
              card: credit_card_token # obtained with Stripe.js
            }

            # create a customer at that package level.
            customer = Stripe::Customer.create(customer_attributes)

            finalize_new_customer!(customer.id, plan.price)
            customer.update_subscription(:plan => self.plan.stripe_id, :prorate => Koudoku.prorate)

          rescue Stripe::CardError => card_error
            errors[:base] << card_error.message
            card_was_declined
            return false
          end

          # store the customer id.
          self.stripe_id = customer.id
          self.last_four = customer.cards.retrieve(customer.default_card).last4

          finalize_new_subscription!
          finalize_upgrade!

        else

          # This should never happen.

          self.plan_id = nil

          # Remove any plan pricing.
          self.current_price = nil

        end

      end

      finalize_plan_change!
    elsif self.credit_card_token.present? # if they're updating their credit card details.

      prepare_for_card_update

      # fetch the customer.
      customer = Stripe::Customer.retrieve(self.stripe_id)
      customer.card = self.credit_card_token
      customer.save

      # update the last four based on this new card.
      self.last_four = customer.cards.retrieve(customer.default_card).last4
      finalize_card_update!

    end

  end

  def cancel_subscription!
    prepare_for_plan_change
    prepare_for_cancelation
    
    # delete the subscription.
    customer = Stripe::Customer.retrieve(self.stripe_id)
    customer.cancel_subscription

    finalize_cancelation!
    finalize_plan_change!
  end

  def describe_difference(plan_to_describe)
    if plan.nil?
      if persisted?
        "Upgrade"
      else
        if plan.free_trial?
          "Start Trial"
        else
          "Upgrade"
        end
      end
    else
      if plan_to_describe.is_upgrade_from?(plan)
        "Upgrade"
      else
        "Downgrade"
      end
    end
  end

  # Pretty sure this wouldn't conflict with anything someone would put in their model
  def subscription_owner
    # Return whatever we belong to.
    # If this object doesn't respond to 'name', please update owner_description.
    send Koudoku.subscriptions_owned_by
  end

  def subscription_owner=(owner)
    # e.g. @subscription.user = @owner
    send Koudoku.owner_assignment_sym, owner
  end

  def subscription_owner_description
    # assuming owner responds to name.
    # we should check for whether it responds to this or not.
    "#{subscription_owner.try(:name) || subscription_owner.try(:id)}"
  end

  def subscription_owner_email
    "#{subscription_owner.try(:email)}"
  end

  def changing_plans?
    plan_id_changed?
  end

  def downgrading?
    plan.present? and plan_id_was.present? and plan_id_was > self.plan_id
  end

  def upgrading?
    (plan_id_was.present? and plan_id_was < plan_id) or plan_id_was.nil?
  end

  # Template methods.
  def prepare_for_plan_change
  end

  def prepare_for_new_subscription
  end

  def prepare_for_upgrade
  end

  def prepare_for_downgrade
  end

  def prepare_for_cancelation
  end

  def prepare_for_card_update
  end

  def finalize_plan_change!
  end

  def finalize_new_subscription!
  end

  def finalize_new_customer!(customer_id, amount)
  end

  def finalize_upgrade!
  end

  def finalize_downgrade!
  end

  def finalize_cancelation!
  end

  def finalize_card_update!
  end

  def card_was_declined
  end

  # stripe web-hook callbacks.
  def payment_succeeded(amount)
  end

  def charge_failed
  end

  def charge_disputed
  end

end
