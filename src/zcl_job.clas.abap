CLASS zcl_job DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_job IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
    et_parameter_def = VALUE #( (
        selname = 'VALORE'
        kind    = 'C'
        length  = 3
        param_text = 'Valorissimo' ) ).
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA:
        ls_job TYPE zgfp_job.
    SELECT MAX( id )
        FROM zgfp_job
        INTO @ls_job-id.
    ls_job-id += 1.
    ls_job-created_by = cl_abap_context_info=>get_user_technical_name( ).
    GET TIME STAMP FIELD ls_job-created_at.
    INSERT zgfp_job
        FROM @ls_job.
    IF sy-subrc IS INITIAL.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
