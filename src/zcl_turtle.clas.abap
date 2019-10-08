CLASS zcl_turtle DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    CONSTANTS: pi TYPE f VALUE '3.14159265359'.
    TYPES:
      BEGIN OF t_pen,
        stroke_color TYPE string,
        stroke_width TYPE i,
        fill_color   TYPE string,
      END OF t_pen.

    CLASS-METHODS degrees_to_radians
      IMPORTING degrees        TYPE f
      RETURNING VALUE(radians) TYPE f.

    CLASS-METHODS radians_to_degrees
      IMPORTING radians        TYPE f
      RETURNING VALUE(degrees) TYPE f.

    METHODS constructor
      IMPORTING height TYPE i
                width  TYPE i.

    METHODS right
      IMPORTING degrees       TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS left
      IMPORTING degrees       TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS set_pen
      IMPORTING pen           TYPE t_pen
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS goto
      IMPORTING x             TYPE i
                y             TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS forward
      IMPORTING how_far       TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS line
      IMPORTING x_from        TYPE i
                y_from        TYPE i
                x_to          TYPE i
                y_to          TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS circle
      IMPORTING center_x      TYPE i
                center_y      TYPE i
                radius        TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS show.
    METHODS get_svg RETURNING VALUE(svg) TYPE string.
    METHODS polygon
      IMPORTING num_sides     TYPE i
                side_length   TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

  PRIVATE SECTION.

    DATA: svg           TYPE string,
          width         TYPE i,
          height        TYPE i,

          current_x     TYPE i,
          current_y     TYPE i,
          current_angle TYPE i,

          pen           TYPE t_pen.
ENDCLASS.



CLASS ZCL_TURTLE IMPLEMENTATION.


  METHOD circle.
    svg &&= |<circle cx="{ center_x }" cy="{ center_y }" r="{ radius }" |
        && |stroke="{ pen-stroke_color }" stroke-width="{ pen-stroke_width }" fill="{ pen-fill_color }"/>|.
    turtle = me.
  ENDMETHOD.


  METHOD constructor.
    me->height = height.
    me->width = width.
  ENDMETHOD.


  METHOD degrees_to_radians.
    radians = ( degrees * pi ) / 180.
  ENDMETHOD.


  METHOD forward.
    DATA(new_x) = how_far * cos( degrees_to_radians( CONV f( me->current_angle ) ) ).
    DATA(new_y) = how_far * sin( degrees_to_radians( CONV f( me->current_angle ) ) ).

    me->line(
      x_from = current_x
      y_from = current_y
      x_to = current_x + new_x
      y_to = current_y + new_y ).

    me->current_x += new_x.
    me->current_y += new_y.

    turtle = me.
  ENDMETHOD.


  METHOD get_svg.
    svg = me->svg.
  ENDMETHOD.


  METHOD goto.
    me->current_x = x.
    me->current_y = y.
    turtle = me.
  ENDMETHOD.


  METHOD left.
    current_angle -= degrees.
    current_angle = current_angle MOD 360.
    turtle = me.
  ENDMETHOD.


  METHOD line.
    svg &&= |<line x1="{ x_from }" y1="{ y_from }" x2="{ x_to }" y2="{ y_to }"|
        && |stroke="{ pen-stroke_color }" stroke-width="{ pen-stroke_width }"/>|.
    turtle = me.
  ENDMETHOD.


  METHOD polygon.
    DATA(i) = 0.
    WHILE i < num_sides.
      me->forward( side_length ).
      me->right( 360 / num_sides ).

      i += 1.
    ENDWHILE.

    turtle = me.
  ENDMETHOD.


  METHOD radians_to_degrees.
    degrees = radians * ( 180 / pi ).
  ENDMETHOD.


  METHOD right.
    current_angle += degrees.
    current_angle = current_angle MOD 360.
    turtle = me.
  ENDMETHOD.


  METHOD set_pen.
    me->pen = pen.
    turtle = me.
  ENDMETHOD.


  METHOD show.
    cl_abap_browser=>show_html(
      html_string = |<html><body><h1>abapTurtle</h1><svg width="{ width }" height="{ height }">{ svg }</svg></body></html>| ).
  ENDMETHOD.
ENDCLASS.
