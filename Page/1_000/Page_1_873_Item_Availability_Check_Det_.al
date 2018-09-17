OBJECT Page 1873 Item Availability Check Det.
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Detaljer;
               ENU=Details];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table27;
    PageType=CardPart;
    ShowFilter=No;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 14  ;1   ;Field     ;
                Name=No.;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Editable=FALSE }

    { 13  ;1   ;Field     ;
                Name=Description;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Editable=FALSE }

    { 11  ;1   ;Field     ;
                Name=GrossReq;
                CaptionML=[DAN=Bruttobehov;
                           ENU=Gross Requirement];
                ToolTipML=[DAN=Angiver det afh‘ngige behov plus det uafh‘ngige behov. Afh‘ngige behov stammer fra produktionsordrekomponenter med alle statusser, montageordrekomponenter og planl‘gningslinjer. Uafh‘ngige behov stammer fra salgsordrer, overflytningsordrer, serviceordrer, sagsopgaver og produktionsforecasts.;
                           ENU=Specifies dependent demand plus independent demand. Dependent demand comes from production order components of all statuses, assembly order components, and planning lines. Independent demand comes from sales orders, transfer orders, service orders, job tasks, and production forecasts.];
                ApplicationArea=#All;
                DecimalPlaces=0:5;
                SourceExpr=GrossReq;
                Visible=GrossReq <> 0;
                Editable=FALSE }

    { 10  ;1   ;Field     ;
                Name=ReservedReq;
                CaptionML=[DAN=Reserveret behov;
                           ENU=Reserved Requirement];
                ToolTipML=[DAN=Angiver reservationsantal p† behovsrecords.;
                           ENU=Specifies reservation quantities on demand records.];
                ApplicationArea=#All;
                DecimalPlaces=0:5;
                SourceExpr=ReservedReq;
                Visible=ReservedReq <> 0;
                Editable=False }

    { 9   ;1   ;Field     ;
                Name=SchedRcpt;
                CaptionML=[DAN=Planlagt tilgang;
                           ENU=Scheduled Receipt];
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageordren der er indg†ende p† k›bsordrer, overflytningsordrer, modtageordrer, fastlagte produktionsordrer og frigivne produktionsordrer.;
                           ENU=Specifies how many units of the assembly component are inbound on purchase orders, transfer orders, assembly orders, firm planned production orders, and released production orders.];
                ApplicationArea=#All;
                DecimalPlaces=0:5;
                SourceExpr=SchedRcpt;
                Visible=SchedRcpt <> 0;
                Editable=FALSE }

    { 8   ;1   ;Field     ;
                Name=ReservedRcpt;
                CaptionML=[DAN=Reserveret modtagelse;
                           ENU=Reserved Receipt];
                ToolTipML=[DAN=Angiver reservationsantal p† forsyningsrecords.;
                           ENU=Specifies reservation quantities on supply records.];
                ApplicationArea=#All;
                DecimalPlaces=0:5;
                SourceExpr=ReservedRcpt;
                Visible=ReservedRcpt <> 0;
                Editable=False }

    { 7   ;1   ;Field     ;
                Name=CurrentQuantity;
                CaptionML=[DAN=Aktuelt antal;
                           ENU=Current Quantity];
                ToolTipML=[DAN=Angiver antallet p† bilaget, hvorfra tilg‘ngelighed kontrolleres.;
                           ENU=Specifies the quantity on the document for which the availability is checked.];
                ApplicationArea=#All;
                DecimalPlaces=0:5;
                SourceExpr=CurrentQuantity;
                Visible=CurrentQuantity <> 0;
                Editable=FALSE }

    { 6   ;1   ;Field     ;
                Name=CurrentReservedQty;
                CaptionML=[DAN=Aktuelt reserveret antal;
                           ENU=Current Reserved Quantity];
                ToolTipML=[DAN=Angiver det vareantal p† bilaget, der er reserveret i ›jeblikket.;
                           ENU=Specifies the quantity of the item on the document that is currently reserved.];
                ApplicationArea=#All;
                DecimalPlaces=0:5;
                SourceExpr=CurrentReservedQty;
                Visible=CurrentReservedQty <> 0;
                Editable=FALSE }

    { 4   ;1   ;Field     ;
                Name=EarliestAvailable;
                CaptionML=[DAN=Tidligste disponeringsdato;
                           ENU=Earliest Availability Date];
                ToolTipML=[DAN=Angiver ankomstdatoen for en indg†ende forsyning, som kan d‘kke det n›dvendige antal p† en senere dato end forfaldsdatoen. Bem‘rk, at hvis den indg†ende forsyningsordre kun d‘kker en del af det n›dvendige antal, betragtes den ikke som v‘rende til r†dighed, og feltet vil ikke indeholde en dato.;
                           ENU=Specifies the arrival date of an inbound supply that can cover the needed quantity on a date later than the due date. Note that if the inbound supply only covers parts of the needed quantity, it is not considered available and the field will not contain a date.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=EarliestAvailDate;
                Editable=FALSE }

    { 3   ;1   ;Field     ;
                Name=SubsituteExists;
                ToolTipML=[DAN=Angiver, at der findes en erstatning for denne vare.;
                           ENU=Specifies that a substitute exists for this item.];
                ApplicationArea=#Advanced;
                SourceExpr="Substitutes Exist";
                Editable=FALSE }

    { 2   ;1   ;Field     ;
                Name=UnitOfMeasureCode;
                Lookup=No;
                CaptionML=[DAN=Enhedskode;
                           ENU=Unit of Measure Code];
                ToolTipML=[DAN=Angiver den enhed, som tilg‘ngelighedstallene vises i.;
                           ENU=Specifies the unit of measure that the availability figures are shown in.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=UnitOfMeasureCode;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      UnitOfMeasureCode@1009 : Code[20];
      GrossReq@1007 : Decimal;
      SchedRcpt@1006 : Decimal;
      ReservedReq@1005 : Decimal;
      ReservedRcpt@1004 : Decimal;
      CurrentQuantity@1003 : Decimal;
      CurrentReservedQty@1002 : Decimal;
      EarliestAvailDate@1000 : Date;

    [External]
    PROCEDURE SetUnitOfMeasureCode@2(Value@1000 : Code[20]);
    BEGIN
      UnitOfMeasureCode := Value;
    END;

    [External]
    PROCEDURE SetGrossReq@5(Value@1000 : Decimal);
    BEGIN
      GrossReq := Value;
    END;

    [External]
    PROCEDURE SetReservedRcpt@6(Value@1000 : Decimal);
    BEGIN
      ReservedRcpt := Value;
    END;

    [External]
    PROCEDURE SetReservedReq@7(Value@1000 : Decimal);
    BEGIN
      ReservedReq := Value;
    END;

    [External]
    PROCEDURE SetSchedRcpt@8(Value@1000 : Decimal);
    BEGIN
      SchedRcpt := Value;
    END;

    [External]
    PROCEDURE SetCurrentQuantity@9(Value@1000 : Decimal);
    BEGIN
      CurrentQuantity := Value;
    END;

    [External]
    PROCEDURE SetCurrentReservedQty@10(Value@1000 : Decimal);
    BEGIN
      CurrentReservedQty := Value;
    END;

    [External]
    PROCEDURE SetEarliestAvailDate@12(Value@1000 : Date);
    BEGIN
      EarliestAvailDate := Value;
    END;

    BEGIN
    END.
  }
}

