CLASS zcl_gfp_estrazione_flight DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      _extract_all
        IMPORTING
          out TYPE REF TO if_oo_adt_classrun_out,
      _count
        IMPORTING
          out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS zcl_gfp_estrazione_flight IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    _extract_all( out ).

    _count( out ).

  ENDMETHOD.

  METHOD _extract_all.
    TYPES: BEGIN OF helper_type,
             carrier_id    TYPE /dmo/flight-carrier_id,
             connection_id TYPE /dmo/flight-connection_id,
             flight_date   TYPE /dmo/flight-flight_date,
             price         TYPE /dmo/flight-price,
           END OF helper_type.
    DATA: lt_table TYPE STANDARD TABLE OF helper_type.
*    DATA:
*        lt_table TYPE TABLE OF /dmo/flight.

    SELECT
            carrier_id,
            connection_id,
            flight_date,
            price
        FROM /dmo/flight
        INTO TABLE @lt_table.

    out->write(
      EXPORTING
        data   = lt_table
*        name   =
*      RECEIVING
*        output =
    ).
  ENDMETHOD.

  METHOD _count.

*    SELECT
*        carrier_id,
*        COUNT( DISTINCT connection_Id ) AS counter
*      FROM /dmo/flight
*      GROUP BY carrier_id
*      ORDER BY carrier_id
*      INTO TABLE @DATA(lt_counter).
    SELECT
        AirlineID,
        COUNT( DISTINCT ConnectionID ) AS counter
      FROM /DMO/I_Flight
      GROUP BY AirlineID
      ORDER BY AirlineID
      INTO TABLE @DATA(lt_counter).
*    WITH +fli AS (
*        SELECT DISTINCT
*            carrier_id,
*            connection_id
*          FROM /dmo/flight
*         )
*      SELECT
*            carrier_id,
*            COUNT( connection_id ) AS counter
*        FROM +fli AS flight
*        GROUP BY carrier_id
*        ORDER BY carrier_id
*        INTO TABLE @DATA(lt_counter).

    out->write(
      EXPORTING
        data   = lt_counter
*          name   =
*        RECEIVING
*          output =
    ).

  ENDMETHOD.
ENDCLASS.
