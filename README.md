# abap-turtle-graphics

Enterprise-grade turtle graphics library for abap intended for business-oriented children or bored adults. 

The graphics are generated in the svg format. 

## Usage example

### Turtle

```abap
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
```

![image](https://user-images.githubusercontent.com/5097067/66410268-2003fb00-e9f2-11e9-94a5-fc764b461932.png)

see `zcl_turtle_examples` for more

#### Supported instructions

movement:

- forward, back
- left,right (rotate by x degrees)

svg primitives:

- line
- circle
- polyline
- polygon
- text

styling:

- stroke width
- stroke color
- fill color



### L-systems (or TurtleScript, if you will)

Define an initial state, a number of iterations and a set of replacement rules. These will be applied in each iteration. Finally, the symbols are translated into instructions and executed.

#### Supported symbols:

- `F`, `G`, `H` - variables. Interpreted as forward()
- `+`, `-` - rotate right/left

```abap
    DATA(turtle) = zcl_turtle=>new( height = 800 width = 600 ).
    turtle->goto( x = 200 y = 200 ).
    
    DATA(parameters) = VALUE zcl_turtle_lsystem=>params(
      initial_state = `F`
      move_distance = 10
      rotate_by = 90
      num_iterations = 3
      rewrite_rules = VALUE #(
        ( from = `F` to = `F+F-F-F+F` )
       )
    ).

    DATA(lsystem) = zcl_turtle_lsystem=>new(
      turtle = turtle
      parameters = parameters ).

    lsystem->execute( ).
    lsystem->show( ).
```
![lsystem-pattern](https://user-images.githubusercontent.com/5097067/66557433-2b6e3800-eb52-11e9-8ea7-de828b93f6a2.png)
