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

    TYPES:
      BEGIN OF turtle_position,
        x     TYPE i,
        y     TYPE i,
        angle TYPE f,
      END OF turtle_position.

    CLASS-METHODS new
      IMPORTING height        TYPE i
                width         TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS constructor
      IMPORTING height TYPE i
                width  TYPE i.

    METHODS right
      IMPORTING degrees       TYPE f
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS left
      IMPORTING degrees       TYPE f
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS set_pen
      IMPORTING pen           TYPE t_pen
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS goto
      IMPORTING x             TYPE i
                y             TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS set_angle
      IMPORTING angle TYPE f.

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
    METHODS: get_position RETURNING VALUE(result) TYPE turtle_position,
      set_position IMPORTING position TYPE turtle_position.

    DATA: svg      TYPE string READ-ONLY,
          width    TYPE i READ-ONLY,
          height   TYPE i READ-ONLY,
          position TYPE turtle_position READ-ONLY,
          pen      TYPE t_pen READ-ONLY.

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

    DATA(old_position) = position.
    DATA(new_x) = how_far * cos( zcl_turtle_convert=>degrees_to_radians( old_position-angle ) ).
    DATA(new_y) = how_far * sin( zcl_turtle_convert=>degrees_to_radians( old_position-angle ) ).

    DATA(new_position) = VALUE turtle_position(
      x = old_position-x + new_x
      y = old_position-y + new_y
      angle = old_position-angle ).

    me->line(
      x_from = old_position-x
      y_from = old_position-y
      x_to = new_position-x
      y_to = new_position-y ).

    me->set_position( new_position ).

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
    position-x = x.
    position-y = y.
    turtle = me.
  ENDMETHOD.

  METHOD left.
    position-angle = position-angle - degrees.
    position-angle = position-angle MOD 360.
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
    position-angle = position-angle + degrees.
    position-angle = position-angle MOD 360.
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
    me->svg = svg && |<text x="{ position-x }" y="{ position-y }">{ text }</text>|.
  ENDMETHOD.

  METHOD get_position.
    result = me->position.
  ENDMETHOD.

  METHOD set_position.
    me->position = position.
  ENDMETHOD.

  METHOD set_angle.
    me->position-angle = angle.
  ENDMETHOD.

ENDCLASS.
