CLASS zcl_turtle_lsystem_examples DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    CLASS-METHODS koch_curve.
    CLASS-METHODS pattern.

ENDCLASS.



CLASS zcl_turtle_lsystem_examples IMPLEMENTATION.

  METHOD koch_curve.

    DATA(turtle) = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 200 y = 200 ).
    DATA(parameters) = VALUE zcl_turtle_lsystem=>params(
      initial_state = `F`
      move_distance = 10
      rotate_by = 90
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
      move_distance = 10
      rotate_by = 90
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

ENDCLASS.
