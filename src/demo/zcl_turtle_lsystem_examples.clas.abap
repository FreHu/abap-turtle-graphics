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

    turtleTYPE REF TO zcl_turtle.
    turtleTYPE REF TO zcl_turtle.
    turtleTYPE REF TO zcl_turtle.
    turtleTYPE REF TO zcl_turtle.
    turtleTYPE REF TO zcl_turtle.
    turtleTYPE REF TO zcl_turtle.
    data turtle type ref to zcl_turtle.
    turtle = zcl_turtle=>new( height = 800 width = 600 title = |Koch curve| ).
    turtle->goto( x = 200 y = 200 ).
    data temp1 type zcl_turtle_lsystem=>params.
    temp1-initial_state = `F`.
    data temp2 type zcl_turtle_lsystem=>lsystem_instructions.
    data temp3 like line of temp2.
    temp3-symbol = 'F'.
    temp3-kind = zcl_turtle_lsystem=>instruction_kind-forward.
    temp3-amount = 10.
    append temp3 to temp2.
    temp3-symbol = '+'.
    temp3-kind = zcl_turtle_lsystem=>instruction_kind-right.
    temp3-amount = 90.
    append temp3 to temp2.
    temp3-symbol = '-'.
    temp3-kind = zcl_turtle_lsystem=>instruction_kind-left.
    temp3-amount = 90.
    append temp3 to temp2.
    temp1-instructions = temp2.
    temp1-num_iterations = 3.
    data temp4 type zcl_turtle_lsystem=>lsystem_rewrite_rules.
    data temp5 like line of temp4.
    temp5-from = `F`.
    temp5-to = `F+F-F-F+F`.
    append temp5 to temp4.
    temp1-rewrite_rules = temp4.
    parameters = temp1.
    1.
    parameters = temp1.
    1.
    parameters = temp1.
    1.
    data parameters like temp1.
    parameters = temp1.

    lsystemTYPE REF TO zcl_turtle_lsystem.
    data lsystem type ref to zcl_turtle_lsystem.
    lsystem = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).

  endmethod.

  method pattern.
    data turtle type ref to zcl_turtle.
    turtle = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 200 y = 200 ).

    data temp2 type zcl_turtle_lsystem=>params.
    temp2-initial_state = `F-F-F-F`.
    data temp6 type zcl_turtle_lsystem=>lsystem_instructions.
    data temp7 like line of temp6.
    temp7-symbol = 'F'.
    temp7-kind = zcl_turtle_lsystem=>instruction_kind-forward.
    temp7-amount = 10.
    append temp7 to temp6.
    temp7-symbol = '+'.
    temp7-kind = zcl_turtle_lsystem=>instruction_kind-right.
    temp7-amount = 90.
    append temp7 to temp6.
    temp7-symbol = '-'.
    temp7-kind = zcl_turtle_lsystem=>instruction_kind-left.
    temp7-amount = 90.
    append temp7 to temp6.
    temp2-instructions = temp6.
    temp2-num_iterations = 3.
    data temp8 type zcl_turtle_lsystem=>lsystem_rewrite_rules.
    data temp9 like line of temp8.
    temp9-from = `F`.
    temp9-to = `FF-F+F-F-FF`.
    append temp9 to temp8.
    temp2-rewrite_rules = temp8.
    parameters = temp2.
    2.
    parameters = temp2.
    2.
    parameters = temp2.
    2.
    parameters = temp2.
    2.
    data parameters like temp2.
    parameters = temp2.

    data lsystem type ref to zcl_turtle_lsystem.
    lsystem = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).

  endmethod.

  method plant.
    data turtle type ref to zcl_turtle.
    turtle = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 300 y = 600 ).
    turtle->set_angle( -90 ).

    data temp3 type zcl_turtle_lsystem=>params.
    temp3-initial_state = `F`.
    data temp10 type zcl_turtle_lsystem=>lsystem_instructions.
    data temp11 like line of temp10.
    temp11-symbol = `F`.
    temp11-kind = zcl_turtle_lsystem=>instruction_kind-forward.
    temp11-amount = distance.
    append temp11 to temp10.
    temp11-symbol = `+`.
    temp11-kind = zcl_turtle_lsystem=>instruction_kind-right.
    temp11-amount = rotation.
    append temp11 to temp10.
    temp11-symbol = `-`.
    temp11-kind = zcl_turtle_lsystem=>instruction_kind-left.
    temp11-amount = rotation.
    append temp11 to temp10.
    temp11-symbol = `[`.
    temp11-kind = zcl_turtle_lsystem=>instruction_kind-stack_push.
    append temp11 to temp10.
    temp11-symbol = `]`.
    temp11-kind = zcl_turtle_lsystem=>instruction_kind-stack_pop.
    append temp11 to temp10.
    temp3-instructions = temp10.
    temp3-num_iterations = 5.
    data temp12 type zcl_turtle_lsystem=>lsystem_rewrite_rules.
    data temp13 like line of temp12.
    temp13-from = `F`.
    temp13-to = `F[+F]F[-F][F]`.
    append temp13 to temp12.
    temp3-rewrite_rules = temp12.
    data parameters like temp3.
    parameters = temp3.

    lsystemTYPE REF TO zcl_turtle_lsystem.
    lsystemTYPE REF TO zcl_turtle_lsystem.
    lsystemTYPE REF TO zcl_turtle_lsystem.
    data lsystem type ref to zcl_turtle_lsystem.
    lsystem = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).
  endmethod.

  method plant_2.
    turtleTYPE REF TO zcl_turtle.
    turtleTYPE REF TO zcl_turtle.
    turtleTYPE REF TO zcl_turtle.
    turtleTYPE REF TO zcl_turtle.
    data turtle type ref to zcl_turtle.
    turtle = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 300 y = 600 ).
    turtle->set_angle( -90 ).

    data temp4 type zcl_turtle_lsystem=>params.
    temp4-initial_state = `F`.
    data temp14 type zcl_turtle_lsystem=>lsystem_instructions.
    data temp15 like line of temp14.
    temp15-symbol = `F`.
    temp15-kind = zcl_turtle_lsystem=>instruction_kind-forward.
    temp15-amount = 10.
    append temp15 to temp14.
    temp15-symbol = `+`.
    temp15-kind = zcl_turtle_lsystem=>instruction_kind-right.
    temp15-amount = 21.
    append temp15 to temp14.
    temp15-symbol = `-`.
    temp15-kind = zcl_turtle_lsystem=>instruction_kind-left.
    temp15-amount = 21.
    append temp15 to temp14.
    temp15-symbol = `[`.
    temp15-kind = zcl_turtle_lsystem=>instruction_kind-stack_push.
    append temp15 to temp14.
    temp15-symbol = `]`.
    temp15-kind = zcl_turtle_lsystem=>instruction_kind-stack_pop.
    append temp15 to temp14.
    temp4-instructions = temp14.
    temp4-num_iterations = 4.
    data temp16 type zcl_turtle_lsystem=>lsystem_rewrite_rules.
    data temp17 like line of temp16.
    temp17-from = `F`.
    temp17-to = `FF-[+F+F+F]+[-F-F+F]`.
    append temp17 to temp16.
    temp4-rewrite_rules = temp16.
    parameters = temp4.
    4.
    parameters = temp4.
    4.
    parameters = temp4.
    4.
    data parameters like temp4.
    parameters = temp4.

    lsystemTYPE REF TO zcl_turtle_lsystem.
    data lsystem type ref to zcl_turtle_lsystem.
    lsystem = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).
  endmethod.

endclass.
