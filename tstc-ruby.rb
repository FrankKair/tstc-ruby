#!/usr/bin/env ruby
class Token
  attr_accessor :type, :value
  def initialize(type, value)
    @type = type
    @value = value
  end
end

class ASTNode
  attr_accessor :properties
  def initialize(properties)
    @properties = properties
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
      token = Token.new('string', value)
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
    ast = ASTNode.new({ type: 'Program', body: [] })
    while @count < @tokens.length
      ast.properties[:body].push(walk)
    end
    ast
  end

  def walk
    token = @tokens[@count]

    if token.type == 'number'
      @count += 1
      return ASTNode.new({ type: 'NumberLiteral', value: token.value })
    end

    if token.type == 'string'
      @count += 1
      return ASTNode.new({ type: 'StringLiteral', value: token.value })
    end

    if token.type == 'paren' && token.value == '('
      @count += 1
      token = @tokens[@count]

      node = ASTNode.new({ type: 'CallExpression', value: token.value, params: [] })
      @count += 1
      token = @tokens[@count]

      while token.type != 'paren' || (token.type == 'paren' && token.value != ')')
        node.properties[:params].push(walk)
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
