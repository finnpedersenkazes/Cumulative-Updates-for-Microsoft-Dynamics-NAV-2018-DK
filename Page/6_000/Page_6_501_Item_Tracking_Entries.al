OBJECT Page 6501 Item Tracking Entries
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
    CaptionML=[DAN=Varesporingsposter;
               ENU=Item Tracking Entries];
    SaveValues=Yes;
    SourceTable=Table32;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 40      ;1   ;ActionGroup;
                      CaptionML=[DAN=Vare&sporingspost;
                                 ENU=&Item Tracking Entry];
                      Image=Entry }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Serienr.oplysningskort;
                                 ENU=Serial No. Information Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om serienummeret.;
                                 ENU=View or edit detailed information about the serial number.];
                      ApplicationArea=#ItemTracking;
                      RunObject=Page 6509;
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Serial No.=FIELD(Serial No.);
                      Image=SNInfo }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Lotnr.oplysningskort;
                                 ENU=Lot No. Information Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om lotnummeret.;
                                 ENU=View or edit detailed information about the lot number.];
                      ApplicationArea=#ItemTracking;
                      RunObject=Page 6508;
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Lot No.=FIELD(Lot No.);
                      Image=LotInfo }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 39      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varen i vareposten er positiv.;
                           ENU=Specifies whether the item in the item ledge entry is positive.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Positive }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† posten. Dokumentet er det regnskabsbilag, posten er baseret p†, f.eks. en kvittering.;
                           ENU=Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Document No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† varen i posten.;
                           ENU=Specifies the number of the item in the entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Item No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Description;
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et serienummer, hvis den bogf›rte vare har et s†dant nummer.;
                           ENU=Specifies a serial number if the posted item carries such a number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et lotnummer, hvis den bogf›rte vare har et s†dant nummer.;
                           ENU=Specifies a lot number if the posted item carries such a number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som posten er tilknyttet.;
                           ENU=Specifies the code for the location that the entry is linked to.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Location Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal vareenheder, der indg†r i vareposten.;
                           ENU=Specifies the number of units of the item in the item entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Quantity }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i feltet Antal, der mangler at blive behandlet.;
                           ENU=Specifies the quantity in the Quantity field that remains to be processed.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Remaining Quantity" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kildetype, der g‘lder for det kildenummer, der er vist i feltet Kildenr.;
                           ENU=Specifies the source type that applies to the source number, shown in the Source No. field.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Source Type";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dag for garantien p† varen p† linjen.;
                           ENU=Specifies the last day of warranty for the item on the line.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Warranty Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dato, hvor varen p† linjen kan anvendes.;
                           ENU=Specifies the last date that the item on the line can be used.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Expiration Date" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Entry No." }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                ApplicationArea=#ItemTracking;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                ApplicationArea=#ItemTracking;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Navigate@1000 : Page 344;

    BEGIN
    END.
  }
}

