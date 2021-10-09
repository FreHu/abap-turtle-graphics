class zcx_turtle_problem definition
  public final
  create private
  inheriting from cx_no_check.

  public section.
    class-methods: raise
      importing text type string.
    methods constructor
      importing
        text     type string
        previous type ref to cx_root optional.

  private section.
    data: text type string.

endclass.


class zcx_turtle_problem implementation.

  method constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( ).
    me->text = text.
    me->previous = previous.
  endmethod.

  method raise.
    raise exception new zcx_turtle_problem( text = text ).
  endmethod.

endclass.
