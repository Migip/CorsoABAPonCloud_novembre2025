@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Biglietto GF'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_BIGLIETTO_GF
  provider contract transactional_query
  //as projection on ZR_BIGLIETTO_GF as Biglietto
  as projection on ZI_BIGLIETTO_GF as Biglietto
{
  key Biglietto.IdBiglietto,
      Biglietto.CreatoDa,
      Biglietto.CreatoA,
      Biglietto.ModificatoDa,
      Biglietto.ModificatoA,
      Biglietto.Modificato
}
