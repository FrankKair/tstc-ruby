class Parser
  attr_accessor :count, :tokens

  def initialize(tokens)
    @count = 0
    @tokens = tokens
  end

  def parse
    ast = { type: 'Program', body: [] }
    ast[:body].push(walk) while @count < @tokens.length
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
