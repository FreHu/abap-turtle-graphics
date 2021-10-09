class lcl_tests definition final for testing
  duration short
  risk level harmless.

  private section.
    data: f_cut type ref to zcl_turtle_convert.

    methods:
      setup,
      degrees_to_radians for testing raising cx_static_check,
      radians_to_degrees for testing raising cx_static_check.

endclass.


class lcl_tests implementation.

  method setup.
    data temp1 type ref to undefined.
    create object temp1.
    f_cut = temp1.
  endmethod.

  method degrees_to_radians.
    data result type f.
    result = zcl_turtle_convert=>degrees_to_radians(
      degrees = 180 ).

    cl_abap_unit_assert=>assert_equals( exp = zcl_turtle_convert=>pi act = result tol = `0.000000000000001` ).
  endmethod.

  method radians_to_degrees.
    data result type f.
    result = zcl_turtle_convert=>radians_to_degrees(
      radians = 2 * zcl_turtle_convert=>pi ).

    cl_abap_unit_assert=>assert_equals( exp = 360 act = result ).
  endmethod.

endclass.
