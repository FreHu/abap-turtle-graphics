class zcl_turtle_colors definition
  public
  final
  create public .

  public section.
    types: rgb_hex_color  type string,
           rgb_hex_colors type standard table of rgb_hex_color with default key.

    class-methods class_constructor.
    class-methods get_random_color
      importing colors       type rgb_hex_colors
      returning value(color) type rgb_hex_color.

    class-data: default_color_scheme type rgb_hex_colors.
  private section.
    class-data: random type ref to cl_abap_random.

endclass.


class zcl_turtle_colors implementation.

  method class_constructor.
    data temp1 type zcl_turtle_colors=>rgb_hex_colors.
    append `#8a295c` to temp1.
    append `#5bbc6d` to temp1.
    append `#cb72d3` to temp1.
    append `#a8b03f` to temp1.
    append `#6973d8` to temp1.
    append `#c38138` to temp1.
    append `#543788` to temp1.
    append `#768a3c` to temp1.
    append `#ac4595` to temp1.
    append `#47bf9c` to temp1.
    append `#db6697` to temp1.
    append `#5f8dd3` to temp1.
    append `#b64e37` to temp1.
    append `#c287d1` to temp1.
    append `#ba4758` to temp1.
    default_color_scheme = temp1.

    random = cl_abap_random=>create( seed = 42 ).
  endmethod.

  method get_random_color.
    data random_index type i.
    random_index = random->intinrange( low = 1 high = lines( colors ) ).
    data temp17 like line of colors.
    read table colors index random_index into temp17.
    if sy-subrc <> 0.
      raise exception type cx_sy_itab_line_not_found.
    endif.
    color = temp17.
  endmethod.

endclass.
