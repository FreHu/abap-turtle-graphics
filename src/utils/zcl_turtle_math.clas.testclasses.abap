class lcl_tests definition final for testing
  duration short
  risk level harmless.

  private section.
    methods: todo_rename for testing raising cx_static_check.

endclass.


class lcl_tests implementation.

  method todo_rename.
    data temp1 type zcl_turtle_math=>numbers_i.
    append 1 to temp1.
    append 2 to temp1.
    append 10 to temp1.
    append 5 to temp1.
    append -4 to temp1.
    data values like temp1.
    values = temp1.

    data result type i.
    result = zcl_turtle_math=>find_max_int( values ).

    cl_abap_unit_assert=>assert_equals( exp = 10 act = result ).
  endmethod.

endclass.
