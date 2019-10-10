CLASS zcl_turtle_convert DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    CONSTANTS: pi TYPE f VALUE '3.14159265359'.

    CLASS-METHODS degrees_to_radians
      IMPORTING degrees        TYPE f
      RETURNING VALUE(radians) TYPE f.

    CLASS-METHODS radians_to_degrees
      IMPORTING radians        TYPE f
      RETURNING VALUE(degrees) TYPE f.

ENDCLASS.



CLASS zcl_turtle_convert IMPLEMENTATION.

  METHOD degrees_to_radians.
    radians = ( degrees * pi ) / 180.
  ENDMETHOD.

  METHOD radians_to_degrees.
    degrees = radians * ( 180 / pi ).
  ENDMETHOD.

ENDCLASS.
