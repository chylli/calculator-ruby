require 'parser'
 
describe Parser do
  before(:each) do
    @parser = Parser.new
  end

  it 'should calculate 2 + ( ( 4 + 6 ) * (9 - 2) - 5 - 1) + 1' do
    expect(@parser.parse('2 + ( ( 4 + 6 ) * (9 - 2) - 5 - 1) + 1')).to eq(67)
  end

  it 'should calculate 2 + ( ( 4 + 6 ) * sqrt(5) + 3) / 2  + 1' do
    expect(@parser.parse('2 + ( ( 4 + 6 ) * sqrt(5) + 3) / 2  + 1')).to be_within(0.01).of(15.68)
  end


  it 'should calculate 5 when given 5' do
    expect(@parser.parse('5')).to eq 5
  end

  it 'should calculate 5 when given 5' do
    expect(@parser.parse(' 5 ')).to eq 5
  end


  it 'should calculate 5 when given 2 + 3' do
    expect(@parser.parse('2 + 3')).to eq 5
  end
 
  it 'should calculate 6 when given 2 * 3' do
    expect(@parser.parse('2 * 3')).to eq 6
  end
 
  it 'should calculate 89 when given 89' do
    expect(@parser.parse('89')).to eq 89
  end
 
  it 'should raise an error when input is empty' do
    expect(lambda {@parser.parse('')}).to raise_error
  end
 
  it 'should omit white spaces' do
    expect(@parser.parse('   12        -  8   ')).to eq 4
    expect(@parser.parse('142        -9   ')).to eq 133
    expect(@parser.parse('72+  15')).to eq 87
    expect(@parser.parse(' 12*  4')).to eq 48
    expect(@parser.parse(' 50/10')).to eq 5
  end
 
 
  it 'should handle tight expressions' do
    expect(@parser.parse('67+2')).to eq 69
    expect(@parser.parse(' 2-7')).to eq(-5)
    expect(@parser.parse('5*7 ')).to eq 35
    expect(@parser.parse('8/4')).to eq 2
  end
 
  it 'should calculate long additive expressions from left to right' do
    expect(@parser.parse('2 -4 +6 -1 -1- 0 +8')).to eq 10
    expect(@parser.parse('1 -1   + 2   - 2   +  4 - 4 +    6')).to eq 6
  end
 
  it 'should calculate long multiplicative expressions from left to right' do
    expect(@parser.parse('2 -4 +6 -1 -1- 0 +8')).to eq 10
    expect(@parser.parse('1 -1   + 2   - 2   +  4 - 4 +    6')).to eq 6
  end
 
  it 'should calculate long, mixed additive and multiplicative expressions from left to right' do
    expect(@parser.parse(' 2*3 - 4*5 + 6/3 ')).to eq(-12)
    expect(@parser.parse('2*3*4/8 -   5/2*4 +  6 + 0/3   ')).to eq(-1)
  end


  it 'should treat dot separated floating point numbers as a valid input' do
    expect(@parser.parse('2.5')).to eq 2.5
    expect(@parser.parse('4*2.5 + 8.5+1.5 / 3.0')).to eq 19
    expect(@parser.parse('5.0005 + 0.0095')).to be_within(0.01).of(5.01)
  end
  it 'should return float pointing numbers when division result is not an integer' do
    expect(@parser.parse('10/4')).to eq 2.5
    expect(@parser.parse('5/3')).to be_within(0.01).of(1.66)
    expect(@parser.parse('3 + 8/5 -1 -2*5')).to be_within(0.01).of(-6.4)
  end
 
  it 'should raise an error on wrong token' do
    expect(lambda {@parser.parse('  6 + c')}).to raise_error()
    expect(lambda {@parser.parse('  7 &amp; 2')}).to raise_error()
    expect(lambda {@parser.parse('  %')}).to raise_error()
  end
 
  it 'should raise an error on syntax error' do
    expect(lambda {@parser.parse(' 5 + + 6')}).to raise_error()
    expect(lambda {@parser.parse(' -5 + 2')}).to raise_error()
  end
 
  it 'should return Infinity when attempt to divide by zero occurs' do
    expect(@parser.parse('5/0')).to be_infinite
    expect(@parser.parse(' 2 - 1 + 14/0 + 7')).to be_infinite
  end
 
  it 'should calculate 2 when given (2)' do
    expect(@parser.parse('(2)')).to eq 2
  end
 
  it 'should calculate complex expressions enclosed in parenthesis' do
    expect(@parser.parse('(5 + 2*3 - 1 + 7 * 8)')).to eq 66
    expect(@parser.parse('(67 + 2 * 3 - 67 + 2/1 - 7)')).to eq 1
  end
 
  it 'should calculate expressions with many subexpressions enclosed in parenthesis' do
    expect(@parser.parse('(2) + (17*2-30) * (5)+2 - (8/2)*4')).to eq 8
    expect(@parser.parse('(5*7/5) + (23) - 5 * (98-4)/(6*7-42)')).to be_infinite
  end
 
  it 'should handle nested parenthesis' do
    expect(@parser.parse('(((((5)))))')).to eq 5
    expect(@parser.parse('(( ((2)) + 4))*((5))')).to eq 30
  end

  it 'should calculate expressions with function sqrt' do
    expect(@parser.parse('sqrt(4)')).to eq(2)
    expect(@parser.parse('sqrt(4) * 2')).to eq(4)
    expect(@parser.parse('sqrt(4) * sqrt(4)')).to eq(4)
    expect(@parser.parse('sqrt(5)*sqrt(5)')).to be_within(5).of(0.01)

  end

	it 'should raise an error on unknow function' do
    expect(lambda {@parser.parse('hello(2)')}).to raise_error()
  end

  it 'should raise an error when function is not followed by a parenthesis' do
    expect(lambda {@parser.parse('sqrt 2')}).to raise_error()
    expect(lambda {@parser.parse('sqrt2')}).to raise_error()
  end

	
  it 'should raise an error on unbalanced parenthesis' do
    expect(lambda {@parser.parse('sqrt(4')}).to raise_error()
    expect(lambda {@parser.parse('2 + (5 * 2')}).to raise_error()
    expect(lambda {@parser.parse('(((((4))))')}).to raise_error()
    expect(lambda {@parser.parse('((2)) * ((3')}).to raise_error()
    expect(lambda {@parser.parse('((9)) * ((1)')}).to raise_error()
  end
end
