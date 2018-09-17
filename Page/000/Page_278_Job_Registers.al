OBJECT Page 278 Job Registers
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
    CaptionML=[DAN=Sagsjournaler;
               ENU=Job Registers];
    SourceTable=Table241;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Journal;
                                 ENU=&Register];
                      Image=Register }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Sagsposter;
                                 ENU=Job Ledger];
                      ToolTipML=[DAN=Vis sagsposterne.;
                                 ENU=View the job ledger entries.];
                      ApplicationArea=#Jobs;
                      RunObject=Codeunit 1025;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=JobLedger;
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Jobs;
                SourceExpr="No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor posterne blev bogf�rt i kladden.;
                           ENU=Specifies the date on which you posted the entries in the journal.];
                ApplicationArea=#Jobs;
                SourceExpr="Creation Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf�rt posten, der skal bruges, f.eks. i �ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Jobs;
                SourceExpr="User ID" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Source Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kladdek�rsel, et personligt kladdelayout, som posterne blev bogf�rt fra.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.];
                ApplicationArea=#Jobs;
                SourceExpr="Journal Batch Name" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f�rste varepostnummer i journalen.;
                           ENU=Specifies the first item entry number in the register.];
                ApplicationArea=#Jobs;
                SourceExpr="From Entry No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l�benummeret p� den sidste posteringslinje, der blev medregnet, f�r du bogf�rte posterne i kladden.;
                           ENU=Specifies the entry number of the last entry line you included before you posted the entries in the journal.];
                ApplicationArea=#Jobs;
                SourceExpr="To Entry No." }

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

