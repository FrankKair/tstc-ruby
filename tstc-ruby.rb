require './tokenizer'
require './parser'
require './transformer'
require './code_generator'

input   = '(add 2 (subtract 4 2))'
tokens  = Tokenizer.tokenize(input)
ast     = Parser.new(tokens).parse
new_ast = Transformer.transform(ast)
output  = CodeGenerator.generate(new_ast)

puts output
