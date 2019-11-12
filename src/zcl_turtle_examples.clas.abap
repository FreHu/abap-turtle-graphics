CLASS zcl_turtle_examples DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    CLASS-METHODS polygon_flower
      IMPORTING polygons      TYPE i
                polygon_sides TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    CLASS-METHODS filled_square
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

    CLASS-METHODS polygon_using_lines
      IMPORTING num_sides     TYPE i
                side_length   TYPE i
      RETURNING VALUE(turtle) TYPE REF TO zcl_turtle.

ENDCLASS.

CLASS zcl_turtle_examples IMPLEMENTATION.

  METHOD polygon_flower.
    turtle = zcl_turtle=>new( height = 800 width = 800 ).

    turtle->append_svg( turtle->svg_builder->text( VALUE #(
      text = |Polygons:{ polygons } Sides: { polygon_sides }| ) ) ).

    turtle->goto( x = 200 y = 200 ).
    turtle->set_pen( VALUE #(
            stroke_color = `#FF00FF`
            stroke_width = 2 ) ).

    DATA(current_polygon) = 0.
    WHILE current_polygon < polygons.

      " draw a regular polygon
      DATA(current_polygon_side) = 0.
      DATA(side_length) = 50.
      WHILE current_polygon_side < polygon_sides.
        turtle->forward( side_length ).
        turtle->right( 360 / polygon_sides ).
        current_polygon_side = current_polygon_side + 1.
      ENDWHILE.

      " rotate before painting next polygon
      turtle->right( 360 / polygons ).

      current_polygon = current_polygon + 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD filled_square.
    turtle = zcl_turtle=>new( height = 800 width = 800 ).
    turtle->goto( x = 200 y = 200 ).

    turtle->set_pen( VALUE #(
            fill_color = `#FF0000`
            stroke_color = `#FF00FF`
            stroke_width = 2 ) ).

    DATA(start) = VALUE zcl_turtle=>t_point( x = 100 y = 100 ).
    DATA(side_length) = 100.

    DATA(points) = VALUE zcl_turtle=>t_points(
      ( start )
      ( x = start-x + side_length y = start-y )
      ( x = start-x + side_length y = start-y + side_length )
      ( x = start-x y = start-y + side_length )
    ).

    turtle->append_svg(
      turtle->svg_builder->polyline( VALUE #( points = points ) )
    ).
  ENDMETHOD.

  METHOD polygon_using_lines.

    turtle = zcl_turtle=>new( height = 800 width = 800 ).
    turtle->goto( x = 200 y = 200 ).

    turtle->set_pen( VALUE #(
            stroke_color = `#FF00FF`
            stroke_width = 2 ) ).

    DATA(i) = 0.
    WHILE i < num_sides.
      turtle->forward( side_length ).
      turtle->right( 360 / num_sides ).

      i = i + 1.
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
