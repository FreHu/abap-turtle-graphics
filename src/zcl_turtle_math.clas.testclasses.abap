CLASS lcl_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS: todo_rename FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_tests IMPLEMENTATION.

  METHOD todo_rename.
    DATA(values) = VALUE zcl_turtle_math=>numbers_i(
      ( 1 ) ( 2 ) ( 10 ) ( 5 ) ( -4 ) ).

    DATA(result) = zcl_turtle_math=>find_max_int( values ).

    cl_abap_unit_assert=>assert_equals( exp = 10 act = result ).
  ENDMETHOD.

ENDCLASS.
