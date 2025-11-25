CLASS zcl_check_cds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      _coalesce
        IMPORTING
          io_out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS zcl_check_cds IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    _coalesce( out ).
  ENDMETHOD.

  METHOD _coalesce.
    SELECT *
        FROM zcds_flight
        WHERE carrier_id2 = ' '
        INTO TABLE @DATA(lt_flight).
*    DELETE lt_flight
*        WHERE carrier_id2 <> ' '.
    io_out->write(
      EXPORTING
        data   = lt_flight
        name   = 'OUTPUT'
*      RECEIVING
*        output =
    ).
  ENDMETHOD.
ENDCLASS.
