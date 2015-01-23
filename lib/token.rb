class Token
  Plus = 0
  Minus = 1
  Multiply = 2
  Divide = 3
  Num = 4
  LParen = 5
  RParen = 6
  Function = 7
  End = 8

  attr_accessor :kind
  attr_accessor :value

  def initialize
    @kind = nil
    @value = nil
  end

  def unknown?
    @kind.nil?
  end
end
