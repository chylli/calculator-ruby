require 'lexer'

class Parser
  def parse(input)
    @lexer = Lexer.new(input)

    value = expression

    token = @lexer.next_token
    if token.kind = Token::End
      value
    else
      raise 'End expected'
    end
  end

  protected
  def expression
    term1 = factor

    add_op = [Token::Plus, Token::Minus]

    token = @lexer.next_token
    while add_op.include?(token.kind)
      term2 = factor

      if token.kind == Token::Plus
        term1 += term2
      else
        term1 -= term2
      end
      token = @lexer.next_token
    end
    @lexer.goback

    term1

  end

  def factor
    factor1 = number

    mul_op = [Token::Multiply, Token::Divide]
    
    token = @lexer.next_token
    while mul_op.include?(token.kind)
      factor2 = number
 
      if token.kind == Token::Multiply
        factor1 *= factor2
      else
        factor1 /= factor2
      end
 
      token = @lexer.next_token
    end
    @lexer.goback
 
    factor1
  end
 
  def number
    token = @lexer.next_token

    if token.kind == Token::LParen
      value = expression
 
      expected_rparen = @lexer.next_token
      raise 'Unbalanced parenthesis' unless expected_rparen.kind == Token::RParen
    elsif token.kind == Token::Num
      value = token.value
    elsif token.kind == Token::Function
      name = token.value
      expected_lparen = @lexer.next_token
      raise 'Not parenthesis after function' unless expected_lparen.kind == Token::LParen
      arg = expression
      expected_rparen = @lexer.next_token
      raise 'Not parenthesis after function' unless expected_rparen.kind == Token::RParen
      value = process_function(name,arg)
    else
      raise 'Not a number or a function'
    end
 
    value
  end

  def process_function(name, arg)
    case name
      when 'sqrt' then
        Math.sqrt(arg)
      else
        raise 'Dont know the function ' + name
    end
  end
end
