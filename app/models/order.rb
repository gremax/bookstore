class Order < ActiveRecord::Base
  belongs_to :user

  has_many :order_items, dependent: :destroy

  validates :total_price, :state, :completed_at, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :state,
    inclusion: { in: %w(in_progress in_queue in_delivery delivered canceled) }

  def add_book(book)
    current_item = self.order_items.find_or_initialize_by(book: book,
      price: book.price)
    current_item.increment(:quantity)
    current_item.save
  end
end
