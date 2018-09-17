OBJECT Page 1211 Data Exch Def List
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dataudvekslingsdefinitioner;
               ENU=Data Exchange Definitions];
    SourceTable=Table1222;
    PageType=List;
    CardPageID=Data Exch Def Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Import/eksport;
                                ENU=New,Process,Report,Import/Export];
    ActionList=ACTIONS
    {
      { 13      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Indl‘s dataudvekslingsdefinition;
                                 ENU=Import Data Exchange Definition];
                      ToolTipML=[DAN=Indl‘s en dataudvekslingsdefinition fra en bankfil, som er gemt p† computeren eller netv‘rket. Filtypen skal stemme overens med v‘rdien i feltet Filtype.;
                                 ENU=Import a data exchange definition from a bank file that is located on your computer or network. The file type must match the value of the File Type field.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 XMLPORT.RUN(XMLPORT::"Imp / Exp Data Exch Def & Map",FALSE,TRUE);
                               END;
                                }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Udl‘sÿdataudvekslingsdefinition;
                                 ENU=Export Data Exchange Definition];
                      ToolTipML=[DAN=Udl‘s dataudvekslingsdefinitionen til en fil p† computeren eller netv‘rket. Filen kan derefter overf›res til din elektroniske bank til behandling af de relaterede overf›rsler.;
                                 ENU=Export the data exchange definition to a file on your computer or network. You can then upload the file to your electronic bank to process the related transfers.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Export;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 DataExchDef@1000 : Record 1222;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(DataExchDef);
                                 XMLPORT.RUN(XMLPORT::"Imp / Exp Data Exch Def & Map",FALSE,FALSE,DataExchDef);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode, som identificerer ops‘tningen af dataudvekslingen.;
                           ENU=Specifies a code that identifies the data exchange setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† dataudvekslingsdefinitionen.;
                           ENU=Specifies the name of the data exchange definition.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den udvekslingstype, som dataudvekslingsdefinitionen bruges til. Du kan derefter v‘lge mellem tre filtyper.;
                           ENU=Specifies what type of exchange the data exchange definition is used for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type;
                ShowMandatory=TRUE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det codeunit, som overf›rer data til og fra tabellerne i Microsoft Dynamics NAV.;
                           ENU=Specifies the codeunit that transfers data in and out of tables in Microsoft Dynamics NAV.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Data Handling Codeunit" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det codeunit, der bruges til at validere data i forhold til foruddefinerede forretningsregler.;
                           ENU=Specifies the codeunit that is used to validate data against pre-defined business rules.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Validation Codeunit" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det codeunit, der behandler indl‘st data f›r tilknytning og udl‘st data efter tilknytning.;
                           ENU=Specifies the codeunit that processes imported data prior to mapping and exported data after mapping.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reading/Writing Codeunit";
                ShowMandatory=TRUE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver XMLport, hvor en importeret datafil eller tjeneste inds‘ttes f›r tilknytning, og hvor de eksporterede data findes, n†r de skrives til en datafil eller tjeneste efter tilknytning.;
                           ENU=Specifies the XMLport through which an imported data file or service enters prior to mapping and through which exported data exits when it is written to a data file or service after mapping.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reading/Writing XMLport";
                ShowMandatory=TRUE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det codeunit, som overf›rer ekstern data til og fra tabellerne i dataudvekslingsstrukturen.;
                           ENU=Specifies the codeunit that transfers external data in and out of the Data Exchange Framework.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ext. Data Handling Codeunit";
                ShowMandatory=TRUE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det codeunit, som udf›rer forskellige former for oprydning efter tilknytningen, f.eks. markering af linjerne som eksporterede og sletning af midlertidige records.;
                           ENU=Specifies the codeunit that does various clean-up after mapping, such as marks the lines as exported and deletes temporary records.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User Feedback Codeunit" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af hovedlinjer i filen. Dette sikrer, at hoveddata ikke importeres. Dette felt er kun relevant ved import.;
                           ENU=Specifies how many header lines exist in the file. This ensures that the header data is not imported. This field is only relevant for import.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Header Lines" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver teksten i den f›rste kolonne i hovedlinjen.;
                           ENU=Specifies the text of the first column on the header line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Header Tag" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver teksten i den f›rste kolonne i fodlinjen. Hvis der findes en fodlinje flere steder i filen, inds‘ttes teksten i den f›rste kolonne i fodlinjen for at sikre, at foddata ikke importeres. Dette felt er kun relevant ved import.;
                           ENU=Specifies the text of the first column on the footer line. If a footer line exists in several places in the file, enter the text of the first column on the footer line to ensure that the footer data is not imported. This field is only relevant for import.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Footer Tag" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan kolonnerne i filen adskilles, hvis filen er af typen Variable Text.;
                           ENU=Specifies how columns in the file are separated, if the file is of type Variable Text.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Column Separator" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kodning af filerne, som skal importeres. Dette felt er kun relevant ved import.;
                           ENU=Specifies the encoding of the file to be imported. This field is only relevant for import.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="File Encoding" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den filtype, som dataudvekslingsdefinitionen bruges til. Du kan derefter v‘lge mellem tre filtyper.;
                           ENU=Specifies what type of file the data exchange definition is used for. You can select between three file types.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="File Type";
                ShowMandatory=TRUE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

