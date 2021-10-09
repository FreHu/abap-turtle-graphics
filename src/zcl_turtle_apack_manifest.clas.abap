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
    data temp1 type zif_apack_manifest=>ty_descriptor.
    temp1-artifact_id = `abap-turtle-graphics`.
    temp1-group_id = `hudakf`.
    temp1-version = `1.0`.
    temp1-git_url = `https://github.com/FreHu/abap-turtle-graphics`.
    temp1-repository_type = zif_apack_manifest=>co_abap_git.
    me->zif_apack_manifest~descriptor = temp1.
  endmethod.

endclass.
