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
    default_color_scheme = value #(
      ( `#8a295c` )
      ( `#5bbc6d` )
      ( `#cb72d3` )
      ( `#a8b03f` )
      ( `#6973d8` )
      ( `#c38138` )
      ( `#543788` )
      ( `#768a3c` )
      ( `#ac4595` )
      ( `#47bf9c` )
      ( `#db6697` )
      ( `#5f8dd3` )
      ( `#b64e37` )
      ( `#c287d1` )
      ( `#ba4758` )
    ).

    random = cl_abap_random=>create( seed = 42 ).
  endmethod.

  method get_random_color.
    data(random_index) = random->intinrange( low = 1 high = lines( colors ) ).
    color = colors[ random_index ].
  endmethod.

endclass.
