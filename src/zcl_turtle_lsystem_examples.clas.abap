CLASS zcl_turtle_lsystem_examples DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    CLASS-METHODS koch_curve.
    CLASS-METHODS pattern.
    CLASS-METHODS plant.
    CLASS-METHODS plant_2.

ENDCLASS.

CLASS zcl_turtle_lsystem_examples IMPLEMENTATION.

  METHOD koch_curve.

    DATA(turtle) = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 200 y = 200 ).
    DATA(parameters) = VALUE zcl_turtle_lsystem=>params(
      initial_state = `F`
      instructions = VALUE #(
        ( symbol = 'F' kind = zcl_turtle_lsystem=>instruction_kind-forward amount = 10 )
        ( symbol = '+' kind = zcl_turtle_lsystem=>instruction_kind-right amount = 90 )
        ( symbol = '-' kind = zcl_turtle_lsystem=>instruction_kind-left amount = 90 )
      )
      num_iterations = 3
      rewrite_rules = VALUE #(
        ( from = `F` to = `F+F-F-F+F` )
      )
    ).

    DATA(lsystem) = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).

  ENDMETHOD.

  METHOD pattern.
    DATA(turtle) = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 200 y = 200 ).

    DATA(parameters) = VALUE zcl_turtle_lsystem=>params(
      initial_state = `F-F-F-F`
      instructions = VALUE #(
        ( symbol = 'F' kind = zcl_turtle_lsystem=>instruction_kind-forward amount = 10 )
        ( symbol = '+' kind = zcl_turtle_lsystem=>instruction_kind-right amount = 90 )
        ( symbol = '-' kind = zcl_turtle_lsystem=>instruction_kind-left amount = 90 ) )
      num_iterations = 3
      rewrite_rules = VALUE #(
        ( from = `F` to = `FF-F+F-F-FF` )
       )
    ).

    DATA(lsystem) = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).

  ENDMETHOD.

  METHOD plant.
    DATA(turtle) = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 300 y = 600 ).
    turtle->set_angle( -90 ).

    DATA(parameters) = VALUE zcl_turtle_lsystem=>params(
      initial_state = `F`
      instructions = VALUE #(
        ( symbol = `F` kind = zcl_turtle_lsystem=>instruction_kind-forward amount = 10 )
        ( symbol = `+` kind = zcl_turtle_lsystem=>instruction_kind-right amount = 25 )
        ( symbol = `-` kind = zcl_turtle_lsystem=>instruction_kind-left amount = 25 )
        ( symbol = `[` kind = zcl_turtle_lsystem=>instruction_kind-stack_push )
        ( symbol = `]` kind = zcl_turtle_lsystem=>instruction_kind-stack_pop )
      )
      num_iterations = 5
      rewrite_rules = VALUE #(
        ( from = `F` to = `F[+F]F[-F][F]` )
       )
    ).

    DATA(lsystem) = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).
  ENDMETHOD.

  METHOD plant_2.
    DATA(turtle) = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 300 y = 600 ).
    turtle->set_angle( -90 ).

    DATA(parameters) = VALUE zcl_turtle_lsystem=>params(
      initial_state = `F`
      instructions = VALUE #(
        ( symbol = `F` kind = zcl_turtle_lsystem=>instruction_kind-forward amount = 10 )
        ( symbol = `+` kind = zcl_turtle_lsystem=>instruction_kind-right amount = 21 )
        ( symbol = `-` kind = zcl_turtle_lsystem=>instruction_kind-left amount = 21 )
        ( symbol = `[` kind = zcl_turtle_lsystem=>instruction_kind-stack_push )
        ( symbol = `]` kind = zcl_turtle_lsystem=>instruction_kind-stack_pop )
        )
      num_iterations = 4
      rewrite_rules = VALUE #(
        ( from = `F` to = `FF-[+F+F+F]+[-F-F+F]` )
       )
    ).

    DATA(lsystem) = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).
  ENDMETHOD.

ENDCLASS.
