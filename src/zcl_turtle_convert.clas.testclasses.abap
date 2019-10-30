CLASS lcl_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: f_cut TYPE REF TO zcl_turtle_convert.

    METHODS:
      setup,
      degrees_to_radians FOR TESTING RAISING cx_static_check,
      radians_to_degrees FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_tests IMPLEMENTATION.

  METHOD setup.
    f_cut = NEW #( ).
  ENDMETHOD.

  METHOD degrees_to_radians.
    DATA(result) = zcl_turtle_convert=>degrees_to_radians(
      degrees = 180 ).

    cl_abap_unit_assert=>assert_equals( exp = zcl_turtle_convert=>pi act = result tol = `0.000000000000001` ).
  ENDMETHOD.

  METHOD radians_to_degrees.
    DATA(result) = zcl_turtle_convert=>radians_to_degrees(
      radians = 2 * zcl_turtle_convert=>pi ).

    cl_abap_unit_assert=>assert_equals( exp = 360 act = result ).
  ENDMETHOD.

ENDCLASS.
