require 'token'
class Lexer
  def initialize(str)
    @str = str
    @goback = false
  end

  def next_token
    if @goback
      @goback = false
      return @prev_token
    end

    token = Token.new
    @str.lstrip!

    case @str
    when /\A\+/ then
      token.kind = Token::Plus
    when /\A-/ then
      token.kind = Token::Minus
    when /\A\*/ then
      token.kind = Token::Multiply
    when /\A\// then
      token.kind = Token::Divide
    when /\A\d+(\.\d+)?/ then
      token.kind = Token::Num
      token.value = $&.to_f
    when /\A\(/ then
      token.kind = Token::LParen
    when /\A\)/ then
      token.kind = Token::RParen
    when /\A(\w+)/ then
      token.kind = Token::Function
      token.value = $&
    when '' then
      token.kind = Token::End
    end

    raise 'Unknown token' if token.unknown?
    @str = $'

    @prev_token = token
    token
  end

  def goback
    @goback = true
  end

end

