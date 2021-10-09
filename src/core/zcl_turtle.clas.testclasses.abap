class lcl_tests definition final for testing
  duration short
  risk level harmless.

  private section.
    data: f_cut type ref to zcl_turtle.

    methods: initialization for testing raising cx_static_check,
      goto for testing raising cx_static_check,
      pen_up_down for testing raising cx_static_check,
      forward for testing raising cx_static_check,
      back for testing raising cx_static_check.

endclass.


class lcl_tests implementation.

  method initialization.

    data(turtle) = zcl_turtle=>create( ).

    cl_abap_unit_assert=>assert_equals( exp = zcl_turtle=>defaults-width act = turtle->width ).
    cl_abap_unit_assert=>assert_equals( exp = zcl_turtle=>defaults-height act = turtle->height ).

    cl_abap_unit_assert=>assert_equals( exp = 0 act = turtle->position-angle ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = turtle->position-x ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = turtle->position-y ).

    cl_abap_unit_assert=>assert_equals( exp = abap_false act = turtle->pen-is_up ).

  endmethod.

  method goto.

    data(turtle) = zcl_turtle=>create( ).

    turtle->goto( x = 100 y = 200 ).
    cl_abap_unit_assert=>assert_equals( exp = 100 act = turtle->position-x ).
    cl_abap_unit_assert=>assert_equals( exp = 200 act = turtle->position-y ).

  endmethod.

  method pen_up_down.

    data(turtle) = zcl_turtle=>create( ).

    cl_abap_unit_assert=>assert_equals( exp = abap_false act = turtle->pen-is_up ).

    turtle->pen_up( ).
    cl_abap_unit_assert=>assert_equals( exp = abap_true act = turtle->pen-is_up ).

    turtle->pen_down( ).
    cl_abap_unit_assert=>assert_equals( exp = abap_false act = turtle->pen-is_up ).

  endmethod.

  method forward.

    data(turtle) = zcl_turtle=>create( ).

    turtle->goto( x = 150 y = 0 ).
    turtle->forward( 100 ).

    cl_abap_unit_assert=>assert_equals( exp = 150 + 100 act = turtle->position-x ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = turtle->position-y ).

  endmethod.

  method back.

    data(turtle) = zcl_turtle=>create( ).

    turtle->goto( x = 150 y = 0 ).
    turtle->back( 100 ).

    cl_abap_unit_assert=>assert_equals( exp = 150 - 100 act = turtle->position-x ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = turtle->position-y ).

  endmethod.

endclass.
