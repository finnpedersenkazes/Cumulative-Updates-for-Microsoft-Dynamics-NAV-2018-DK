OBJECT Page 5605 FA Error Ledger Entries
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
    CaptionML=[DAN=Anl�gsfejlposter;
               ENU=FA Error Ledger Entries];
    SourceTable=Table5601;
    DataCaptionFields=Canceled from FA No.,Depreciation Book Code;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 34      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr�ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Suite;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf�ringsdatoen p� den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#FixedAssets;
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

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf�ringsdatoen for den relaterede anl�gstransaktion, f.eks. en afskrivning.;
                           ENU=Specifies the posting date of the related fixed asset transaction, such as a depreciation.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Posting Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dokumenttypen for posten.;
                           ENU=Specifies the entry document type.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Document Type" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p� posten.;
                           ENU=Specifies the document number on the entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Document No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det anl�g, der er knyttet til den oprindelige post, som denne anl�gsfejlpost blev oprettet fra.;
                           ENU=Specifies the number of the fixed asset linked to the original entry, from which this fixed asset error ledger entry was created.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Canceled from FA No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf�res til, hvis du har valgt Anl�gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Book Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf�ringskategori, som posten blev tildelt, da den blev bogf�rt.;
                           ENU=Specifies the posting category assigned to the entry when it was posted.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Posting Category" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf�ringstypen, hvis feltet Kontotype indeholder Anl�gsaktiv.;
                           ENU=Specifies the posting type, if Account Type field contains Fixed Asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Posting Type" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bel�b i valutaen.;
                           ENU=Specifies the entry amount in currency.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Amount }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten blev oprettet for at ompostere et anl�g, f.eks. for at �ndre den dimension, som anl�gget er tilknyttet.;
                           ENU=Specifies whether the entry was made to reclassify a fixed asset, for example, to change the dimension the fixed asset is linked to.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reclassification Entry" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at posten er en indekspost.;
                           ENU=Specifies this entry is an index entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Index Entry";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal afskrivningsdage, som blev benyttet til beregning af afskrivningen p� anl�gsposten.;
                           ENU=Specifies the number of depreciation days that were used for calculating depreciation for the fixed asset entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="No. of Depreciation Days" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf�res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Bal. Account Type";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf�res til, f.eks. en kassekonto ved kontantk�b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Bal. Account No.";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf�rt posten, der skal bruges, f.eks. i �ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#FixedAssets;
                SourceExpr="User ID";
                Visible=FALSE }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �rsagskoden som et supplerende kildespor, der hj�lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf�ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Posting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l�benummeret p� den finanspost, som blev oprettet i finansregnskabet for anl�gstransaktionen.;
                           ENU=Specifies the G/L number for the entry that was created in the general ledger for this fixed asset transaction.];
                ApplicationArea=#FixedAssets;
                SourceExpr="G/L Entry No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Entry No." }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv�rdier. De faktiske v�rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Suite;
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

