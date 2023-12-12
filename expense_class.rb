require "date"

class Expenses
  @@categories = ['Dining/Grocery', 'Entertainment', 'Bills', 'Investments']

  attr_accessor :limit
  attr_reader :list

  def initialize(limit=2000)
    @list = []
    @limit = limit
    @id = 0
  end

  def new_expense(name, amount, category)
    date = Date.today.strftime("%Y-%m-%d")
    amount = "%.2f" % amount.to_f
    category = @@categories[category.to_i - 1]
    @list << {name: name, amount: amount, category: category, date: date, id: @id}
    @id += 1
  end

  def delete_expense(id)
    @list.delete_if { |item| item[:id] == id }
  end

  def total_list_amount
    "%.2f" % @list.map { |item| item[:amount].to_f }.sum
  end

  def exceeded_limit?
    total_list_amount.to_f >= @limit
  end

  def categories
    @@categories
  end
  
  def new_category(category)
    @@categories << category
  end
end
