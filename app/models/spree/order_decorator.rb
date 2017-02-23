module Spree
  Order.class_eval do

    def merge!(order, user = nil)
      order.line_items.each do |line_item|
        next unless line_item.currency == currency
        current_line_item = self.line_items.find_by(variant: line_item.variant)
        if current_line_item
          current_line_item.quantity += line_item.quantity
          current_line_item.save
        else
          line_item.order_id = self.id
          line_item.save
        end
      end

      self.associate_user!(user) if !self.user && !user.blank?

      updater.update_item_count
      updater.update_item_total
      updater.persist_totals

      # So that the destroy doesn't take out line items which may have been re-assigned
      order.line_items.reload
      order.destroy if order.payments.size == 0
    end
  end
end
