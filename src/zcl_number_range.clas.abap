CLASS zcl_number_range DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    TYPES: number_range TYPE STANDARD TABLE OF i WITH EMPTY KEY.

    "! Returns the list of numbers &lt;min, max).
    "! This method repeats the mistake of Python 2.x and will consume a lot of memory if used with large ranges
    CLASS-METHODS get
      IMPORTING min           TYPE i
                max           TYPE i
      RETURNING VALUE(result) TYPE number_range.

ENDCLASS.

CLASS zcl_number_range IMPLEMENTATION.

  METHOD get.
    DATA(i) = min.
    WHILE i < max.
      APPEND i TO result.
      i = i + 1.
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
