module Pyramid
  module VirtualMachine
    enum Operation : UInt8
      NOOP          =   0
      JUMP          =   1
      PEEK          =   3
      PUSH          =  16
      POP           =   5
      EXIT          =  15
      RETURN        = 255
      CALL          = 202
      JUMP_IF_TRUE  =  31
      JUMP_IF_FALSE =  32
      COMPARE       = 220

      SWAP  =   2
      RSWP  =  34
      ISWP  = 226
      DEC   =   4
      ADD   =   6
      SUB   =   8
      MUL   =  11
      DIV   =  12
      PRINT =  14
      TEXT  =  10

      STORE = 64
      FETCH = 60

      AND = 77
      OR  = 78
      NOT = 93
    end
  end
end
