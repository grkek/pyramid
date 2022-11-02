module Pyramid
  module VirtualMachine
    class IntermediateEvaluator
      getter stack : Array(Value) = Array(Value).new
      property return_address_stack : Array(Instruction) = [Instruction.new(Operation::EXIT)] of Instruction
      property memory : Hash(String, Value) = Hash(String, Value).new

      getter stack_pointer : Int64 = 0
      getter instruction_pointer : UInt64 = 0
      getter cycle : UInt64 = 0

      def evaluate(instructions : Array(Instruction))
        step_by_step(instructions) do |_step|
        end
      end

      def step_by_step(instructions : Array(Instruction))
        return if instructions.empty?

        while (@instruction_pointer != instructions.size)
          instruction = fetch(instructions)
          cycle_forward

          case instruction.operation
          when Operation::NOOP
          when Operation::PEEK
            pp @stack.last
          when Operation::PRINT
            puts @stack.pop.to_s
          when Operation::PUSH
            @stack.push instruction.value
          when Operation::POP
            @stack.pop
          when Operation::COMPARE
            first = @stack.pop.to_i32
            second = @stack.pop.to_i32

            flag = Flag.new(instruction.value.to_i32)

            case flag
            when Flag::FALSE
              @stack.push Value.new(first > second)
            when Flag::NEUTRAL
              @stack.push Value.new(first == second)
            when Flag::TRUE
              @stack.push Value.new(first < second)
            end
          when Operation::JUMP
            @instruction_pointer = (@instruction_pointer + instruction.value.to_i32) - 1
            next
          when Operation::JUMP_IF_TRUE
            @instruction_pointer = (@instruction_pointer + instruction.value.to_i32) - 1 if @stack.pop.to_bool
            next
          when Operation::JUMP_IF_FALSE
            @instruction_pointer = (@instruction_pointer + instruction.value.to_i32) - 1 unless @stack.pop.to_bool
            next
          when Operation::STORE
            value = @stack.pop
            @memory[instruction.value.to_s] = value
          when Operation::FETCH
            @stack.push @memory[instruction.value.to_s]
          when Operation::ADD
            first = @stack.pop.to_i32
            second = @stack.pop.to_i32

            @stack.push Value.new(first + second)
          when Operation::CALL
            @return_address_stack.push(instructions[instructions.index!(instruction) + 1])
            @instruction_pointer = @instruction_pointer + instruction.value.to_i32
            next
          when Operation::RETURN
            @instruction_pointer = (instructions.index!(@return_address_stack.pop).to_u64) - 1
            next
          when Operation::EXIT
            break
          else
            raise "Operation #{instruction.operation} has not been implemented"
          end

          yield Tuple.new(instruction.operation, instruction.value, @stack, @return_address_stack, @memory, @stack_pointer, @instruction_pointer, @cycle)
        end
      ensure
        @stack_pointer = 0
        @instruction_pointer = 0
        @cycle = 0
        @stack.clear
        @return_address_stack.clear
        @memory.clear
      end

      private def fetch(instructions)
        return Instruction.new(Operation::EXIT) if @instruction_pointer == instructions.size
        instruction = instructions[@instruction_pointer]
        step_forward()

        instruction
      end

      private def cycle_forward
        @cycle += 1
      end

      private def step_forward
        @instruction_pointer += 1
      end

      private def step_back
        @instruction_pointer -= 1 unless @instruction_pointer == 0
      end
    end
  end
end
