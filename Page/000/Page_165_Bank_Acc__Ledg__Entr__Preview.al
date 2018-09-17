OBJECT Page 165 Bank Acc. Ledg. Entr. Preview
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
    CaptionML=[DAN=Vis bankposter;
               ENU=Bank Acc. Ledg. Entr. Preview];
    SourceTable=Table271;
    DataCaptionFields=Bank Account No.;
    PageType=List;
    SourceTableTemporary=Yes;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 25      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 GenJnlPostPreview@1000 : Codeunit 19;
                               BEGIN
                                 GenJnlPostPreview.ShowDimensions(DATABASE::"Bank Account Ledger Entry","Entry No.","Dimension Set ID");
                               END;
                                }
      { 13      ;2   ;Action    ;
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
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf�ringsdato.;
                           ENU=Specifies the entry's Posting Date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Dokumenttypen p� bankposten. dokumenttypen er Indbetaling eller Refusion, eller feltet er tomt.;
                           ENU=Specifies the document type on the bank account entry. The document type will be Payment, Refund, or the field will be blank.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for bankposten.;
                           ENU=Specifies the document number on the bank account entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den bankkonto, der benyttes til posten.;
                           ENU=Specifies the number of the bank account used for the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af bankposten.;
                           ENU=Specifies the description of the bank account entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den medarbejder, der er ansvarlig for bankkontoen.;
                           ENU=Specifies the code for the employee who is responsible for the bank account.];
                ApplicationArea=#Advanced;
                SourceExpr="Our Contact Code";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency code used in the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel�bet for posten, angivet i den relevante udenlandske valuta.;
                           ENU=Specifies the amount of the entry denominated in the applicable foreign currency.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel�bet for posten i regnskabsvalutaen.;
                           ENU=Specifies the amount of the entry in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Amount (LCY)";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer debiteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent debits, expressed in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Debit Amount (LCY)";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer krediteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent credits, expressed in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Credit Amount (LCY)";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel�b, som mangler at blive udlignet, hvis posten ikke er fuldst�ndig udlignet.;
                           ENU=Specifies the amount that remains to be applied to if the entry has not been completely applied to.];
                ApplicationArea=#Advanced;
                SourceExpr="Remaining Amount";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf�res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. Account Type";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf�res til, f.eks. en kassekonto ved kontantk�b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. Account No.";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bel�bet i bankposten er helt udlignet, eller om der stadig er et udest�ende bel�b, som skal udlignes.;
                           ENU=Specifies whether the amount on the bank account entry has been fully applied to or if there is still a remaining amount that must be applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Open }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf�rt posten, der skal bruges, f.eks. i �ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �rsagskoden som et supplerende kildespor, der hj�lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten har v�ret en del af en tilbagef�rt transaktion.;
                           ENU=Specifies if the entry has been part of a reverse transaction.];
                ApplicationArea=#Advanced;
                SourceExpr=Reversed;
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den korrigerende post, der erstattede den oprindelige post i den tilbagef�rte transaktion.;
                           ENU=Specifies the number of the correcting entry that replaced the original entry in the reverse transaction.];
                ApplicationArea=#Advanced;
                SourceExpr="Reversed by Entry No.";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den oprindelige post, der blev annulleret ved tilbagef�rselstransaktionen.;
                           ENU=Specifies the number of the original entry that was undone by the reverse transaction.];
                ApplicationArea=#Advanced;
                SourceExpr="Reversed Entry No.";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv�rdier. De faktiske v�rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension Set ID";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      DimensionSetIDFilter@1000 : Page 481;

    BEGIN
    END.
  }
}

