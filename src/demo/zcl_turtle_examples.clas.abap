class zcl_turtle_examples definition
  public final.

  public section.
    class-methods polygon_flower
      importing polygons      type i
                polygon_sides type i
      returning value(turtle) type ref to zcl_turtle.

    class-methods filled_square
      returning value(turtle) type ref to zcl_turtle.

    class-methods polygon_using_lines
      importing num_sides     type i
                side_length   type i
      returning value(turtle) type ref to zcl_turtle.

endclass.

class zcl_turtle_examples implementation.

  method polygon_flower.
    turtle = zcl_turtle=>create( height = 800 width = 800 title = |Polygons:{ polygons } Sides: { polygon_sides }| ).

    turtle->goto( x = 200 y = 200 ).
    turtle->set_pen( value #(
            stroke_color = `#FF00FF`
            stroke_width = 2 ) ).

    data(current_polygon) = 0.
    while current_polygon < polygons.

      " draw a regular polygon
      data(current_polygon_side) = 0.
      data(side_length) = 50.
      while current_polygon_side < polygon_sides.
        turtle->forward( side_length ).
        turtle->right( 360 / polygon_sides ).
        current_polygon_side = current_polygon_side + 1.
      endwhile.

      " rotate before painting next polygon
      turtle->right( 360 / polygons ).

      current_polygon = current_polygon + 1.
    endwhile.
  endmethod.

  method filled_square.
    turtle = zcl_turtle=>create( height = 800 width = 800 ).
    turtle->goto( x = 200 y = 200 ).

    turtle->set_pen( value #(
            fill_color = `#FF0000`
            stroke_color = `#FF00FF`
            stroke_width = 2 ) ).

    data(start) = value zcl_turtle=>t_point( x = 100 y = 100 ).
    data(side_length) = 100.

    data(points) = value zcl_turtle=>t_points(
      ( start )
      ( x = start-x + side_length y = start-y )
      ( x = start-x + side_length y = start-y + side_length )
      ( x = start-x y = start-y + side_length )
    ).

    data(polyline) = turtle->svg_builder->polyline( value #( points = points ) ).
    turtle->append_svg( polyline ).
  endmethod.

  method polygon_using_lines.

    turtle = zcl_turtle=>create( height = 800 width = 800 ).
    turtle->goto( x = 200 y = 200 ).

    turtle->set_pen( value #(
            stroke_color = `#FF00FF`
            stroke_width = 2 ) ).

    data(i) = 0.
    while i < num_sides.
      turtle->forward( side_length ).
      turtle->right( 360 / num_sides ).

      i = i + 1.
    endwhile.
  endmethod.

endclass.