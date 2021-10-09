class zcl_turtle definition
  public final
  create private.

  public section.

    constants:
      begin of defaults,
        height type i value 800,
        width  type i value 600,
        title  type string value `abapTurtle`,
      end of defaults.

    types:
      begin of t_pen,
        stroke_color type zcl_turtle_colors=>rgb_hex_color,
        stroke_width type i,
        fill_color   type zcl_turtle_colors=>rgb_hex_color,
        is_up        type abap_bool,
      end of t_pen.

    types:
      begin of t_point,
        x type i,
        y type i,
      end of t_point,
      t_points type standard table of t_point with key table_line.

    types:
      begin of turtle_position,
        x     type i,
        y     type i,
        angle type f,
      end of turtle_position.

    types: multiple_turtles type standard table of ref to zcl_turtle.

    class-methods create
      importing height           type i default defaults-height
                width            type i default defaults-width
                background_color type zcl_turtle_colors=>rgb_hex_color optional
                title            type string default defaults-title
                style            type string optional
      returning value(turtle)    type ref to zcl_turtle.

    "! Creates a new turtle based on an existing instance. The position, angle and pen are preserved.
    "! Does not preserve content.
    class-methods from_existing
      importing existing_turtle type ref to zcl_turtle
      returning value(turtle)   type ref to zcl_turtle.

    "! Merges drawings of multiple turtles into one.
    class-methods compose
      importing turtles       type multiple_turtles
      returning value(turtle) type ref to zcl_turtle.

    methods constructor
      importing height           type i
                width            type i
                background_color type zcl_turtle_colors=>rgb_hex_color optional
                title            type string
                style            type string optional.

    methods right
      importing degrees       type f
      returning value(turtle) type ref to zcl_turtle.

    methods left
      importing degrees       type f
      returning value(turtle) type ref to zcl_turtle.

    methods set_pen
      importing pen           type t_pen
      returning value(turtle) type ref to zcl_turtle.

    methods goto
      importing x             type i
                y             type i
      returning value(turtle) type ref to zcl_turtle.

    methods set_angle
      importing angle type f.

    methods forward
      importing how_far       type i
      returning value(turtle) type ref to zcl_turtle.

    methods back
      importing how_far       type i
      returning value(turtle) type ref to zcl_turtle.

    methods pen_up
      returning value(turtle) type ref to zcl_turtle.

    methods pen_down
      returning value(turtle) type ref to zcl_turtle.

    methods show
      returning value(turtle) type ref to zcl_turtle.

    methods download
      importing filename type string default `abap-turtle.html`.

    methods enable_random_colors.
    methods disable_random_colors.

    methods:
      get_svg returning value(svg) type string,
      append_svg importing svg_to_append  type string.

    methods:
      get_position returning value(result) type turtle_position,
      set_position importing position type turtle_position,
      set_color_scheme importing color_scheme type zcl_turtle_colors=>rgb_hex_colors,
      set_width importing width type i,
      set_height importing height type i,
      set_svg importing svg type string,
      set_style importing style type string.

    data: title        type string read-only,
          svg          type string read-only,
          width        type i read-only,
          height       type i read-only,
          position     type turtle_position read-only,
          pen          type t_pen read-only,
          color_scheme type zcl_turtle_colors=>rgb_hex_colors read-only,
          svg_builder  type ref to zcl_turtle_svg read-only.

  private section.
    data use_random_colors type abap_bool.
    data style type string.

    methods get_html
      returning value(html) type string.
    methods line
      importing x_from        type i
                y_from        type i
                x_to          type i
                y_to          type i
      returning value(turtle) type ref to zcl_turtle.

endclass.

class zcl_turtle implementation.

  method create.
    data temp1 type ref to zcl_turtle.
    create object temp1 type zcl_turtle exporting width = width height = height background_color = background_color title = title.
    turtle = temp1.
  endmethod.

  method forward.

  endmethod.

  method back.
    right( degrees = 180 ).
    forward( how_far ).
    right( degrees = 180 ).
  endmethod.

  method get_svg.
    svg = me->svg.
  endmethod.

  method goto.
    position-x = x.
    position-y = y.
    turtle = me.
  endmethod.

  method left.
    position-angle = position-angle - degrees.
    position-angle = position-angle mod 360.
    turtle = me.
  endmethod.

  method line.
  endmethod.

  method right.
    position-angle = position-angle + degrees.
    position-angle = position-angle mod 360.
    turtle = me.
  endmethod.

  method set_pen.
    me->pen = pen.
    turtle = me.
  endmethod.

  method show.
    cl_abap_browser=>show_html(
      size = cl_abap_browser=>xlarge
      html_string = get_html( ) ).

    turtle = me.
  endmethod.

  method constructor.
  endmethod.

  method get_position.
    result = me->position.
  endmethod.

  method set_position.
    me->position = position.
  endmethod.

  method set_angle.
    me->position-angle = angle.
  endmethod.

  method set_color_scheme.
    me->color_scheme = color_scheme.
  endmethod.

  method download.
  endmethod.

  method get_html.
    html = zcl_turtle_html_parts=>html_document(
      title = me->title
      style = me->style
      svg = |<svg width="{ me->width }" height="{ me->height }">{ me->svg }</svg>| ).
  endmethod.

  method disable_random_colors.
    me->use_random_colors = abap_false.
  endmethod.

  method enable_random_colors.
    me->use_random_colors = abap_true.
  endmethod.

  method pen_down.
    me->pen-is_up = abap_false.
    turtle = me.
  endmethod.

  method pen_up.
    me->pen-is_up = abap_true.
    turtle = me.
  endmethod.

  method from_existing.
  endmethod.

  method append_svg.
    me->svg = me->svg && svg_to_append.
  endmethod.

  method compose.
  endmethod.

  method set_width.
    me->width = width.
  endmethod.

  method set_height.
    me->height = height.
  endmethod.

  method set_svg.
    me->svg = svg.
  endmethod.

  method set_style.
    me->style = style.
  endmethod.

endclass.
