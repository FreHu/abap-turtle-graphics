CLASS zcl_turtle_colors DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    TYPES: rgb_hex_color  TYPE string,
           rgb_hex_colors TYPE STANDARD TABLE OF rgb_hex_color WITH EMPTY KEY.

    CLASS-METHODS class_constructor.
    CLASS-METHODS get_random_color
      IMPORTING colors       TYPE rgb_hex_colors
      RETURNING VALUE(color) TYPE rgb_hex_color.

    CLASS-DATA: default_color_scheme TYPE rgb_hex_colors.
  PRIVATE SECTION.
    CLASS-DATA: random TYPE REF TO cl_abap_random.

ENDCLASS.

CLASS zcl_turtle_colors IMPLEMENTATION.

  METHOD class_constructor.
    default_color_scheme = VALUE #(
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
  ENDMETHOD.

  METHOD get_random_color.
    DATA(random_index) = random->intinrange( low = 1 high = lines( colors ) ).
    color = colors[ random_index ].
  ENDMETHOD.

ENDCLASS.
