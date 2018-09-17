OBJECT Page 5823 G/L - Item Ledger Relation
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
    CaptionML=[DAN=Finans - varetilknytning;
               ENU=G/L - Item Ledger Relation];
    SourceTable=Table5823;
    DataCaptionExpr=GetCaption;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       IF NOT ValueEntry.GET("Value Entry No.") THEN
                         ValueEntry.INIT;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=Vë&rdipost;
                                 ENU=Value Ent&ry];
                      Image=Entry }
      { 74      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ValueEntry.ShowDimensions;
                               END;
                                }
      { 75      ;2   ;Action    ;
                      CaptionML=[DAN=Finans;
                                 ENU=General Ledger];
                      ToolTipML=[DAN=èbn finans.;
                                 ENU=Open the general ledger.];
                      ApplicationArea=#Basic,#Suite;
                      Image=GLRegisters;
                      OnAction=BEGIN
                                 ValueEntry.ShowGL;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 32      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Navigate@1000 : Page 344;
                               BEGIN
                                 Navigate.SetDoc(ValueEntry."Posting Date",ValueEntry."Document No.");
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

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Bogfõringsdato;
                           ENU=Posting Date];
                ToolTipML=[DAN=Angiver den bogfõringsdato, der reprësenterer relationen.;
                           ENU=Specifies the posting date that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Posting Date" }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Varenr.;
                           ENU=Item No.];
                ToolTipML=[DAN=Angiver det varenummer, der reprësenterer relationen.;
                           ENU=Specifies the item number that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Item No." }

    { 42  ;2   ;Field     ;
                CaptionML=[DAN=Kildetype;
                           ENU=Source Type];
                ToolTipML=[DAN=Angiver den kildetype, der reprësenterer relationen.;
                           ENU=Specifies the source type that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=FORMAT(ValueEntry."Source Type") }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Kildenr.;
                           ENU=Source No.];
                ToolTipML=[DAN=Angiver det kildenummer, der reprësenterer relationen.;
                           ENU=Specifies the source number that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Source No." }

    { 52  ;2   ;Field     ;
                CaptionML=[DAN=Eksternt bilagsnr.;
                           ENU=External Document No.];
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."External Document No.";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                CaptionML=[DAN=Bilagstype;
                           ENU=Document Type];
                ToolTipML=[DAN=Angiver dokumenttypen.;
                           ENU=Specifies the type of document.];
                ApplicationArea=#Advanced;
                SourceExpr=FORMAT(ValueEntry."Document Type");
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Bilagsnr.;
                           ENU=Document No.];
                ToolTipML=[DAN=Angiver det salgsdokument, der reprësenterer relationen.;
                           ENU=Specifies the document that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Document No." }

    { 62  ;2   ;Field     ;
                CaptionML=[DAN=Dokumentlinjenr.;
                           ENU=Document Line No.];
                ToolTipML=[DAN=Angiver bilagslinjenummeret.;
                           ENU=Specifies the document line number.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."Document Line No.";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ToolTipML=[DAN=Angiver en beskrivelse af det salgsdokument, der reprësenterer relationen.;
                           ENU=Specifies a description of the document that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry.Description }

    { 16  ;2   ;Field     ;
                CaptionML=[DAN=Lokationskode;
                           ENU=Location Code];
                ToolTipML=[DAN=Angiver varens lokation.;
                           ENU=Specifies the location of the item.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."Location Code" }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Varebogfõringsgruppe;
                           ENU=Inventory Posting Group];
                ToolTipML=[DAN=Angiver den lagerbogfõringsgruppe, der reprësenterer relationen.;
                           ENU=Specifies the inventory posting group that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Inventory Posting Group" }

    { 48  ;2   ;Field     ;
                CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                           ENU=Gen. Bus. Posting Group];
                ToolTipML=[DAN=Angiver den generelle virksomhedsbogfõringsgruppe, der reprësenterer relationen.;
                           ENU=Specifies the general business posting group that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Gen. Bus. Posting Group" }

    { 50  ;2   ;Field     ;
                CaptionML=[DAN=Produktbogfõringsgruppe;
                           ENU=Gen. Prod. Posting Group];
                ToolTipML=[DAN=Angiver den generelle produktbogfõringsgruppe, der reprësenterer relationen.;
                           ENU=Specifies the general product posting group that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Gen. Prod. Posting Group" }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Kildebogf.gruppe;
                           ENU=Source Posting Group];
                ToolTipML=[DAN=Angiver den kildebogfõringsgruppe, der reprësenterer relationen.;
                           ENU=Specifies the source posting group that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Source Posting Group" }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Vareposttype;
                           ENU=Item Ledger Entry Type];
                ToolTipML=[DAN=Angiver den vareposttype, der reprësenterer relationen.;
                           ENU=Specifies the item ledger entry type that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=FORMAT(ValueEntry."Item Ledger Entry Type") }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=Varepostlõbenr.;
                           ENU=Item Ledger Entry No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den varepost, der reprësenterer relationen.;
                           ENU=Specifies the item ledger entry number that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Item Ledger Entry No." }

    { 24  ;2   ;Field     ;
                CaptionML=[DAN=Vërdiansat antal;
                           ENU=Valued Quantity];
                ToolTipML=[DAN=Angiver det vërdiansatte antal, der reprësenterer relationen.;
                           ENU=Specifies the valued quantity that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=ValueEntry."Valued Quantity" }

    { 26  ;2   ;Field     ;
                CaptionML=[DAN=Varepostmëngde;
                           ENU=Item Ledger Entry Quantity];
                ToolTipML=[DAN=Angiver den varepostmëngde, der reprësenterer relationen.;
                           ENU=Specifies the item ledger entry quantity that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=ValueEntry."Item Ledger Entry Quantity" }

    { 28  ;2   ;Field     ;
                CaptionML=[DAN=Faktureret antal;
                           ENU=Invoiced Quantity];
                ToolTipML=[DAN=Angiver det fakturerede antal, der reprësenterer relationen.;
                           ENU=Specifies the invoiced quantity that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=ValueEntry."Invoiced Quantity" }

    { 30  ;2   ;Field     ;
                CaptionML=[DAN=Kostpris pr. enhed;
                           ENU=Cost per Unit];
                ToolTipML=[DAN=Angiver den kostpris pr. enhed, der reprësenterer relationen.;
                           ENU=Specifies the cost per unit that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Cost per Unit" }

    { 34  ;2   ;Field     ;
                CaptionML=[DAN=Bruger-id;
                           ENU=User ID];
                ToolTipML=[DAN=Angiver den bruger, der oprettede vareposten.;
                           ENU=Specifies the user who created the item ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."User ID";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                CaptionML=[DAN=Kildespor;
                           ENU=Source Code];
                ToolTipML=[DAN=Angiver kilden.;
                           ENU=Specifies the source.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."Source Code";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                CaptionML=[DAN=Kostbelõb (faktisk);
                           ENU=Cost Amount (Actual)];
                ToolTipML=[DAN=Angiver summen af de faktiske kostbelõb, der er bogfõrt pÜ vareposterne;
                           ENU=Specifies the sum of the actual cost amounts posted for the item ledger entries];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Cost Amount (Actual)";
                AutoFormatType=1 }

    { 46  ;2   ;Field     ;
                CaptionML=[DAN=Bogfõrt kostvërdi;
                           ENU=Cost Posted to G/L];
                ToolTipML=[DAN=Angiver det belõb, som er blevet bogfõrt i finansregnskabet.;
                           ENU=Specifies the amount that has been posted to the general ledger.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Cost Posted to G/L";
                AutoFormatType=1 }

    { 54  ;2   ;Field     ;
                CaptionML=[DAN=Kostbelõb (faktisk) (EV);
                           ENU=Cost Amount (Actual) (ACY)];
                ToolTipML=[DAN=Angiver det faktiske kostbelõb for varen.;
                           ENU=Specifies the actual cost amount of the item.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."Cost Amount (Actual) (ACY)";
                AutoFormatType=1;
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                CaptionML=[DAN=Bogfõrt kostvërdi (EV);
                           ENU=Cost Posted to G/L (ACY)];
                ToolTipML=[DAN=Angiver det belõb, der er blevet bogfõrt i finansregnskabet, som vises i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the amount that has been posted to the general ledger shown in the additional reporting currency.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ValueEntry."Cost Posted to G/L (ACY)";
                AutoFormatType=1 }

    { 58  ;2   ;Field     ;
                CaptionML=[DAN=Kostvërdi pr. enhed (EV);
                           ENU=Cost per Unit (ACY)];
                ToolTipML=[DAN=Angiver omkostningen pr. enhed for finansposten.;
                           ENU=Specifies the cost per unit for the ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."Cost per Unit (ACY)";
                AutoFormatType=2;
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                CaptionML=[DAN=Global dimension 1-kode;
                           ENU=Global Dimension 1 Code];
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik pÜ analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilgëngelige pÜ alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr=ValueEntry."Global Dimension 1 Code";
                CaptionClass='1,1,1';
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                CaptionML=[DAN=Global dimension 2-kode;
                           ENU=Global Dimension 2 Code];
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik pÜ analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilgëngelige pÜ alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr=ValueEntry."Global Dimension 2 Code";
                CaptionClass='1,1,2';
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                CaptionML=[DAN=Forventet kostpris;
                           ENU=Expected Cost];
                ToolTipML=[DAN=Angiver vurderingen af en kõbt vares omkostning, som du registrerer, fõr du modtager fakturaen for varen.;
                           ENU=Specifies the estimation of a purchased item's cost that you record before you receive the invoice for the item.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."Expected Cost";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                CaptionML=[DAN=Varegebyrnr.;
                           ENU=Item Charge No.];
                ToolTipML=[DAN=Angiver nummeret pÜ det relaterede varegebyr.;
                           ENU=Specifies the number of the related item charge.];
                ApplicationArea=#ItemCharges;
                SourceExpr=ValueEntry."Item Charge No.";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                CaptionML=[DAN=Posttype;
                           ENU=Entry Type];
                ToolTipML=[DAN=Angiver den posttype, der reprësenterer relationen.;
                           ENU=Specifies the entry type that represents the relation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=FORMAT(ValueEntry."Entry Type") }

    { 70  ;2   ;Field     ;
                CaptionML=[DAN=Afvigelsestype;
                           ENU=Variance Type];
                ToolTipML=[DAN=Angiver afvigelsestypen, hvis det er relevant.;
                           ENU=Specifies the type of variance, if any.];
                ApplicationArea=#Manufacturing;
                SourceExpr=FORMAT(ValueEntry."Variance Type");
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                CaptionML=[DAN=Kostbelõb (forventet);
                           ENU=Cost Amount (Expected)];
                ToolTipML=[DAN=Angiver det forventede kostbelõb for varen. Forventede kostbelõb beregnes ud fra bilag, som endnu ikke er fakturerede.;
                           ENU=Specifies the expected cost amount of the item. Expected costs are calculated from yet non-invoiced documents.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."Cost Amount (Expected)";
                AutoFormatType=1;
                Visible=FALSE }

    { 76  ;2   ;Field     ;
                CaptionML=[DAN=Kostbelõb (forventet) (EV);
                           ENU=Cost Amount (Expected) (ACY)];
                ToolTipML=[DAN=Angiver det forventede kostbelõb for varen. Forventede kostbelõb beregnes ud fra bilag, som endnu ikke er fakturerede.;
                           ENU=Specifies the expected cost amount of the item. Expected costs are calculated from yet non-invoiced documents.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."Cost Amount (Expected) (ACY)";
                AutoFormatType=1;
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                CaptionML=[DAN=Bogfõrt forventet kostpris;
                           ENU=Expected Cost Posted to G/L];
                ToolTipML=[DAN=Angiver, at den forventede kostpris bogfõres pÜ mellemregningskonti ved modtagelsen.;
                           ENU=Specifies that the expected cost is posted to interim accounts at the time of receipt.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."Expected Cost Posted to G/L";
                AutoFormatType=1;
                Visible=FALSE }

    { 82  ;2   ;Field     ;
                CaptionML=[DAN=Bogfõrt forv. kostpris (EV);
                           ENU=Exp. Cost Posted to G/L (ACY)];
                ToolTipML=[DAN=Angiver den udgiftskostpris, der blev bogfõrt.;
                           ENU=Specifies the expense cost that was posted.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."Exp. Cost Posted to G/L (ACY)";
                AutoFormatType=1;
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                CaptionML=[DAN=Variantkode;
                           ENU=Variant Code];
                ToolTipML=[DAN=Angiver varevarianten, hvis det er relevant.;
                           ENU=Specifies the item variant, if any.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry."Variant Code";
                Visible=FALSE }

    { 86  ;2   ;Field     ;
                CaptionML=[DAN=Regulering;
                           ENU=Adjustment];
                ToolTipML=[DAN=Angiver kostreguleringen.;
                           ENU=Specifies the cost adjustment.];
                ApplicationArea=#Advanced;
                SourceExpr=ValueEntry.Adjustment;
                Visible=FALSE }

    { 88  ;2   ;Field     ;
                CaptionML=[DAN=Kapacitetspostlõbenr.;
                           ENU=Capacity Ledger Entry No.];
                ToolTipML=[DAN=Angiver finanspostnummeret.;
                           ENU=Specifies the ledger entry number.];
                ApplicationArea=#Manufacturing;
                SourceExpr=ValueEntry."Capacity Ledger Entry No.";
                Visible=FALSE }

    { 90  ;2   ;Field     ;
                CaptionML=[DAN=Type;
                           ENU=Type];
                ToolTipML=[DAN=Angiver relationstypen.;
                           ENU=Specifies the type of relation.];
                ApplicationArea=#Advanced;
                SourceExpr=FORMAT(ValueEntry.Type);
                Visible=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den finanspost, hvor kostprisen for den tilknyttede vërdipost i denne record er bogfõrt.;
                           ENU=Specifies the number of the general ledger entry where cost from the associated value entry number in this record is posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="G/L Entry No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lõbenummeret pÜ den vërdipost, hvis kostpris bogfõres i den tilknyttede finanspost i denne record.;
                           ENU=Specifies the number of the value entry that has its cost posted in the associated general ledger entry in this record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Value Entry No." }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den finansjournal, hvor finansposten i denne record blev bogfõrt.;
                           ENU=Specifies the number of the general ledger register, where the general ledger entry in this record was posted.];
                ApplicationArea=#Advanced;
                SourceExpr="G/L Register No.";
                Visible=FALSE }

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
    VAR
      ValueEntry@1000 : Record 5802;

    LOCAL PROCEDURE GetCaption@3() : Text[250];
    VAR
      GLRegister@1000 : Record 45;
    BEGIN
      EXIT(STRSUBSTNO('%1 %2',GLRegister.TABLECAPTION,GETFILTER("G/L Register No.")));
    END;

    BEGIN
    END.
  }
}

