module Tokenizer
  def tokenize(input)
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

      current += 1 if char == ' '

      if char =~ /[0-9]/
        value = ''
        while char =~ /[0-9]/
          value.concat(char)
          current += 1
          char = input[current]
        end
        token = { type: 'number', value: value }
        tokens.push(token)
      end

      next unless char =~ /[a-z]/
      value = ''
      while char =~ /[a-z]/
        value.concat(char)
        current += 1
        char = input[current]
      end
      token = { type: 'string', value: value }
      tokens.push(token)
    end
    tokens
  end

  module_function :tokenize
end
