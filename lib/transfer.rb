class Transfer
  attr_reader :from, :to, :amount

  def initialize(from, to, amount)
    @from = from
    @to = to
    @amount = amount
  end

  def call
    return false unless valid?

    ActiveRecord::Base.transaction do
      from.decrement!(:balance, amount)
      to.increment!(:balance, amount)
    end

    true
  end

  def valid?
    from.balance >= amount
  end
end