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

    class-methods new
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

  method new.
    data temp1 type ref to zcl_turtle.
    create object temp1 type zcl_turtle exporting width = width height = height background_color = background_color title = title.
    turtle = temp1.
  endmethod.


  method forward.

    old_position = position.
    n.
    old_position = position.
    n.
    old_position = position.
    n.
    data old_position like position.
    old_position = position.
    new_xTYPE f.
    data new_x type f.
    new_x = how_far * cos( zcl_turtle_convert=>degrees_to_radians( old_position-angle ) ).
    new_yTYPE f.
    data new_y type f.
    new_y = how_far * sin( zcl_turtle_convert=>degrees_to_radians( old_position-angle ) ).

    data temp2 type turtle_position.
    temp2-x = old_position-x + new_x.
    temp2-y = old_position-y + new_y.
    temp2-angle = old_position-angle.
    data new_position like temp2.
    new_position = temp2.

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

  method show.
    cl_abap_browser=>show_html(
      size = cl_abap_browser=>xlarge
      html_string = get_html( ) ).

    turtle = me.
  endmethod.

  method constructor.
    me->width = width.
    me->height = height.
    me->title = title.
    me->style = style.
    me->color_scheme = zcl_turtle_colors=>default_color_scheme.
    me->use_random_colors = abap_true.
    me->svg_builder = zcl_turtle_svg=>new( me ).

    if background_color is not initial.
      data temp3 type zcl_turtle=>t_pen.
      temp3-fill_color = background_color.
      me->set_pen( temp3 ).
      side_lengthTYPE i.
      data side_length type i.
      side_length = 100.

      data temp4 type t_points.
      data temp5 like line of temp4.
      temp5-x = 0.
      temp5-y = 0.
      append temp5 to temp4.
      temp5-x = 0 + width.
      temp5-y = 0.
      append temp5 to temp4.
      temp5-x = 0 + width.
      temp5-y = 0 + height.
      append temp5 to temp4.
      temp5-x = 0.
      temp5-y = 0 + height.
      append temp5 to temp4.
      points = temp4.
      4.
      data points like temp4.
      points = temp4.

      me->append_svg(
        me->svg_builder->polyline( value #( points = points ) )
      ).
    endif.

    data temp6 type zcl_turtle=>t_pen.
    temp6-stroke_width = 1.
    temp6-stroke_color = `#FF0000`.
    temp6-is_up = abap_false.
    me->pen = temp6.
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

    data file_name like filename.
    file_name = filename.
    pathTYPE string.
    data path type string.
    path = ``.
    full_pathTYPE string.
    data full_path type string.
    full_path = ``.

    cl_gui_frontend_services=>file_save_dialog(
      exporting
        default_extension = `html`
        default_file_name = filename
        initial_directory = ``
      changing
        filename = file_name
        path = path
        fullpath = full_path
      exceptions
        others = 1 ).

    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

    data lines type standard table of string with default key.
    split me->get_html( ) at |\r\n| into table lines.
    cl_gui_frontend_services=>gui_download(
      exporting
        filename = file_name
      changing
        data_tab = lines
      exceptions others = 1 ).

    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
        with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

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
    data temp7 type ref to undefined.
    create object temp7 exporting width = existing_turtle->width height = existing_turtle->height title = existing_turtle->title style = existing_turtle->style.
    turtle = temp7.

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
    data temp8 like line of turtles.
    read table turtles index lines( turtles ) into temp8.
    if sy-subrc <> 0.
      raise exception type cx_sy_itab_line_not_found.
    endif.
    turtle = zcl_turtle=>from_existing( temp8 ).

    " new image size is the largest of composed turtles
    data temp9 type zcl_turtle_math=>numbers_i.
    append <x>->width to temp9.
    data new_width type i.
    new_width = zcl_turtle_math=>find_max_int(
      temp9 ).

    data temp11 type zcl_turtle_math=>numbers_i.
    append <x>->height to temp11.
    new_heightTYPE i.
    data new_height type i.
    new_height = zcl_turtle_math=>find_max_int(
      temp11 ).

    turtle->set_height( new_height ).
    turtle->set_width( new_width ).

    data temp13 type stringtab.
    append <x>->svg to temp13.
    composed_svgTYPE string.
    composed_svgTYPE string.
    data composed_svg type string.
    composed_svg = reduce string(
      init result = ``
        for <svg> in temp13
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
