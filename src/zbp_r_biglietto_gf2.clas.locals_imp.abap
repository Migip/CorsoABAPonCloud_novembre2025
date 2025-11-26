CLASS lhc_zr_biglietto_gf2 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Biglietto
        RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE Biglietto.
ENDCLASS.

CLASS lhc_zr_biglietto_gf2 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA:
        lv_id TYPE zr_biglietto_gf2-IdBiglietto.
*    WITH +big AS (
*        SELECT MAX( Idbiglietto ) AS id_max
*            FROM zr_biglietto_gf2
*        UNION
*        SELECT MAX( Idbiglietto ) AS id_max
*            FROM zbiglietto_gf2_d
*        )
*        SELECT MAX( id_max )
*            FROM +big AS big
*            INTO @DATA(lv_max).
*    SELECT MAX( Idbiglietto )
*        FROM zr_biglietto_gf2
*        INTO @DATA(lv_max).
    LOOP AT entities
            INTO DATA(ls_entity).
      IF ls_entity-IdBiglietto IS INITIAL.
*        DATA(lo_get_number) = cl_numberrange_buffer=>get_instance(  ).
*        lo_get_number->if_numberrange_buffer~number_get_no_buffer(
*            EXPORTING
*                iv_ignore_buffer = 'X'
*                iv_object    = 'ZID_BIG_GF'
*                iv_interval  = '01'
*                iv_quantity  = 1
*            IMPORTING
*                ev_number    = DATA(lv_max) ).
*      try.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*            ignore_buffer     = 'X'
            nr_range_nr       = '01'
            object            = 'ZID_BIG_GF'
            quantity          = 1
*            subobject         =
*            toyear            =
          IMPORTING
            number            = data(lv_max)
*            returncode        =
*            returned_quantity =
        ).
*        CATCH cx_nr_object_not_found.
*        CATCH cx_number_ranges.
*        endtry.
*        lv_max += 1.
        lv_id = lv_max.
      ELSE.
        lv_id = ls_entity-IdBiglietto.
      ENDIF.
      APPEND VALUE #(
              %cid = ls_entity-%cid
              %is_draft = ls_entity-%is_draft
              IdBiglietto = lv_id
          )
          TO mapped-biglietto.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
