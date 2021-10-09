class zcl_turtle_output definition
  public final.

  public section.
    class-methods show
      importing turtle type ref to zcl_turtle.

    class-methods download
      importing
        turtle type ref to zcl_turtle
        filename type string default `abap-turtle.html`.

  protected section.
  private section.
endclass.



class zcl_turtle_output implementation.

  method show.
    cl_abap_browser=>show_html(
      size = cl_abap_browser=>xlarge
      html_string = turtle->get_html( ) ).
  endmethod.

  method download.

    data(file_name) = filename.
    data(path) = ``.
    data(full_path) = ``.

    cl_gui_frontend_services=>file_save_dialog(
      exporting
        default_extension = `html`
        default_file_name = filename
        initial_directory = ``
      changing
        filename          = file_name
        path              = path
        fullpath          = full_path
      exceptions
        others            = 1 ).

    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

    split turtle->get_html( ) at |\r\n| into table data(lines).
    cl_gui_frontend_services=>gui_download(
      exporting
        filename = file_name
      changing
        data_tab = lines
      exceptions
        others   = 1 ).

    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
        with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

  endmethod.

endclass.
