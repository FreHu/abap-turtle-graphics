class zcl_turtle_lsystem definition
  public final.

  public section.
    types:
      begin of lsystem_rewrite_rule,
        "! Original string
        from type string,
        "! New string
        to   type string,
      end of lsystem_rewrite_rule,
      lsystem_rewrite_rules type standard table of lsystem_rewrite_rule with empty key.

    types: lsystem_instruction_kind type string.
    constants:
      begin of instruction_kind,
        "! Doesn't do anything. Can be used for helper symbols.
        noop       type lsystem_instruction_kind value `noop`,
        "! Go forward by 'amount' pixels
        forward    type lsystem_instruction_kind value `forward`,
        "! Go back by 'amount' pixels
        back       type lsystem_instruction_kind value `back`,
        "! Turn left by 'amount' degrees
        left       type lsystem_instruction_kind value `left`,
        "! Turn right by 'amount' degrees
        right      type lsystem_instruction_kind value `right`,
        "! Push position on the stack
        stack_push type lsystem_instruction_kind value `stack_push`,
        "! Pop position from the stack
        stack_pop  type lsystem_instruction_kind value `stack_pop`,
      end of instruction_kind.

    types:
      begin of lsystem_instruction,
        symbol type c LENGTH 1,
        kind   type lsystem_instruction_kind,
        "! Distance or angle (if the operation requires it)
        amount type i,
      end of lsystem_instruction,
      lsystem_instructions type hashed table of lsystem_instruction with unique key symbol.

    types:
      begin of params,
        "! Starting symbols
        initial_state  type string,
        "! How many times the rewrite rules will be applied
        num_iterations type i,
        instructions   type lsystem_instructions,
        "! A list of rewrite patterns which will be applied each iteration in order.
        "! E.g. initial state F with rule F -> FG and 3 iterations
        "! will produce FG, FGG, FGGG in each iteration respectively.
        "! Currently allows up to 3 variables F,G,H
        rewrite_rules  type lsystem_rewrite_rules,
      end of params.

    class-methods create
      importing turtle        type ref to zcl_turtle
                parameters    type params
      returning value(result) type ref to zcl_turtle_lsystem.

    methods execute.
    methods show.

  private section.
    methods get_final_value
      returning value(result) type string.

    types: t_position_stack type standard table of zcl_turtle=>turtle_position with empty key.
    methods:
      push_stack importing position type zcl_turtle=>turtle_position,
      pop_stack returning value(position) type zcl_turtle=>turtle_position.

    data: turtle type ref to zcl_turtle.
    data: parameters type params.
    data: position_stack type t_position_stack.
endclass.

class zcl_turtle_lsystem implementation.

  method create.
    result = new #( ).
    result->turtle = turtle.
    result->parameters = parameters.
  endmethod.

  method execute.
    data(final_value) = get_final_value( ).

    data(index) = 0.
    while index < strlen( final_value ).
      data(symbol) = final_value+index(1).
      data(rule) = value #( parameters-instructions[ symbol = symbol ] optional ).
      case rule-kind.
        when instruction_kind-noop.
          continue.
        when instruction_kind-forward.
          turtle->forward( rule-amount ).
        when instruction_kind-back.
          turtle->back( rule-amount ).
        when instruction_kind-left.
          turtle->right( conv f( rule-amount ) ).
        when instruction_kind-right.
          turtle->left( conv f( rule-amount ) ).
        when instruction_kind-stack_push.
          push_stack( turtle->position ).
        when instruction_kind-stack_pop.
          data(position) = pop_stack( ).
          turtle->goto( x = position-x y = position-y ).
          turtle->set_angle( position-angle ).
        when others.
          zcx_turtle_problem=>raise( |Lsystem - uncnofigured symbol { symbol }.| ).
      endcase.

      index = index + 1.
    endwhile.

  endmethod.

  method show.
    turtle->show( ).
  endmethod.

  method get_final_value.
    data(instructions) = parameters-initial_state.
    do parameters-num_iterations times.
      loop at parameters-rewrite_rules assigning field-symbol(<rule>).
        replace all occurrences of <rule>-from in instructions
          with <rule>-to.
      endloop.
    enddo.

    result = instructions.
  endmethod.

  method pop_stack.
    position = position_stack[ lines( position_stack ) ].
    delete position_stack index lines( position_stack ).
  endmethod.

  method push_stack.
    append position to position_stack.
  endmethod.

endclass.
