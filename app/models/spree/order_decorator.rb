module Spree
  Order.class_eval do

    before_destroy :has_zero_payments?, prepend: true

    def has_zero_payments?
      payments.none?
    end
  end
end
