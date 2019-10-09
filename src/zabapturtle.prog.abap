REPORT zabapturtle.

zcl_turtle_examples=>polygon_flower(
  polygons = 15
  polygon_sides = 10
)->show( ).

" there are also polygon/polyline methods which accept a list of points.
DATA(polygon) = zcl_turtle_examples=>polygon_using_lines( side_length = 50 num_sides = 9 ).
polygon->show(  ).

DATA(square) = zcl_turtle_examples=>filled_square( ).
square->show(  ).

" this will open a few windows
TYPES: turtles TYPE STANDARD TABLE OF REF TO zcl_turtle WITH EMPTY KEY.
DATA(more_examples) = VALUE turtles(
  FOR polygons IN zcl_number_range=>get( min = 12 max = 15 )
  FOR polygon_sides IN zcl_number_range=>get( min = 8 max = 10 )
  ( zcl_turtle_examples=>polygon_flower(
      polygons = polygons
      polygon_sides = polygon_sides
    )->show( )
  )
).
