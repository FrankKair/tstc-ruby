#!/usr/bin/env ruby
def tokenizer(input)
  current = 0
  tokens = []

  while current < input.length
    char = input[current]
    
    if char == '('
      token = { type: 'paren', value: '(' }
      tokens.push(token)
      current += 1
    end

    if char == ')'
      token = { type: 'paren', value: ')' }
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
      token = { type: 'number', value: value }
      tokens.push(token)
    end

    if char =~ /[a-z]/
      value = ""
      while char =~ /[a-z]/
        value << char
        current += 1
        char = input[current]
      end
      token = { type: 'string', value: value }
      tokens.push(token)
    end
  end
  tokens
end

class Parser
  attr_accessor :count, :tokens

  def initialize(tokens)
    @count = 0
    @tokens = tokens
  end

  def parse
    ast = { type: 'Program', body: []  }
    while @count < @tokens.length
      ast[:body].push(walk)
    end
    ast
  end

  def walk
    token = @tokens[@count]

    if token[:type] == 'number'
      @count += 1
      return { type: 'NumberLiteral', value: token[:value] }
    end

    if token[:type] == 'string'
      @count += 1
      return { type: 'StringLiteral', value: token[:value] }
    end

    if token[:type] == 'paren' && token[:value] == '('
      @count += 1
      token = @tokens[@count]

      node = { type: 'CallExpression', value: token[:value], params: [] }
      @count += 1
      token = @tokens[@count]

      while token[:type] != 'paren' || (token[:type] == 'paren' && token[:value] != ')')
        node[:params].push(walk)
        token = @tokens[@count]
      end
      @count += 1
      return node
    end
    raise 'Token not recognized.'
  end
end

input = "(add 2 (subtract 4 2))"
tokens = tokenizer(input)
ast = Parser.new(tokens).parse
