report turtle_demo_polygons.

initialization.

  parameters:
    bgcolor  type string default `#000000`,
    polygons type i,
    sides    type i.

at selection-screen output.

  if polygons <> 0 and sides <> 0.

    data(turtle) = zcl_turtle=>create( height = 800 width = 800 title = |Polygons:{ polygons } Sides: { sides }| background_color = bgcolor ).

    turtle->goto( x = 400 y = 400 ).
    turtle->set_pen( value #(
            stroke_color = `#FF00FF`
            stroke_width = 2 ) ).

    data(current_polygon) = 0.
    while current_polygon < polygons.

      " draw a regular polygon
      data(current_polygon_side) = 0.
      data(side_length) = 50.
      while current_polygon_side < sides.
        turtle->forward( side_length ).
        turtle->right( 360 / sides ).
        current_polygon_side = current_polygon_side + 1.
      endwhile.

      " rotate before painting next polygon
      turtle->right( 360 / polygons ).

      current_polygon = current_polygon + 1.
    endwhile.

    zcl_turtle_output=>show( turtle ).

  endif.
