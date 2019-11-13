CLASS zcl_turtle_lsystem DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF lsystem_rewrite_rule,
        "! Original string
        from TYPE string,
        "! New string
        to   TYPE string,
      END OF lsystem_rewrite_rule,
      lsystem_rewrite_rules TYPE STANDARD TABLE OF lsystem_rewrite_rule WITH DEFAULT KEY.

    TYPES: lsystem_instruction_kind TYPE string.
    CONSTANTS:
      BEGIN OF instruction_kind,
        "! Doesn't do anything. Can be used for helper symbols.
        noop       TYPE lsystem_instruction_kind VALUE `noop`,
        "! Go forward by 'amount' pixels
        forward    TYPE lsystem_instruction_kind VALUE `forwrad`,
        "! Go back by 'amount' pixels
        back       TYPE lsystem_instruction_kind VALUE `back`,
        "! Turn left by 'amount' degrees
        left       TYPE lsystem_instruction_kind VALUE `left`,
        "! Turn right by 'amount' degrees
        right      TYPE lsystem_instruction_kind VALUE `right`,
        "! Push position on the stack
        stack_push TYPE lsystem_instruction_kind VALUE `stack_push`,
        "! Pop position from the stack
        stack_pop  TYPE lsystem_instruction_kind VALUE `stack_pop`,
      END OF instruction_kind.

    TYPES:
      BEGIN OF lsystem_instruction,
        symbol TYPE c1,
        kind   TYPE lsystem_instruction_kind,
        "! Distance or angle (if the operation requires it)
        amount TYPE i,
      END OF lsystem_instruction,
      lsystem_instructions TYPE HASHED TABLE OF lsystem_instruction WITH UNIQUE KEY symbol.

    TYPES:
      BEGIN OF params,
        "! Starting symbols
        initial_state  TYPE string,
        "! How many times the rewrite rules will be applied
        num_iterations TYPE i,
        instructions   TYPE lsystem_instructions,
        "! A list of rewrite patterns which will be applied each iteration in order.
        "! E.g. initial state F with rule F -> FG and 3 iterations
        "! will produce FG, FGG, FGGG in each iteration respectively.
        "! Currently allows up to 3 variables F,G,H
        rewrite_rules  TYPE lsystem_rewrite_rules,
      END OF params.

    CLASS-METHODS new
      IMPORTING turtle        TYPE REF TO zcl_turtle
                parameters    TYPE params
      RETURNING VALUE(result) TYPE REF TO zcl_turtle_lsystem.

    METHODS execute.
    METHODS show.

  PRIVATE SECTION.
    METHODS get_final_value
      RETURNING VALUE(result) TYPE string.

    TYPES: t_position_stack TYPE STANDARD TABLE OF zcl_turtle=>turtle_position WITH EMPTY KEY.
    METHODS:
      push_stack IMPORTING position TYPE zcl_turtle=>turtle_position,
      pop_stack RETURNING VALUE(position) TYPE zcl_turtle=>turtle_position.

    DATA: turtle TYPE REF TO zcl_turtle.
    DATA: parameters TYPE params.
    DATA: position_stack TYPE t_position_stack.
ENDCLASS.

CLASS zcl_turtle_lsystem IMPLEMENTATION.

  METHOD new.
    result = NEW #( ).
    result->turtle = turtle.
    result->parameters = parameters.
  ENDMETHOD.

  METHOD execute.
    DATA(final_value) = get_final_value( ).

    DATA(index) = 0.
    WHILE index < strlen( final_value ).
      DATA(symbol) = final_value+index(1).
      DATA(rule) = VALUE #( parameters-instructions[ symbol = symbol ] OPTIONAL ).
      CASE rule-kind.
        WHEN instruction_kind-noop.
          CONTINUE.
        WHEN instruction_kind-forward.
          turtle->forward( rule-amount ).
        WHEN instruction_kind-back.
          turtle->back( rule-amount ).
        WHEN instruction_kind-left.
          turtle->right( CONV f( rule-amount ) ).
        WHEN instruction_kind-right.
          turtle->left( CONV f( rule-amount ) ).
        WHEN instruction_kind-stack_push.
          push_stack( turtle->position ).
        WHEN instruction_kind-stack_pop.
          DATA(position) = pop_stack( ).
          turtle->goto( x = position-x y = position-y ).
          turtle->set_angle( position-angle ).
        WHEN OTHERS.
          zcx_turtle_problem=>raise( |Lsystem - uncnofigured symbol { symbol }.| ).
      ENDCASE.

      index = index + 1.
    ENDWHILE.

  ENDMETHOD.

  METHOD show.
    turtle->show( ).
  ENDMETHOD.

  METHOD get_final_value.
    DATA(instructions) = parameters-initial_state.
    DO parameters-num_iterations TIMES.
      LOOP AT parameters-rewrite_rules ASSIGNING FIELD-SYMBOL(<rule>).
        REPLACE ALL OCCURRENCES OF <rule>-from IN instructions
          WITH <rule>-to.
      ENDLOOP.
    ENDDO.

    result = instructions.
  ENDMETHOD.

  METHOD pop_stack.
    position = position_stack[ lines( position_stack ) ].
    DELETE position_stack INDEX lines( position_stack ).
  ENDMETHOD.

  METHOD push_stack.
    APPEND position TO position_stack.
  ENDMETHOD.

ENDCLASS.
