class zcl_turtle_math definition
  public
  final
  create public .

  public section.
    types: numbers_i type standard table of i with key table_line.

    class-methods: find_max_int
      importing numbers       type numbers_i
      returning value(result) type i.


endclass.


class zcl_turtle_math implementation.

  method find_max_int.
    data temp1 like line of numbers.
    read table numbers index 1 into temp1.
    if sy-subrc <> 0.
      raise exception type cx_sy_itab_line_not_found.
    endif.
    data max like temp1.
    data temp2 like line of numbers.
    read table numbers index 1 into temp2.
    if sy-subrc <> 0.
      raise exception type cx_sy_itab_line_not_found.
    endif.
    max = temp2.
    field-symbols <num> like line of numbers.
    loop at numbers assigning <num> from 2.
      if <num> > max.
        max = <num>.
      endif.
    endloop.

    result = max.
  endmethod.

endclass.
