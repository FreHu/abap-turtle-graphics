class zcl_number_range definition
  public final.

  public section.
    types: number_range type standard table of i with default key.

    "! Returns the list of numbers &lt;min, max).
    "! This method repeats the mistake of Python 2.x and will consume a lot of memory if used with large ranges
    class-methods get
      importing min           type i
                max           type i
      returning value(result) type number_range.

endclass.

class zcl_number_range implementation.

  method get.
    data i like min.
    i = min.
    while i < max.
      append i to result.
      i = i + 1.
    endwhile.
  endmethod.

endclass.
