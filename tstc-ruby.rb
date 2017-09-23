#!/usr/bin/env ruby
class Token
  attr_accessor :type, :value
  def initialize(type, value)
    @type = type
    @value = value
  end
end

def tokenizer(input)
  current = 0
  tokens = []

  while current < input.length
    char = input[current]
    
    if char == '('
      token = Token.new('paren', '(')
      tokens.push(token)
      current += 1
    end

    if char == ')'
      token = Token.new('paren', ')')
      tokens.push(token)
      current += 1
    end

    if char == ' '
      current += 1
    end

    if char =~ /[0-9]/
      value = ""
      while char =~ /[0-9]/
        value << char
        current += 1
        char = input[current]
      end
      token = Token.new('number', value)
      tokens.push(token)
    end

    if char =~ /[a-z]/
      value = ""
      while char =~ /[a-z]/
        value << char
        current += 1
        char = input[current]
      end
      token = Token.new('number', value)
      tokens.push(token)
    end
  end
  tokens
end

input = "(add 2 (subtract 4 2))"

tokens = tokenizer(input)
tokens.each do |token|
  puts "#{token.type} #{token.value}"
end
