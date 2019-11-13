![logo](./turtle.png)

[Announcement blog](https://blogs.sap.com/2019/10/12/abapturtle-make-something-pretty-in-abap-and-possibly-win-prizes/)

Enterprise-grade turtle graphics library for abap intended for business-oriented children or bored adults. 

The graphics are generated in the svg format. 

## Installation

Import the repository to your system using abapGit.

## Usage example

### Turtle

```abap
REPORT zabapturtle.

DATA(turtle) = NEW zcl_turtle( height = 800 width = 800 ).

turtle->set_pen( VALUE #( stroke_width = 2 ) ).

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
You can also save the image using `turtle->download()`.

![image](https://user-images.githubusercontent.com/5097067/66575607-7ac65f80-eb76-11e9-8a9c-0ccab1041d38.png)

see `zcl_turtle_examples` for more

#### Supported instructions

**zcl_turtle**

movement:

- forward, back
- left,right (rotate by x degrees)
- pen up/down (only considered when moving, not when outputting svg directly)

styling:

- background color
- stroke width
- stroke color
- fill color

**zcl_turtle_svg**

Generate svg primitives:

- line
- circle
- polyline
- polygon
- text

Note that this only returns the svg string. Add these shapes to a turtle using `turtle->append_svg`.

Color schemes:
A random color is used for each line. You can use `turtle->set_color_scheme( )` to change the colors.


### L-systems (or TurtleScript, if you will)

[Wiki link](https://en.wikipedia.org/wiki/L-system)

Define an initial state, a number of iterations and a set of replacement rules. These will be applied in each iteration. Finally, the symbols are translated into instructions and executed.


#### Supported operations: 

- movement
- rotation
- stack push/pop

See `zcl_turtle_lsystem=>instruction_kind`.


```abap
DATA(turtle) = zcl_turtle=>new( height = 800 width = 600 ).
turtle->goto( x = 200 y = 200 ).

DATA(parameters) = VALUE zcl_turtle_lsystem=>params(
  initial_state = `F`
  instructions = VALUE #(
    ( symbol = 'F' kind = zcl_turtle_lsystem=>instruction_kind-forward amount = 10 )
    ( symbol = '+' kind = zcl_turtle_lsystem=>instruction_kind-right amount = 90 )
    ( symbol = '-' kind = zcl_turtle_lsystem=>instruction_kind-left amount = 90 ) )
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

![image](https://user-images.githubusercontent.com/5097067/66575635-8ca80280-eb76-11e9-8c3b-d22604ce6eb2.png)

The stack can be used to generate plants or trees:
```abap
DATA(turtle) = zcl_turtle=>new( height = 800 width = 600 ).
turtle->goto( x = 300 y = 600 ).
turtle->set_angle( -90 ).

DATA(parameters) = VALUE zcl_turtle_lsystem=>params(
  initial_state = `F`
  instructions = VALUE #(
    ( symbol = `F` kind = zcl_turtle_lsystem=>instruction_kind-forward amount = 10 )
    ( symbol = `+` kind = zcl_turtle_lsystem=>instruction_kind-right amount = 25 )
    ( symbol = `-` kind = zcl_turtle_lsystem=>instruction_kind-left amount = 25 )
    ( symbol = `[` kind = zcl_turtle_lsystem=>instruction_kind-stack_push )
    ( symbol = `]` kind = zcl_turtle_lsystem=>instruction_kind-stack_pop )
  )
  num_iterations = 5
  rewrite_rules = VALUE #(
    ( from = `F` to = `F[+F]F[-F][F]` )
    )
).

DATA(lsystem) = zcl_turtle_lsystem=>new(
  turtle = turtle
  parameters = parameters ).

lsystem->execute( ).
lsystem->show( ).
```

![image](https://user-images.githubusercontent.com/5097067/66575734-beb96480-eb76-11e9-886a-e6641da67a0e.png)
