require 'lexer'

describe Lexer do

  it 'should parse "" as end token' do
    for str in ['', ' ', '  '] do
      lexer = Lexer.new(str)
      expect(lexer.next_token.kind).to eq(Token::End)
    end
  end    
  
  it 'should parse "5" as number and has end token' do
    for str in ['5', '5 ', ' 5 ', ' 5'] do
      lexer = Lexer.new(str)
      a = lexer.next_token
      expect(a.kind).to eq(Token::Num);
      expect(a.value).to eq(5);
      expect(lexer.next_token.kind).to eq(Token::End)
    end


  end

  it 'should parse "(" as LParen' do
    for str in ['(', '( ', ' ( ', ' ('] do
      lexer = Lexer.new(str)
      a = lexer.next_token
      expect(a.kind).to eq(Token::LParen);
    end
  end

  it 'should parse ")" as RParen' do
    for str in [')', ') ', ' ) ', ' )'] do
      lexer = Lexer.new(str)
      a = lexer.next_token
      expect(a.kind).to eq(Token::RParen);
    end
  end

  it 'should parse "+" as Plus' do
    lexer = Lexer.new('+')
    a = lexer.next_token
    expect(a.kind).to eq(Token::Plus);
  end

  it 'should parse "-" as Minus' do
    lexer = Lexer.new('-')
    a = lexer.next_token
    expect(a.kind).to eq(Token::Minus);
  end

  it 'should parse "*" as Multiply' do
    lexer = Lexer.new('*')
    a = lexer.next_token
    expect(a.kind).to eq(Token::Multiply);
  end

  it 'should parse "/" as Multiply' do
    lexer = Lexer.new('/')
    a = lexer.next_token
    expect(a.kind).to eq(Token::Divide);
  end

  it 'should get same token after revert' do
    lexer = Lexer.new('/')
    a = lexer.next_token
    lexer.goback
    b = lexer.next_token
    expect(a).to eq(b);
  end

  it 'should get next token for every next_token' do
    lexer = Lexer.new('5*3')
    a = lexer.next_token
    b = lexer.next_token
    expect(a.kind).to eq(Token::Num)
    expect(b.kind).to eq(Token::Multiply)
  end

  it 'should parse "sqrt" as a function' do
    lexer = Lexer.new('sqrt')
    a = lexer.next_token
    expect(a.kind).to eq(Token::Function)
    expect(a.value).to eq('sqrt')
  end
      
end
