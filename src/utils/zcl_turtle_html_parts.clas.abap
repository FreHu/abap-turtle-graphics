class zcl_turtle_html_parts definition
  public
  final
  create private.

  public section.
    class-methods html_document
      importing title       type string optional
                style       type string optional
                svg         type string optional
      returning value(html) type string.

  protected section.
  private section.
endclass.



class zcl_turtle_html_parts implementation.

  method html_document.
    html =
    |<!DOCTYPE html>\r\n| &
    |<html lang="en">\r\n| &
    |<head>\r\n| &
    |  <meta charset="UTF-8">\r\n| &
    |  <meta name="viewport" content="width=device-width, initial-scale=1.0">\r\n| &
    |  <title>{ title }</title>\r\n| &
    |  <style type="text/css">\r\n| &&
    |  { style }| &&
    |  </style>\r\n| &
    |</head>\r\n| &
    |<body>\r\n| &&
    |{ svg }| &&
    |</body>\r\n| &
    |</html>|.
  endmethod.

endclass.
