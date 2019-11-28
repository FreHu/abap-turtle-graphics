class zcl_turtle_lsystem_examples definition
  public final.

  public section.
    class-methods koch_curve.
    class-methods pattern.
    class-methods plant.
    class-methods plant_2.

endclass.

class zcl_turtle_lsystem_examples implementation.

  method koch_curve.

    data(turtle) = zcl_turtle=>new( height = 800 width = 600 title = |Koch curve| ).
    turtle->goto( x = 200 y = 200 ).
    data(parameters) = value zcl_turtle_lsystem=>params(
      initial_state = `F`
      instructions = value #(
        ( symbol = 'F' kind = zcl_turtle_lsystem=>instruction_kind-forward amount = 10 )
        ( symbol = '+' kind = zcl_turtle_lsystem=>instruction_kind-right amount = 90 )
        ( symbol = '-' kind = zcl_turtle_lsystem=>instruction_kind-left amount = 90 )
      )
      num_iterations = 3
      rewrite_rules = value #(
        ( from = `F` to = `F+F-F-F+F` )
      )
    ).

    data(lsystem) = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).

  endmethod.

  method pattern.
    data(turtle) = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 200 y = 200 ).

    data(parameters) = value zcl_turtle_lsystem=>params(
      initial_state = `F-F-F-F`
      instructions = value #(
        ( symbol = 'F' kind = zcl_turtle_lsystem=>instruction_kind-forward amount = 10 )
        ( symbol = '+' kind = zcl_turtle_lsystem=>instruction_kind-right amount = 90 )
        ( symbol = '-' kind = zcl_turtle_lsystem=>instruction_kind-left amount = 90 ) )
      num_iterations = 3
      rewrite_rules = value #(
        ( from = `F` to = `FF-F+F-F-FF` )
       )
    ).

    data(lsystem) = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).

  endmethod.

  method plant.
    data(turtle) = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 300 y = 600 ).
    turtle->set_angle( -90 ).

    data(parameters) = value zcl_turtle_lsystem=>params(
      let distance = 10
          rotation = 25 in
      initial_state = `F`
      instructions = value #(
        ( symbol = `F` kind = zcl_turtle_lsystem=>instruction_kind-forward amount = distance )
        ( symbol = `+` kind = zcl_turtle_lsystem=>instruction_kind-right amount = rotation )
        ( symbol = `-` kind = zcl_turtle_lsystem=>instruction_kind-left amount = rotation )
        ( symbol = `[` kind = zcl_turtle_lsystem=>instruction_kind-stack_push )
        ( symbol = `]` kind = zcl_turtle_lsystem=>instruction_kind-stack_pop )
      )
      num_iterations = 5
      rewrite_rules = value #(
        ( from = `F` to = `F[+F]F[-F][F]` )
       )
    ).

    data(lsystem) = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).
  endmethod.

  method plant_2.
    data(turtle) = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 300 y = 600 ).
    turtle->set_angle( -90 ).

    data(parameters) = value zcl_turtle_lsystem=>params(
      initial_state = `F`
      instructions = value #(
        ( symbol = `F` kind = zcl_turtle_lsystem=>instruction_kind-forward amount = 10 )
        ( symbol = `+` kind = zcl_turtle_lsystem=>instruction_kind-right amount = 21 )
        ( symbol = `-` kind = zcl_turtle_lsystem=>instruction_kind-left amount = 21 )
        ( symbol = `[` kind = zcl_turtle_lsystem=>instruction_kind-stack_push )
        ( symbol = `]` kind = zcl_turtle_lsystem=>instruction_kind-stack_pop )
      )
      num_iterations = 4
      rewrite_rules = value #(
        ( from = `F` to = `FF-[+F+F+F]+[-F-F+F]` )
       )
    ).

    data(lsystem) = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).
  endmethod.

endclass.
