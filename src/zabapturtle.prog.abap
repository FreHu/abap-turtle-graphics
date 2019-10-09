REPORT zabapturtle.

" square using movement
DATA(turtle) = zcl_turtle=>new( width = 640 height = 480 ).
turtle->goto( x = 100 y = 100 ).
DO 4 TIMES.
  turtle->back( 100 ).
  turtle->right( 90 ).
ENDDO.
turtle->show( ).

" square using a polyline
DATA(square) = zcl_turtle_examples=>filled_square( ).
square->show(  ).

" shape composed of multiple polygons
zcl_turtle_examples=>polygon_flower(
  polygons = 15
  polygon_sides = 10
)->show( ).

" usage for "functional" programmers. this will open a few windows
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
