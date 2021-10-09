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
      set_style importing style type string,
      get_html
            returning value(html) type string.

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


    methods line
      importing x_from        type i
                y_from        type i
                x_to          type i
                y_to          type i
      returning value(turtle) type ref to zcl_turtle.

endclass.

class zcl_turtle implementation.

  method create.
    turtle = new zcl_turtle( width = width height = height background_color = background_color title = title ).
  endmethod.


  method forward.

    data(old_position) = position.
    data(new_x) = how_far * cos( zcl_turtle_convert=>degrees_to_radians( old_position-angle ) ).
    data(new_y) = how_far * sin( zcl_turtle_convert=>degrees_to_radians( old_position-angle ) ).

    data(new_position) = value turtle_position(
      x = old_position-x + new_x
      y = old_position-y + new_y
      angle = old_position-angle ).

    if pen-is_up = abap_false.
      me->line(
        x_from = old_position-x
        y_from = old_position-y
        x_to = new_position-x
        y_to = new_position-y ).
    endif.

    me->set_position( new_position ).

    turtle = me.
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

    if use_random_colors = abap_true.
      pen-stroke_color = zcl_turtle_colors=>get_random_color( me->color_scheme ).
    endif.

    append_svg( svg_builder->line( value #(
      x_from = x_from
      y_from = y_from
      x_to = x_to
      y_to = y_to ) ) ).

    turtle = me.
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

  method constructor.
    me->width = width.
    me->height = height.
    me->title = title.
    me->style = style.
    me->color_scheme = zcl_turtle_colors=>default_color_scheme.
    me->use_random_colors = abap_true.
    me->svg_builder = zcl_turtle_svg=>create( me ).

    if background_color is not initial.
      me->set_pen( value #( fill_color = background_color ) ).
      data(side_length) = 100.

      data(points) = value t_points(
        ( x = 0 y = 0 )
        ( x = 0 + width y = 0 )
        ( x = 0 + width y = 0 + height )
        ( x = 0   y = 0 + height )
      ).

      me->append_svg(
        me->svg_builder->polyline( value #( points = points ) )
      ).
    endif.

    me->pen = value #(
     stroke_width = 1
     stroke_color = `#FF0000`
     is_up = abap_false
   ).
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
    turtle = new #(
      width = existing_turtle->width
      height = existing_turtle->height
      title = existing_turtle->title
      style = existing_turtle->style
    ).

    turtle->set_pen( existing_turtle->pen ).
    turtle->set_color_scheme( existing_turtle->color_scheme ).
    turtle->set_position( existing_turtle->position ).
    turtle->set_angle( existing_turtle->position-angle ).
  endmethod.

  method append_svg.
    me->svg = me->svg && svg_to_append.
  endmethod.

  method compose.

    if lines( turtles ) < 1.
      zcx_turtle_problem=>raise( `Not enough turtles to compose anything.` ).
    endif.

    " start where the last one left off
    turtle = zcl_turtle=>from_existing( turtles[ lines( turtles ) ] ).

    " new image size is the largest of composed turtles
    data(new_width) = zcl_turtle_math=>find_max_int(
      value #( for <x> in turtles ( <x>->width ) ) ).

    data(new_height) = zcl_turtle_math=>find_max_int(
      value #( for <x> in turtles ( <x>->height ) ) ).

    turtle->set_height( new_height ).
    turtle->set_width( new_width ).

    data(composed_svg) = reduce string(
      init result = ``
        for <svg> in value stringtab( for <x> in turtles ( <x>->svg ) )
      next result = result && <svg> ).

    turtle->append_svg( composed_svg ).

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
