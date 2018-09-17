OBJECT Page 390 Phys. Inventory Ledger Entries
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
    CaptionML=[DAN=Lageropg›relsesposter;
               ENU=Phys. Inventory Ledger Entries];
    SourceTable=Table281;
    DataCaptionFields=Item No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 52      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 53      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr‘ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Dimensions;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 45      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Advanced;
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for bogf›ringen af lageropg›relseskladden, der oprettede denne post.;
                           ENU=Specifies the date on which you posted the Physical Inventory Journal that created this ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, der blev bogf›rt fra den lageropg›relseskladde, som oprettede posten.;
                           ENU=Specifies the type of transaction that was posted from the Physical Inventory Journal that created the ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for den fysiske lagerpost.;
                           ENU=Specifies the document number on the physical inventory ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† varen i finansposten.;
                           ENU=Specifies the number of the item in the ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No." }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen i finansposten.;
                           ENU=Specifies a description of the item in the ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationskoden for varen i finansposten.;
                           ENU=Specifies the code of the location for the item in the ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den automatisk beregnede beholdning for varen i finansposten.;
                           ENU=Specifies the quantity on hand, as calculated by the program, of the item in the ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. (Calculated)" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den faktiske beholdning af varen i finansposten, opgjort ved fysisk t‘lling.;
                           ENU=Specifies the actual quantity on hand, as determined by taking a physical inventory, of the item in the ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. (Phys. Inventory)" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem m‘ngderne i felterne Antal (Beregnet) og Antal (Lageropg›relse) for finansposten.;
                           ENU=Specifies the difference between the quantities in the Quantity (Calculated) field and the Quantity (Physical Inventory) field for ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Quantity }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen p† en enhed af varen i finansposten.;
                           ENU=Specifies the amount for one unit of the item in the ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Amount";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede bel›b for varerne i finansposten.;
                           ENU=Specifies the total amount for the items in the ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Amount }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den sidste varepost, der l† til grund for finansposten for det fysiske lager.;
                           ENU=Specifies the number of the last item ledger entry that provided the basis for the physical inventory ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Item Ledger Entry No." }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No." }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv‘rdier. De faktiske v‘rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Dimensions;
                SourceExpr="Dimension Set ID";
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
      Navigate@1000 : Page 344;
      DimensionSetIDFilter@1001 : Page 481;

    BEGIN
    END.
  }
}

