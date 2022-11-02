module Pyramid
  module VirtualMachine
    class Value
      property type : String
      property pointer : Pointer(Void)

      def initialize
        @type = typeof(nil).to_s
        @pointer = Box.box(nil)
      end

      def initialize(object : Object)
        @type = typeof(object).to_s
        @pointer = Box.box(object)
      end

      def to_i32
        Box(Int32).unbox(@pointer)
      end

      def to_i64
        Box(Int64).unbox(@pointer)
      end

      def to_u32
        Box(UInt32).unbox(@pointer)
      end

      def to_u64
        Box(UInt64).unbox(@pointer)
      end

      def to_bool
        Box(Bool).unbox(@pointer)
      end

      def unwrap
        case @type
        when "Int32"
          Box(Int32).unbox(@pointer)
        when "UInt64"
          Box(UInt64).unbox(@pointer)
        when "Bool"
          Box(Bool).unbox(@pointer)
        when "String"
          Box(String).unbox(@pointer)
        when "Nil"
          nil
        when "Pyramid::VirtualMachine::Flag"
          Box(Flag).unbox(@pointer)
        else
          raise "Could not unbox #{@type}"
        end
      end

      def to_s
        case @type
        when "Int32"
          Box(Int32).unbox(@pointer).to_s
        when "UInt64"
          Box(UInt64).unbox(@pointer).to_s
        when "Bool"
          Box(Bool).unbox(@pointer).to_s
        when "String"
          Box(String).unbox(@pointer).to_s
        when "Nil"
          "Nil"
        when "Pyramid::VirtualMachine::Flag"
          Box(Flag).unbox(@pointer).to_s
        else
          raise "Could not convert #{@type} to String"
        end
      end
    end
  end
end
