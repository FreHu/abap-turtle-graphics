CLASS zcl_turtle_lsystem DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF lsystem_rewrite_rule,
        from TYPE string,
        to   TYPE string,
      END OF lsystem_rewrite_rule,
      lsystem_rewrite_rules TYPE STANDARD TABLE OF lsystem_rewrite_rule WITH DEFAULT KEY.

    TYPES:
      BEGIN OF params,
        "! Starting symbols
        initial_state  TYPE string,
        "! How many times the rewrite rules will be applied
        num_iterations TYPE i,
        "! For move instructions, how many pixels to move by
        move_distance  TYPE i,
        "! For rotate instructions, how many degrees to rotate by
        rotate_by      TYPE i,
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

    DATA: turtle TYPE REF TO zcl_turtle.
    DATA: parameters TYPE params.
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
      DATA(char) = final_value+index(1).

      CASE char.
        WHEN `F` OR `G` OR `H`.
          turtle->forward( parameters-move_distance ).
        WHEN `+`.
          turtle->right( parameters-rotate_by ).
        WHEN `-`.
          turtle->left( parameters-rotate_by ).
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

ENDCLASS.
