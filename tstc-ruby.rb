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

  private
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
      node = { type: 'CallExpression', name: token[:value], params: [] }
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

module Transformer
  extend self
  def transform(ast)
    new_ast = { type: 'Program', body: [] }
    ast[:context] = new_ast[:body]
    traverse(ast)
    new_ast
  end

  private
  def traverse(ast)
    traverse_node(ast, {})
  end

  def traverse_node(node, parent_node)
    visitor(node, parent_node)
    case node[:type]
    when 'Program'
      traverse_array(node[:body], node)
    when 'CallExpression'
      traverse_array(node[:params], node)
    when 'NumberLiteral'
    else
      raise 'Token not recognized.'
    end
  end

  def visitor(node, parent_node)
    node_type = node[:type]
    case node_type
    when 'NumberLiteral'
      parent_node[:context].push({ type: 'NumberLiteral', value: node[:value] })
    when 'CallExpression'
      expression = {
        type: 'CallExpression',
        callee: {
          type: 'Identifier',
          name: node[:name]
        },
        arguments: []
      }
      node[:context] = expression[:arguments]
      if parent_node[:type] != 'CallExpression'
        expression_statement = { type: 'ExpressionStatement', expression: expression }
        parent_node[:context].push(expression_statement)
      else
        parent_node[:context].push(expression)
      end
    end
  end

  def traverse_array(nodes, parent_node)
    nodes.each do |node|
      traverse_node(node, parent_node)
    end
  end
end

input = "(add 2 (subtract 4 2))"
tokens = tokenizer(input)
ast = Parser.new(tokens).parse
new_ast = Transformer.transform(ast)
