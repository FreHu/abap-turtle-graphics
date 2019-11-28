report zabapturtle.

" square using movement
data(turtle) = zcl_turtle=>new( width = 640 height = 480 ).
turtle->goto( x = 100 y = 100 ).
do 4 times.
  turtle->forward( 100 ).
  turtle->right( 90 ).
enddo.
turtle->show( ).

" square using a polyline
data(square) = zcl_turtle_examples=>filled_square( ).
square->show(  ).

" shape composed of multiple polygons
zcl_turtle_examples=>polygon_flower(
  polygons = 15
  polygon_sides = 10
)->show( ).

" usage for "functional" programmers. this will open a few windows
types: turtles type standard table of ref to zcl_turtle with empty key.
data(more_examples) = value turtles(
  for polygons in zcl_number_range=>get( min = 12 max = 15 )
  for polygon_sides in zcl_number_range=>get( min = 8 max = 10 )
  ( zcl_turtle_examples=>polygon_flower(
      polygons = polygons
      polygon_sides = polygon_sides
    )->show( )
  )
).

" l-systems
zcl_turtle_lsystem_examples=>koch_curve( ).
zcl_turtle_lsystem_examples=>pattern( ).

" stack-based examples
zcl_turtle_lsystem_examples=>plant( ).
zcl_turtle_lsystem_examples=>plant_2( ).
