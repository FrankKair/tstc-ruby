module CodeGenerator
  extend self

  def generate(node)
    case node[:type]
    when 'Program'
      node[:body].map { |n| generate(n) }.join("\n")
    when 'ExpressionStatement'
      generate(node[:expression])
    when 'CallExpression'
      callee = generate(node[:callee])
      arguments = node[:arguments].map { |arg| generate(arg) }.join(', ')
      "#{callee}(#{arguments})"
    when 'Identifier'
      node[:name]
    when 'NumberLiteral'
      node[:value]
    else
      raise 'Code generator error'
    end
  end
end
