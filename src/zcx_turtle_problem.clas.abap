CLASS zcx_turtle_problem DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  INHERITING FROM cx_no_check.

  PUBLIC SECTION.
    CLASS-METHODS: raise
      IMPORTING text TYPE string.
    METHODS constructor
      IMPORTING
        text     TYPE string
        previous TYPE REF TO cx_root OPTIONAL.

  PRIVATE SECTION.
    DATA: text TYPE string.

ENDCLASS.



CLASS zcx_turtle_problem IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( ).
    me->text = text.
    me->previous = previous.
  ENDMETHOD.

  METHOD raise.
    RAISE EXCEPTION NEW zcx_turtle_problem( text = text ).
  ENDMETHOD.

ENDCLASS.
