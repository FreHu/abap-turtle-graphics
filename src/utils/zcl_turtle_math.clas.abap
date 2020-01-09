class zcl_turtle_math definition
  public
  final
  create public .

  public section.
    types: numbers_i type standard table of i with default key.

    class-methods: find_max_int
      importing numbers       type numbers_i
      returning value(result) type i.


endclass.


class zcl_turtle_math implementation.

  method find_max_int.
    data(max) = numbers[ 1 ].
    loop at numbers assigning field-symbol(<num>) from 2.
      if <num> > max.
        max = <num>.
      endif.
    endloop.

    result = max.
  endmethod.

endclass.
