CLASS zcl_turtle_svg DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF line_params,
        x_from TYPE i,
        y_from TYPE i,
        x_to   TYPE i,
        y_to   TYPE i,
      END OF line_params,

      BEGIN OF polygon_params,
        points TYPE zcl_turtle=>t_points,
      END OF polygon_params,
      polyline_params TYPE polygon_params,

      BEGIN OF text_params,
        x    TYPE i,
        y    TYPE i,
        text TYPE string,
      END OF text_params,

      BEGIN OF circle_params,
        center_x TYPE i,
        center_y TYPE i,
        radius   TYPE i,
      END OF circle_params.

    CLASS-METHODS:
      new
        IMPORTING turtle        TYPE REF TO zcl_turtle
        RETURNING VALUE(result) TYPE REF TO zcl_turtle_svg.

    METHODS:
      line
        IMPORTING params          TYPE line_params
        RETURNING VALUE(svg_line) TYPE string,

      polygon
        IMPORTING params             TYPE polygon_params
        RETURNING VALUE(svg_polygon) TYPE string,

      polyline
        IMPORTING params              TYPE polyline_params
        RETURNING VALUE(svg_polyline) TYPE string,

      text
        IMPORTING params          TYPE text_params
        RETURNING VALUE(svg_text) TYPE string,

      circle
        IMPORTING params            TYPE circle_params
        RETURNING VALUE(svg_circle) TYPE string.

    DATA: turtle TYPE REF TO zcl_turtle READ-ONLY.
ENDCLASS.



CLASS zcl_turtle_svg IMPLEMENTATION.

  METHOD new.
    result = NEW #( ).
    result->turtle = turtle.
  ENDMETHOD.

  METHOD line.
    svg_line = |<line x1="{ params-x_from }" y1="{ params-y_from }" x2="{ params-x_to }" y2="{ params-y_to }" |
      && |stroke="{ turtle->pen-stroke_color }" stroke-width="{ turtle->pen-stroke_width }"/>|.
  ENDMETHOD.

  METHOD polygon.
    DATA(point_data) = REDUCE string(
      INIT res = ||
      FOR point IN params-points
      NEXT res = res && |{ point-x },{ point-y } | ).

    svg_polygon = |<polygon points="{ point_data }"|
      && | stroke="{ turtle->pen-stroke_color }"|
      && | stroke-width="{ turtle->pen-stroke_width }" fill="{ turtle->pen-fill_color }" />|.

  ENDMETHOD.

  METHOD polyline.
    DATA(point_data) = REDUCE string(
      INIT res = ||
      FOR point IN params-points
      NEXT res = res && |{ point-x },{ point-y } | ).

    svg_polyline = |<polyline points="{ point_data }"|
      && |stroke="{ turtle->pen-stroke_color }" |
      && |stroke-width="{ turtle->pen-stroke_width }" fill="{ turtle->pen-fill_color }" />|.

  ENDMETHOD.

  METHOD circle.
    svg_circle = |<circle cx="{ params-center_x }" cy="{ params-center_y }" r="{ params-radius }" |
        && |stroke="{ turtle->pen-stroke_color }" |
        && |stroke-width="{ turtle->pen-stroke_width }" fill="{ turtle->pen-fill_color }"/>|.
  ENDMETHOD.

  METHOD text.
    svg_text = |<text x="{ params-x }" y="{ params-y }">{ params-text }</text>|.
  ENDMETHOD.

ENDCLASS.
