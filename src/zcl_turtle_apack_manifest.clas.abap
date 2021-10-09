class zcl_turtle_apack_manifest definition
  public final
  create public.

  public section.
    interfaces: zif_apack_manifest.
    methods constructor.

  protected section.
  private section.

endclass.


class zcl_turtle_apack_manifest implementation.

  method constructor.
    me->zif_apack_manifest~descriptor = value #(
      artifact_id = `abap-turtle-graphics`
      group_id = `hudakf`
      version = `1.0`
      git_url = `https://github.com/FreHu/abap-turtle-graphics`
      repository_type = zif_apack_manifest=>co_abap_git ).
  endmethod.

endclass.
