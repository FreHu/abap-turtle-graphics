CLASS zcl_turtle DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    TYPES: rgb_hex_color TYPE c LENGTH 7.
    TYPES:
      BEGIN OF t_pen,
        stroke_color TYPE rgb_hex_color,
        stroke_width TYPE i,
        fill_color   TYPE rgb_hex_color,
      END OF t_pen.

    TYPES:
      BEGIN OF t_point,
        x TYPE i,
        y TYPE i,
      END OF t_point,
      t_points TYPE STANDARD TABLE OF t_point WITH DEFAULT KEY.

    CLASS-METHODS new
      IMPORTING height        TYPE i
                width         TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

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

    METHODS back
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

    METHODS polygon
      IMPORTING points        TYPE t_points
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS polyline
      IMPORTING points        TYPE t_points
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS text
      IMPORTING text TYPE string.

    METHODS show
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS get_svg RETURNING VALUE(svg) TYPE string.

    DATA: svg           TYPE string READ-ONLY,
          width         TYPE i READ-ONLY,
          height        TYPE i READ-ONLY,

          current_x     TYPE i READ-ONLY,
          current_y     TYPE i READ-ONLY,
          current_angle TYPE i READ-ONLY,

          pen           TYPE t_pen READ-ONLY.

ENDCLASS.

CLASS zcl_turtle IMPLEMENTATION.

  METHOD circle.
    svg = svg && |<circle cx="{ center_x }" cy="{ center_y }" r="{ radius }" |
        && |stroke="{ pen-stroke_color }" stroke-width="{ pen-stroke_width }" fill="{ pen-fill_color }"/>|.
    turtle = me.
  ENDMETHOD.

  METHOD new.
    turtle = NEW zcl_turtle( width = width height = height ).
  ENDMETHOD.


  METHOD forward.
    DATA(new_x) = how_far * cos( zcl_turtle_convert=>degrees_to_radians( CONV f( current_angle ) ) ).
    DATA(new_y) = how_far * sin( zcl_turtle_convert=>degrees_to_radians( CONV f( current_angle ) ) ).

    me->line(
      x_from = current_x
      y_from = current_y
      x_to = current_x + new_x
      y_to = current_y + new_y ).

    me->current_x = current_x + new_x.
    me->current_y = current_y + new_y.

    turtle = me.
  ENDMETHOD.

  METHOD back.
    right( degrees = 180 ).
    forward( how_far ).
    right( degrees = 180 ).
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
    current_angle = current_angle - degrees.
    current_angle = current_angle MOD 360.
    turtle = me.
  ENDMETHOD.

  METHOD line.
    svg = svg && |<line x1="{ x_from }" y1="{ y_from }" x2="{ x_to }" y2="{ y_to }"|
        && |stroke="{ pen-stroke_color }" stroke-width="{ pen-stroke_width }"/>|.

    turtle = me.
  ENDMETHOD.

  METHOD polygon.
    DATA(point_data) = REDUCE string(
    INIT res = ||
    FOR point IN points
    NEXT res = res && |{ point-x },{ point-y } | ).

    svg = svg && |<polygon points="{ point_data }"|
                  && | stroke="{ pen-stroke_color }" stroke-width="{ pen-stroke_width }" fill="{ pen-fill_color }" />|.

    turtle = me.
  ENDMETHOD.

  METHOD right.
    current_angle = current_angle + degrees.
    current_angle = current_angle MOD 360.
    turtle = me.
  ENDMETHOD.

  METHOD set_pen.
    me->pen = pen.
    turtle = me.
  ENDMETHOD.

  METHOD show.
    cl_abap_browser=>show_html(
      size = cl_abap_browser=>xlarge
      html_string =
        |<html><body><h1>abapTurtle</h1><svg width="{ width }" height="{ height }">{ svg }</svg></body></html>| ).

    turtle = me.
  ENDMETHOD.

  METHOD polyline.
    DATA(point_data) = REDUCE string(
      INIT res = ||
      FOR point IN points
      NEXT res = res && |{ point-x },{ point-y } | ).

    svg = svg && |<polyline points="{ point_data }"|
                  && | stroke="{ pen-stroke_color }" stroke-width="{ pen-stroke_width }" fill="{ pen-fill_color }" />|.

    turtle = me.
  ENDMETHOD.

  METHOD constructor.
    me->width = width.
    me->height = height.
    me->pen = VALUE #(
     stroke_width = 1
     stroke_color = `#FF0000`
   ).
  ENDMETHOD.

  METHOD text.
    me->svg = svg && |<text x="{ current_x }" y="{ current_y }">{ text }</text>|.
  ENDMETHOD.

ENDCLASS.
