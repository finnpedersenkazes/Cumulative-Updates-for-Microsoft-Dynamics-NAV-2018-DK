OBJECT Page 5650 Total Value Insured Subform
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table5650;
    DataCaptionFields=FA No.;
    PageType=ListPart;
    OnFindRecord=BEGIN
                   EXIT(FindFirst(Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(FindNext(Steps));
                 END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver nummeret for det relaterede anl‘g. ";
                           ENU="Specifies the number of the related fixed asset. "];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den forsikringspolice, som posten er tilknyttet.;
                           ENU=Specifies the number of the insurance policy that the entry is linked to.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Insurance No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af forsikringspolicen.;
                           ENU=Specifies the description of the insurance policy.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de bel›b, du har bogf›rt for de enkelte forsikringspolicer for anl‘gget.;
                           ENU=Specifies the amounts you posted to each insurance policy for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Total Value Insured" }

  }
  CODE
  {

    [External]
    PROCEDURE CreateTotalValue@1(FANo@1000 : Code[20]);
    BEGIN
      CreateInsTotValueInsured(FANo);
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

