module Pyramid
  module VirtualMachine
    class Instruction
      property operation : Operation
      property value : Value

      def initialize(@operation : Operation, value : Value? = nil)
        if value
          @value = value
        else
          @value = Value.new
        end
      end
    end
  end
end
