class zcl_turtle_convert definition
  public final.

  public section.
    constants: pi type f value '3.14159265359'.

    class-methods degrees_to_radians
      importing degrees        type f
      returning value(radians) type f.

    class-methods radians_to_degrees
      importing radians        type f
      returning value(degrees) type f.

endclass.

class zcl_turtle_convert implementation.

  method degrees_to_radians.
    radians = ( degrees * pi ) / 180.
  endmethod.

  method radians_to_degrees.
    degrees = radians * ( 180 / pi ).
  endmethod.

endclass.
