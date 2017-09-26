#!/usr/bin/env ruby
require './tokenizer'
require './parser'
require './transformer'

input = "(add 2 (subtract 4 2))"
tokens = Tokenizer.tokenize(input)
ast = Parser.new(tokens).parse
new_ast = Transformer.transform(ast)
