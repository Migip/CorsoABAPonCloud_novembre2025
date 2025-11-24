CLASS zcl_gfp_aereo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_gfp_aereo IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA:
      lo_aereo1 TYPE REF TO lcl_aereo,
      lo_aereo2 TYPE REF TO lcl_aereo,
      lo_aereo3 TYPE REF TO lcl_aereo,
      lt_aerei  TYPE lcl_aereo=>gtt_instances.

    out->write( 'Test' ).
    lo_aereo1 = lcl_aereo=>nuovo_aereo( ).
    lo_aereo1->vola( ).
    lo_aereo2 = lcl_aereo=>nuovo_aereo( ).
    lo_aereo2->vola( ).
    lo_aereo2->atterra( ).
    lo_aereo3 = lcl_aereo=>nuovo_aereo( ).

    lt_aerei = lcl_aereo=>get_aerei(  ).
    out->write(
        name = 'Lista aerei'
        data = lt_aerei ).

  ENDMETHOD.

ENDCLASS.
