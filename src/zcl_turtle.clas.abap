CLASS zcl_turtle DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF t_pen,
        stroke_color TYPE zcl_turtle_colors=>rgb_hex_color,
        stroke_width TYPE i,
        fill_color   TYPE zcl_turtle_colors=>rgb_hex_color,
        is_up        TYPE abap_bool,
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

    METHODS pen_up
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    METHODS pen_down
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

    METHODS download
      IMPORTING filename TYPE string DEFAULT `abap-turtle.html`.

    METHODS enable_random_colors.
    METHODS disable_random_colors.

    METHODS get_svg RETURNING VALUE(svg) TYPE string.
    METHODS:
      get_position RETURNING VALUE(result) TYPE turtle_position,
      set_position IMPORTING position TYPE turtle_position,
      set_color_scheme IMPORTING color_scheme TYPE zcl_turtle_colors=>rgb_hex_colors.

    DATA: svg          TYPE string READ-ONLY,
          width        TYPE i READ-ONLY,
          height       TYPE i READ-ONLY,
          position     TYPE turtle_position READ-ONLY,
          pen          TYPE t_pen READ-ONLY,
          color_scheme TYPE zcl_turtle_colors=>rgb_hex_colors READ-ONLY.

  PRIVATE SECTION.
    DATA use_random_colors TYPE abap_bool.
    METHODS get_html
      RETURNING VALUE(html) TYPE string.

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

    IF pen-is_up = abap_false.
      me->line(
        x_from = old_position-x
        y_from = old_position-y
        x_to = new_position-x
        y_to = new_position-y ).
    ENDIF.

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

    IF use_random_colors = abap_true.
      pen-stroke_color = zcl_turtle_colors=>get_random_color( me->color_scheme ).
    ENDIF.

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
      html_string = get_html( ) ).

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
     is_up = abap_false
   ).
    me->color_scheme = zcl_turtle_colors=>default_color_scheme.
    me->use_random_colors = abap_true.
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

  METHOD set_color_scheme.
    me->color_scheme = color_scheme.
  ENDMETHOD.

  METHOD download.

    DATA(file_name) = filename.
    DATA(path) = ``.
    DATA(full_path) = ``.

    cl_gui_frontend_services=>file_save_dialog(
      EXPORTING
        default_extension = `html`
        default_file_name = filename
        initial_directory = ``
      CHANGING
        filename = file_name
        path = path
        fullpath = full_path
      EXCEPTIONS
        OTHERS = 1 ).

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    SPLIT me->get_html( ) AT |\r\n| INTO TABLE DATA(lines).
    cl_gui_frontend_services=>gui_download(
      EXPORTING
        filename = file_name
      CHANGING
        data_tab = lines
      EXCEPTIONS OTHERS = 1 ).

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.

  METHOD get_html.
    html = |<html><body><h1>abapTurtle</h1><svg width="{ width }" height="{ height }">{ svg }</svg></body></html>|.
  ENDMETHOD.

  METHOD disable_random_colors.
    me->use_random_colors = abap_false.
  ENDMETHOD.

  METHOD enable_random_colors.
    me->use_random_colors = abap_true.
  ENDMETHOD.

  METHOD pen_down.
    me->pen-is_up = abap_false.
    turtle = me.
  ENDMETHOD.

  METHOD pen_up.
    me->pen-is_up = abap_true.
    turtle = me.
  ENDMETHOD.

ENDCLASS.
