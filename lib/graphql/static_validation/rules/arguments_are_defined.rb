module GraphQL
  module StaticValidation
    class ArgumentsAreDefined < GraphQL::StaticValidation::ArgumentsValidator
      def validate_node(parent, node, defn, context)
        argument_defn = defn.arguments[node.name]
        if argument_defn.nil?
          kind_of_node = node_type(parent)
          error_arg_name = parent_name(parent, defn)
          context.errors << message("#{kind_of_node} '#{error_arg_name}' doesn't accept argument '#{node.name}'", parent, context: context)
          GraphQL::Language::Visitor::SKIP
        else
          nil
        end
      end
    end
  end
end
