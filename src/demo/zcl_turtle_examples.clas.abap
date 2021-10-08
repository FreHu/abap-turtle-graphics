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
    turtle = zcl_turtle=>new( height = 800 width = 800 title = |Polygons:{ polygons } Sides: { polygon_sides }| ).

    turtle->goto( x = 200 y = 200 ).
    data temp1 type zcl_turtle=>t_pen.
    temp1-stroke_color = `#FF00FF`.
    temp1-stroke_width = 2.
    turtle->set_pen( temp1 ).

    current_polygonTYPE i.
    current_polygonTYPE i.
    current_polygonTYPE i.
    current_polygonTYPE i.
    data current_polygon type i.
    current_polygon = 0.
    while current_polygon < polygons.

      " draw a regular polygon
      current_polygon_sideTYPE i.
      data current_polygon_side type i.
      current_polygon_side = 0.
      data side_length type i.
      side_length = 50.
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
    turtle = zcl_turtle=>new( height = 800 width = 800 ).
    turtle->goto( x = 200 y = 200 ).

    data temp2 type zcl_turtle=>t_pen.
    temp2-fill_color = `#FF0000`.
    temp2-stroke_color = `#FF00FF`.
    temp2-stroke_width = 2.
    turtle->set_pen( temp2 ).

    data temp3 type zcl_turtle=>t_point.
    temp3-x = 100.
    temp3-y = 100.
    start = temp3.
    3.
    start = temp3.
    3.
    data start like temp3.
    start = temp3.
    side_lengthTYPE i.
    side_lengthTYPE i.
    side_lengthTYPE i.
    data side_length type i.
    side_length = 100.

    data temp4 type zcl_turtle=>t_points.
    append start to temp4.
    data temp6 like line of temp4.
    temp6-x = start-x + side_length.
    temp6-y = start-y.
    append temp6 to temp4.
    temp6-x = start-x + side_length.
    temp6-y = start-y + side_length.
    append temp6 to temp4.
    temp6-x = start-x.
    temp6-y = start-y + side_length.
    append temp6 to temp4.
    points = temp4.
    4.
    data points like temp4.
    points = temp4.

    turtle->append_svg(
      turtle->svg_builder->polyline( value #( points = points ) )
    ).
  endmethod.

  method polygon_using_lines.

    turtle = zcl_turtle=>new( height = 800 width = 800 ).
    turtle->goto( x = 200 y = 200 ).

    data temp7 type zcl_turtle=>t_pen.
    temp7-stroke_color = `#FF00FF`.
    temp7-stroke_width = 2.
    turtle->set_pen( temp7 ).

    iTYPE i.
    iTYPE i.
    iTYPE i.
    data i type i.
    i = 0.
    while i < num_sides.
      turtle->forward( side_length ).
      turtle->right( 360 / num_sides ).

      i = i + 1.
    endwhile.
  endmethod.

endclass.
