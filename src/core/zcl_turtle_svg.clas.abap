class zcl_turtle_svg definition
  public final
  create private.

  public section.

    types:
      begin of line_params,
        x_from type i,
        y_from type i,
        x_to   type i,
        y_to   type i,
      end of line_params,

      begin of polygon_params,
        points type zcl_turtle=>t_points,
      end of polygon_params,
      polyline_params type polygon_params,

      begin of text_params,
        x    type i,
        y    type i,
        text type string,
      end of text_params,

      begin of circle_params,
        center_x type i,
        center_y type i,
        radius   type i,
      end of circle_params.

    class-methods:
      new
        importing turtle        type ref to zcl_turtle
        returning value(result) type ref to zcl_turtle_svg.

    methods:
      line
        importing params          type line_params
        returning value(svg_line) type string,

      polygon
        importing params             type polygon_params
        returning value(svg_polygon) type string,

      polyline
        importing params              type polyline_params
        returning value(svg_polyline) type string,

      text
        importing params          type text_params
        returning value(svg_text) type string,

      circle
        importing params            type circle_params
        returning value(svg_circle) type string.

    data: turtle type ref to zcl_turtle read-only.
endclass.


class zcl_turtle_svg implementation.

  method new.
    data temp1 type ref to undefined.
    create object temp1.
    result = temp1.
    result->turtle = turtle.
  endmethod.

  method line.
    svg_line = |<line x1="{ params-x_from }" y1="{ params-y_from }" x2="{ params-x_to }" y2="{ params-y_to }" |
      && |stroke="{ turtle->pen-stroke_color }" stroke-width="{ turtle->pen-stroke_width }"/>|.
  endmethod.

  method polygon.
    data point_data type string.
    point_data = reduce string(
      init res = ||
      for point in params-points
      next res = res && |{ point-x },{ point-y } | ).

    svg_polygon = |<polygon points="{ point_data }"|
      && | stroke="{ turtle->pen-stroke_color }"|
      && | stroke-width="{ turtle->pen-stroke_width }" fill="{ turtle->pen-fill_color }" />|.

  endmethod.

  method polyline.
    data point_data type string.
    point_data = reduce string(
      init res = ||
      for point in params-points
      next res = res && |{ point-x },{ point-y } | ).

    svg_polyline = |<polyline points="{ point_data }"|
      && |stroke="{ turtle->pen-stroke_color }" |
      && |stroke-width="{ turtle->pen-stroke_width }" fill="{ turtle->pen-fill_color }" />|.

  endmethod.

  method circle.
    svg_circle = |<circle cx="{ params-center_x }" cy="{ params-center_y }" r="{ params-radius }" |
        && |stroke="{ turtle->pen-stroke_color }" |
        && |stroke-width="{ turtle->pen-stroke_width }" fill="{ turtle->pen-fill_color }"/>|.
  endmethod.

  method text.
    svg_text = |<text x="{ params-x }" y="{ params-y }">{ params-text }</text>|.
  endmethod.

endclass.
