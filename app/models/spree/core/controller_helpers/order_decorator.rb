module Spree
  module Core
    module ControllerHelpers
      Order.module_eval do

        def find_order_by_token_or_user(options={})
          options[:lock] ||= false

          order = try_find_incomplete_order_from_user
          # Find any incomplete orders for the guest_token
          order = Spree::Order.incomplete.includes(:adjustments).lock(options[:lock]).find_by(current_order_params) if order.nil?

          # Find any incomplete orders for the current user
          if order.nil? && try_spree_current_user
            order = last_incomplete_order
          end

          order
        end

        def try_find_incomplete_order_from_user
          return nil if spree_current_user.nil?
          Spree::Order.incomplete.find_by(user_id: try_spree_current_user)
        end
      end
    end
  end
end
