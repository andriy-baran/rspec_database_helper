require "rspec_database_helper/version"

module RspecDatabaseHelper
  module ClassMethods
    require 'parser/current'

    class DatabaseDSLTranslator < ::Parser::TreeRewriter
      def on_send(node)
        _, method_name, *args = node.children

        factory_attrs = args.map { |e| e.loc.expression.source }.join(', ')

        case method_name
        when /list!$/
          replace(node.loc.expression, "let!(:#{method_name.to_s.sub(/_list!$/,'')}) { FactoryBot.create_list(#{factory_attrs}) }")
        when /list$/
          replace(node.loc.expression, "let(:#{method_name.to_s.sub(/_list$/,'')}) { FactoryBot.create_list(#{factory_attrs}) }")
        when /!$/
          replace(node.loc.expression, "let!(:#{method_name.to_s.sub(/!$/,'')}) { FactoryBot.create(#{factory_attrs}) }")
        else
          replace(node.loc.expression, "let(:#{method_name}) { FactoryBot.create(#{factory_attrs}) }")
        end
      end
    end

    #
    # Tiny DSL for creating list or single database records
    # via factory_bot syntax and Rspec :let or :let! methods
    # Usage:
    # user(:user, name: 'Bob') is translated to let(:user) { FactoryBot.create(:user, name: 'Bob') }
    # user!(:user, name: 'Bob') is translated to let!(:user) { FactoryBot.create(:user, name: 'Bob') }
    # user_list(:user, name: 'Bob', 3) is translated to let(:user) { FactoryBot.create_list(:user, 3, name: 'Bob') }
    # user_list!(:user, name: 'Bob', 3) is translated to let!(:user) { FactoryBot.create_list(:user, 3, name: 'Bob') }
    #
    def database(&block)
      parser        = Parser::CurrentRuby.new
      rewriter      = DatabaseDSLTranslator.new
      buffer        = Parser::Source::Buffer.new('(string)')
      buffer.source = Parser::CurrentRuby.parse(block.source).children.last.loc.expression.source
      rspec_factory = rewriter.rewrite(buffer, parser.parse(buffer))
      self.class_eval(rspec_factory)
    end
  end


  def self.included(receiver)
    receiver.extend ClassMethods
  end
end
