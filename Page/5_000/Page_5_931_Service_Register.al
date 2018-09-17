OBJECT Page 5931 Service Register
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
    CaptionML=[DAN=Servicejournal;
               ENU=Service Register];
    SourceTable=Table5934;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Journal;
                                 ENU=&Register];
                      Image=Register }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Servicepost;
                                 ENU=Service Ledger];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf›ringstransaktioner i servicedokumenter.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Codeunit 5911;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ServiceLedger;
                      PromotedCategory=Process }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Garantipost;
                                 ENU=Warranty Ledger];
                      ToolTipML=[DAN=Vis alle garantiposter for serviceartikler eller serviceordrer. Posterne stammer fra bogf›ringstransaktioner i servicedokumenter.;
                                 ENU=View all of the warranty ledger entries for service items or service orders. The entries are the result of posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Codeunit 5919;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=WarrantyLedger;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for oprettelsen af posterne i journalen.;
                           ENU=Specifies the date when the entries in the register were created.];
                ApplicationArea=#Service;
                SourceExpr="Creation Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Service;
                SourceExpr="User ID" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f›rste varepostnummer i journalen.;
                           ENU=Specifies the first item entry number in the register.];
                ApplicationArea=#Service;
                SourceExpr="From Entry No." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste r‘kkef›lgenummer fra intervallet af serviceposter, der er oprettet for journallinjen.;
                           ENU=Specifies the last sequence number from the range of service ledger entries created for this register line.];
                ApplicationArea=#Service;
                SourceExpr="To Entry No." }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f›rste r‘kkef›lgenummer fra intervallet af garantiposter, der er oprettet for journallinjen.;
                           ENU=Specifies the first sequence number from the range of warranty ledger entries created for this register line.];
                ApplicationArea=#Service;
                SourceExpr="From Warranty Entry No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste r‘kkef›lgenummer fra intervallet af garantiposter, der er oprettet for journallinjen.;
                           ENU=Specifies the last sequence number from the range of warranty ledger entries created for this register line.];
                ApplicationArea=#Service;
                SourceExpr="To Warranty Entry No." }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

