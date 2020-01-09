class lcl_tests definition final for testing
  duration short
  risk level harmless.

  private section.
    methods: todo_rename for testing raising cx_static_check.

endclass.


class lcl_tests implementation.

  method todo_rename.
    data(values) = value zcl_turtle_math=>numbers_i(
      ( 1 ) ( 2 ) ( 10 ) ( 5 ) ( -4 ) ).

    data(result) = zcl_turtle_math=>find_max_int( values ).

    cl_abap_unit_assert=>assert_equals( exp = 10 act = result ).
  endmethod.

endclass.
