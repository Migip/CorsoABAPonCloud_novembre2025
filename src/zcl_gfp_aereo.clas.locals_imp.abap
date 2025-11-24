*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_aereo DEFINITION.
  PUBLIC SECTION.
    TYPES:
      gto_instance  TYPE REF TO lcl_aereo,
      gtt_instances TYPE TABLE OF gto_instance
          WITH EMPTY KEY.
    CLASS-METHODS:
      nuovo_aereo
        RETURNING VALUE(ro_aereo) TYPE gto_instance,
      get_aerei
        RETURNING
          VALUE(rt_aerei) TYPE gtt_instances.

    METHODS:
      vola,
      atterra.

  PRIVATE SECTION.
    CLASS-DATA:
              gt_aerei TYPE TABLE OF gto_instance.

    DATA:
        gv_acceso TYPE abap_boolean.
ENDCLASS.

CLASS lcl_aereo IMPLEMENTATION.

  METHOD nuovo_aereo.
    DATA:
        lo_aereo TYPE REF TO lcl_aereo.

    CREATE OBJECT lo_aereo.
    ro_aereo = lo_aereo.
    APPEND lo_aereo
        TO gt_aerei.

  ENDMETHOD.

  METHOD get_aerei.
    rt_aerei = gt_aerei.
  ENDMETHOD.

  METHOD vola.
    gv_acceso = abap_true.
  ENDMETHOD.

  METHOD atterra.
    gv_acceso = abap_false.
  ENDMETHOD.
ENDCLASS.
