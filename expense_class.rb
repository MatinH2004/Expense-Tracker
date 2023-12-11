require "date"

class Expenses
  @@categories = ['Dining/Grocery', 'Entertainment', 'Bills', 'Investments']

  attr_accessor :limit
  attr_reader :list

  def initialize(month, limit=2000)
    @list = []
    @month = month
    @limit = limit
    @id = 0
  end

  # actions:
  # - add expense
  #   - choose category
  #   - enter price
  #   - name
  # - delete expense
  # - warn user when near limit
  # - add custom category

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

  def near_limit?
    total_list_amount > (@limit - 100)
  end

  def exceeded_limit
    total_list_amount >= @limit
  end

  def categories
    @@categories
  end
  
  def new_category(category)
    @@categories << category
  end
end

# my_expenses = Expenses.new('December', 1000)

# my_expenses.new_expense('Gym Membership', 20, 'Bills')
# my_expenses.new_expense('S&P500', 150, 'Investments')

# my_expenses.list.each { |i| puts i[:id]}
# my_expenses.delete_expense(1)
# p my_expenses.total_list_amount
# p my_expenses.list
