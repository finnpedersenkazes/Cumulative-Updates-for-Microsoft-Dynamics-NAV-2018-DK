OBJECT Table 5848 Cost Share Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kostprisfordelingsbuffer;
               ENU=Cost Share Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Item Ledger Entry No.;Integer      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varepostl›benr.;
                                                              ENU=Item Ledger Entry No.] }
    { 2   ;   ;Capacity Ledger Entry No.;Integer  ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kapacitetspostl›benr.;
                                                              ENU=Capacity Ledger Entry No.] }
    { 3   ;   ;Item No.            ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 4   ;   ;Location Code       ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 5   ;   ;Variant Code        ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 6   ;   ;Entry Type          ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=K›b,Salg,Opregulering,Nedregulering,Overf›rsel,Forbrug,Afgang, ,Montageforbrug,Montageoutput;
                                                                    ENU=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output];
                                                   OptionString=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output }
    { 7   ;   ;Document No.        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 10  ;   ;Description         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 20  ;   ;Quantity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity] }
    { 21  ;   ;Direct Cost         ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=K›bspris;
                                                              ENU=Direct Cost] }
    { 22  ;   ;Indirect Cost       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indir. omkostninger;
                                                              ENU=Indirect Cost] }
    { 23  ;   ;Revaluation         ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘rdiregulering;
                                                              ENU=Revaluation] }
    { 24  ;   ;Rounding            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afrunding;
                                                              ENU=Rounding] }
    { 25  ;   ;Variance            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afvigelse;
                                                              ENU=Variance] }
    { 26  ;   ;Purchase Variance   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=K›bsafvigelse;
                                                              ENU=Purchase Variance] }
    { 27  ;   ;Material Variance   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Materialeomkostningsafvigelse;
                                                              ENU=Material Variance] }
    { 28  ;   ;Capacity Variance   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kapacitetsomkostningsafvigelse;
                                                              ENU=Capacity Variance] }
    { 29  ;   ;Capacity Overhead Variance;Decimal ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indir. kap. omk. afv.;
                                                              ENU=Capacity Overhead Variance] }
    { 30  ;   ;Mfg. Overhead Variance;Decimal     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indir. prod. omkostningsafv.;
                                                              ENU=Mfg. Overhead Variance] }
    { 31  ;   ;Subcontracted Variance;Decimal     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kostprisafvigelse for underleverand›rer;
                                                              ENU=Subcontracted Variance] }
    { 32  ;   ;Material            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Materiel;
                                                              ENU=Material] }
    { 34  ;   ;Capacity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kapacitet;
                                                              ENU=Capacity] }
    { 35  ;   ;Capacity Overhead   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indirekte kap.kostpris;
                                                              ENU=Capacity Overhead] }
    { 36  ;   ;Material Overhead   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indirekte kostpris for materiel;
                                                              ENU=Material Overhead] }
    { 37  ;   ;Subcontracted       ;Decimal       ;AccessByPermission=TableData 99000758=R;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fra underleverand›rer;
                                                              ENU=Subcontracted] }
    { 40  ;   ;New Quantity        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nyt antal;
                                                              ENU=New Quantity] }
    { 41  ;   ;New Direct Cost     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny k›bspris;
                                                              ENU=New Direct Cost];
                                                   AutoFormatType=2 }
    { 42  ;   ;New Indirect Cost   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny indirekte kostpris;
                                                              ENU=New Indirect Cost] }
    { 43  ;   ;New Revaluation     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny v‘rdiregulering;
                                                              ENU=New Revaluation] }
    { 44  ;   ;New Rounding        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny afrunding;
                                                              ENU=New Rounding] }
    { 45  ;   ;New Variance        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny afvigelse;
                                                              ENU=New Variance] }
    { 46  ;   ;New Purchase Variance;Decimal      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny k›bsafvigelse;
                                                              ENU=New Purchase Variance] }
    { 47  ;   ;New Material Variance;Decimal      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny materialeomkostningsafvigelse;
                                                              ENU=New Material Variance] }
    { 48  ;   ;New Capacity Variance;Decimal      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny kapacitetsomkostningsafvigelse;
                                                              ENU=New Capacity Variance] }
    { 49  ;   ;New Capacity Overhead Variance;Decimal;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny indir. kap. omk. afv.;
                                                              ENU=New Capacity Overhead Variance] }
    { 50  ;   ;New Mfg. Overhead Variance;Decimal ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny indir. prod. omkostningsafv.;
                                                              ENU=New Mfg. Overhead Variance] }
    { 51  ;   ;New Subcontracted Variance;Decimal ;AccessByPermission=TableData 99000758=R;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny afvigelse for underleverand›rer;
                                                              ENU=New Subcontracted Variance] }
    { 52  ;   ;Share of Cost in Period;Decimal    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kostprisfordeling i periode;
                                                              ENU=Share of Cost in Period] }
    { 54  ;   ;New Material        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nyt materiel;
                                                              ENU=New Material] }
    { 56  ;   ;New Capacity        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny kapacitet;
                                                              ENU=New Capacity] }
    { 57  ;   ;New Capacity Overhead;Decimal      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny indirekte kapacitet;
                                                              ENU=New Capacity Overhead] }
    { 58  ;   ;New Material Overhead;Decimal      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nyt indirekte materiel;
                                                              ENU=New Material Overhead] }
    { 59  ;   ;New Subcontracted   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny underleverance;
                                                              ENU=New Subcontracted] }
    { 60  ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 90  ;   ;Order Type          ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ordretype;
                                                              ENU=Order Type];
                                                   OptionCaptionML=[DAN=" ,Produktion,Overf›rsel,Service,Montage";
                                                                    ENU=" ,Production,Transfer,Service,Assembly"];
                                                   OptionString=[ ,Production,Transfer,Service,Assembly] }
    { 91  ;   ;Order No.           ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.] }
    { 92  ;   ;Order Line No.      ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ordrelinjenr.;
                                                              ENU=Order Line No.] }
  }
  KEYS
  {
    {    ;Item Ledger Entry No.,Capacity Ledger Entry No.;
                                                   Clustered=Yes }
    {    ;Item No.,Location Code,Variant Code,Entry Type }
    {    ;Order Type,Order No.,Order Line No.,Entry Type }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

