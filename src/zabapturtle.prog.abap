REPORT zabapturtle.

DATA(turtle) = NEW zcl_turtle( height = 800 width = 800 ).

turtle->set_pen( VALUE #(
        fill_color = `#FF0000`
        stroke_color = `#FF00FF`
        stroke_width = 2 ) ).

turtle->goto( x = 200 y = 200 ).
DATA(i) = 0.
DATA(n) = 15.
WHILE i < n.
  turtle->polygon( num_sides = 10 side_length = 50 ).
  turtle->right( 360 / n ).

  i += 1.
ENDWHILE.

turtle->show( ).
