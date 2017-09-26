module Tokenizer
  extend self

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
end