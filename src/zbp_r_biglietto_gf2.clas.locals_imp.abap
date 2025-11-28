CLASS lhc_zr_biglietto_gf2 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Biglietto
        RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE Biglietto,
      CheckStatus FOR VALIDATE ON SAVE
        IMPORTING keys FOR Biglietto~CheckStatus,
      GetDefaultsForCreate FOR READ
        IMPORTING keys   FOR FUNCTION Biglietto~GetDefaultsForCreate
        RESULT    result,
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR Biglietto RESULT result,
      onSave FOR DETERMINE ON SAVE
        IMPORTING keys FOR Biglietto~onSave,
      CustomDelete FOR MODIFY
        IMPORTING keys FOR ACTION Biglietto~CustomDelete RESULT result.
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
            number            = DATA(lv_max)
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

  METHOD CheckStatus.
    DATA:
        lt_biglietto TYPE TABLE FOR READ RESULT zr_biglietto_gf2.
    READ ENTITIES OF zr_biglietto_gf2
        IN LOCAL MODE
        ENTITY Biglietto
        FIELDS ( Stato )
        WITH CORRESPONDING #(  keys )
        RESULT lt_biglietto.

    LOOP AT lt_biglietto
            INTO DATA(ls_biglietto)
            WHERE Stato <> 'BOZZA'
              AND Stato <> 'FINALE'
              AND Stato <> 'CANC'.
      APPEND VALUE #(
            %tky = ls_biglietto-%tky )
        TO failed-biglietto.
      APPEND VALUE #(
            %tky = ls_biglietto-%tky
            %msg = NEW zcx_error_bigl_gf(
                textid = zcx_error_bigl_gf=>gc_invalid_status
                iv_stato = ls_biglietto-Stato
                severity = if_abap_behv_message=>severity-error
*                severity = if_abap_behv_message=>severity-warning
                 )
            %element-Stato = if_abap_behv=>mk-on )
        TO reported-biglietto.
    ENDLOOP.
  ENDMETHOD.

  METHOD GetDefaultsForCreate.
    result = VALUE #( FOR key IN keys (
             %cid = key-%cid
             %param-stato = 'BOZZA'
              ) ).
  ENDMETHOD.

  METHOD get_instance_features.
    DATA:
        ls_result LIKE LINE OF result.
    READ ENTITIES OF zr_biglietto_gf2
        IN LOCAL MODE
        ENTITY Biglietto
        FIELDS ( Stato )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_biglietto).
    LOOP AT lt_biglietto
            INTO DATA(ls_biglietto).
      CLEAR ls_result.
      ls_result-%tky = ls_biglietto-%tky.
      ls_result-%field-Stato = if_abap_behv=>fc-f-read_only.
      ls_result-%action-CustomDelete = COND #(
        WHEN ls_biglietto-Stato = 'FINALE'
            THEN if_abap_behv=>fc-o-enabled
            ELSE if_abap_behv=>fc-o-disabled ).

      APPEND ls_result
        TO result.
*      APPEND VALUE #(
*              %tky = ls_biglietto-%tky
*
*              %field-Stato = if_abap_behv=>fc-f-read_only )
*          TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD onSave.
    DATA:
        lt_update TYPE TABLE FOR UPDATE zr_biglietto_gf2.
    READ ENTITIES OF zr_biglietto_gf2
        IN LOCAL MODE
        ENTITY Biglietto
        FIELDS ( Stato )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_biglietto).
    LOOP AT lt_biglietto
            INTO DATA(ls_biglietto)
            WHERE stato = 'BOZZA'.
      APPEND VALUE #(
              %tky = ls_biglietto-%tky
              Stato = 'FINALE'
              %control-Stato = if_abap_behv=>mk-on )
              TO lt_update.
    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zr_biglietto_gf2
          IN LOCAL MODE
          ENTITY Biglietto
          UPDATE FROM lt_update.
    ENDIF.
*            UPDATE FROM VALUE #(  (
*                %tky = ls_biglietto-%tky
*                Stato = 'FINALE'
*                %control-Stato = if_abap_behv=>mk-on ) ).
  ENDMETHOD.

  METHOD CustomDelete.
    DATA:
      lt_update TYPE TABLE FOR UPDATE zr_biglietto_gf2,
      ls_update LIKE LINE OF lt_update.

    READ ENTITIES OF zr_biglietto_gf2
        IN LOCAL MODE
        ENTITY Biglietto
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_biglietto).
    LOOP AT lt_biglietto
            ASSIGNING FIELD-SYMBOL(<biglietto>).
      <biglietto>-Stato = 'CANC'.
      APPEND VALUE #(
              %tky = <biglietto>-%tky
              %param = <biglietto> )
          TO result.
      ls_update = CORRESPONDING #( <biglietto> ).
      ls_update-%control-Stato = if_abap_behv=>mk-on.
      APPEND ls_update
        TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF zr_biglietto_gf2
        IN LOCAL MODE
        ENTITY Biglietto
        UPDATE FROM lt_update.


*    result = VALUE #(
*        FOR line IN keys
*        (   %tky = line-%tky
*            %param-Stato = 'CANC' ) ).

  ENDMETHOD.

ENDCLASS.
