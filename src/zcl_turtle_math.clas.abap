CLASS zcl_turtle_math DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: numbers_i TYPE STANDARD TABLE OF i WITH DEFAULT KEY.

    CLASS-METHODS: find_max_int
      IMPORTING numbers       TYPE numbers_i
      RETURNING VALUE(result) TYPE i.


ENDCLASS.



CLASS zcl_turtle_math IMPLEMENTATION.

  METHOD find_max_int.
    DATA(max) = numbers[ 1 ].
    LOOP AT numbers ASSIGNING FIELD-SYMBOL(<num>) FROM 2.
      IF <num> > max.
        max = <num>.
      ENDIF.
    ENDLOOP.

    result = max.
  ENDMETHOD.

ENDCLASS.
