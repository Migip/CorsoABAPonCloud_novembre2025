@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Esempio LEFT JOIN'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_FLIGHT
  as select from    /dmo/carrier as car
    left outer join /dmo/flight  as fli on fli.carrier_id = car.carrier_id
{
  key car.carrier_id,
      //  key fli.connection_id,
      //  key fli.flight_date,
      //      fli.carrier_id as carrier_id2
      //  key coalesce( fli.connection_id, '0000' ) as connection_id,
  key case when fli.connection_id is null
    then fli.connection_id
    else '0000'
    end                                           as connection_id,
  key coalesce( fli.flight_date, '00000000' )     as flight_date,
      coalesce( fli.carrier_id, ' ' )             as carrier_id2,
      @Semantics.amount.currencyCode: 'currency_code'
      cast( fli.price * 3 as abap.curr( 16, 2 ) ) as price2,
      fli.currency_code
}
