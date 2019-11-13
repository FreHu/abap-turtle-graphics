CLASS lcl_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: f_cut TYPE REF TO zcl_turtle.

    METHODS: initialization FOR TESTING RAISING cx_static_check,
      goto FOR TESTING RAISING cx_static_check,
      pen_up_down FOR TESTING RAISING cx_static_check,
      forward FOR TESTING RAISING cx_static_check,
      back FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_tests IMPLEMENTATION.

  METHOD initialization.

    DATA(turtle) = zcl_turtle=>new( ).

    cl_abap_unit_assert=>assert_equals( exp = zcl_turtle=>defaults-width act = turtle->width ).
    cl_abap_unit_assert=>assert_equals( exp = zcl_turtle=>defaults-height act = turtle->height ).

    cl_abap_unit_assert=>assert_equals( exp = 0 act = turtle->position-angle ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = turtle->position-x ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = turtle->position-y ).

    cl_abap_unit_assert=>assert_equals( exp = abap_false act = turtle->pen-is_up ).

  ENDMETHOD.

  METHOD goto.

    DATA(turtle) = zcl_turtle=>new( ).

    turtle->goto( x = 100 y = 200 ).
    cl_abap_unit_assert=>assert_equals( exp = 100 act = turtle->position-x ).
    cl_abap_unit_assert=>assert_equals( exp = 200 act = turtle->position-y ).

  ENDMETHOD.

  METHOD pen_up_down.

    DATA(turtle) = zcl_turtle=>new( ).

    cl_abap_unit_assert=>assert_equals( exp = abap_false act = turtle->pen-is_up ).

    turtle->pen_up( ).
    cl_abap_unit_assert=>assert_equals( exp = abap_true act = turtle->pen-is_up ).

    turtle->pen_down( ).
    cl_abap_unit_assert=>assert_equals( exp = abap_false act = turtle->pen-is_up ).

  ENDMETHOD.

  METHOD forward.

    DATA(turtle) = zcl_turtle=>new( ).

    turtle->goto( x = 150 y = 0 ).
    turtle->forward( 100 ).

    cl_abap_unit_assert=>assert_equals( exp = 150 + 100 act = turtle->position-x ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = turtle->position-y ).

  ENDMETHOD.

  METHOD back.

    DATA(turtle) = zcl_turtle=>new( ).

    turtle->goto( x = 150 y = 0 ).
    turtle->back( 100 ).

    cl_abap_unit_assert=>assert_equals( exp = 150 - 100 act = turtle->position-x ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = turtle->position-y ).

  ENDMETHOD.

ENDCLASS.
