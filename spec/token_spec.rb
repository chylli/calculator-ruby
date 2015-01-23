require 'rspec'
require 'token'

describe 'Token' do
  it 'is unknow if nothing set' do
    token = Token.new
    expect(token.unknown?).to be true
  end
end

