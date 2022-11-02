require "../src/pyramid"

alias Instruction = Pyramid::VirtualMachine::Instruction
alias Operation = Pyramid::VirtualMachine::Operation
alias IntermediateEvaluator = Pyramid::VirtualMachine::IntermediateEvaluator
alias Wrapper = Pyramid::VirtualMachine::Value
alias Flag = Pyramid::VirtualMachine::Flag

instructions = [
  Instruction.new(Operation::PUSH, Wrapper.new(0)),              # Push 0 to the stack
  Instruction.new(Operation::STORE, Wrapper.new("index")),       # Pop 0 from the stack and set it as a value to variable `index`
  Instruction.new(Operation::FETCH, Wrapper.new("index")),       # Fetch variable `index` and push it to the stack
  Instruction.new(Operation::PUSH, Wrapper.new(10)),             # Push 10 to the stack
  Instruction.new(Operation::COMPARE, Wrapper.new(Flag::FALSE)), # Pop `index` and 10 from the stack and compare them with < operator and push a boolean to the stack
  Instruction.new(Operation::JUMP_IF_FALSE, Wrapper.new(8)),     # Jump by 8 instructions down if the result of the compare instructions is false

  Instruction.new(Operation::PUSH, Wrapper.new("Hello, World!")), # Push `Hello, World!` to the stack
  Instruction.new(Operation::PRINT),                              # Pop `Hello, World!` from the stack and print it to STDOUT

  Instruction.new(Operation::FETCH, Wrapper.new("index")),             # Fetch variable `index` and push it to the stack
  Instruction.new(Operation::PUSH, Wrapper.new(1)),                    # Push 1 to the stack
  Instruction.new(Operation::ADD),                                     # Pop `index` and 1, add them up and push it to the stack
  Instruction.new(Operation::STORE, Wrapper.new("index")),             # Pop `index` + 1 and set it as a value to variable `index`
  Instruction.new(Operation::JUMP, Wrapper.new(-10)),                  # Jump 10 instructions up
  Instruction.new(Operation::PUSH, Wrapper.new("I will return now!")), # Push `I will return now!` to the stack
  Instruction.new(Operation::PRINT),                                   # Pop `I will return now!` from the stack and print it to STDOUT
  Instruction.new(Operation::EXIT),                                    # Break the while loop
] of Instruction

ie = IntermediateEvaluator.new

puts "########################################################"
puts "#           Print out every step of execution          #"
puts "########################################################"

# Print out every step of execution.
ie.step_by_step(instructions) do |instruction_operation, instruction_value, stack, return_address_stack, memory, stack_pointer, instruction_pointer, cycle|
  mapped_memory = memory.map do |k, v|
    {k => v.unwrap}
  end

  puts "\n"
  puts "Operation: #{instruction_operation}"
  puts "Value: #{instruction_value.unwrap}"
  puts "Stack: #{stack.map(&.unwrap)}"
  puts "Return Address Stack: #{return_address_stack}"
  puts "Memory: #{mapped_memory}"
  puts "Stack Pointer: #{stack_pointer}"
  puts "Instruction Pointer: #{instruction_pointer}"
  puts "Cycle: #{cycle}"
end

puts "\n"

puts "########################################################"
puts "# Execute without printing out every step of execution #"
puts "########################################################"

# Execute without printing out every step of execution.
ie.evaluate(instructions)
