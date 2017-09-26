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