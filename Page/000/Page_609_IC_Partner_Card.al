OBJECT Page 609 IC Partner Card
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Koncernintern partner;
               ENU=Intercompany Partner];
    SourceTable=Table413;
    PageType=Card;
    OnAfterGetRecord=BEGIN
                       SetInboxDetailsCaption;
                     END;

    OnNewRecord=BEGIN
                  SetInboxDetailsCaption;
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 27      ;1   ;ActionGroup;
                      CaptionML=[DAN=IC-&partner;
                                 ENU=IC &Partner];
                      Image=ICPartner }
      { 28      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=F† vist eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til koncerninterne transaktioner for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to intercompany transactions to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(413),
                                  No.=FIELD(Code);
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den koncerninterne partnerkode.;
                           ENU=Specifies the intercompany partner code.];
                ApplicationArea=#Intercompany;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den koncerninterne partner.;
                           ENU=Specifies the name of the intercompany partner.];
                ApplicationArea=#Intercompany;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#Intercompany;
                SourceExpr="Currency Code" }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Overflytningstype;
                           ENU=Transfer Type];
                ToolTipML=[DAN=Angiver, hvilken type indbakke den koncerninterne partner har. Filplacering. Du sender partneren en fil, der indeholder koncerninterne transaktioner. Database: Partneren konfigureres som en anden virksomhed i den samme database. Mail. Du sender partnertransaktionerne pr. mail.;
                           ENU=Specifies what type of inbox the intercompany partner has. File Location. You send the partner a file containing intercompany transactions. Database: The partner is set up as another company in the same database. Email: You send the partner transactions by email.];
                ApplicationArea=#Intercompany;
                SourceExpr="Inbox Type";
                OnValidate=BEGIN
                             SetInboxDetailsCaption;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysningerne om den koncerninterne partners indbakke.;
                           ENU=Specifies the details of the intercompany partner's inbox.];
                ApplicationArea=#Intercompany;
                SourceExpr="Inbox Details";
                CaptionClass=TransferTypeLbl;
                Enabled=EnableInboxDetails;
                Editable=EnableInboxDetails }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Automatisk accept af transaktioner;
                           ENU=Auto. Accept Transactions];
                ToolTipML=[DAN=Angiver, at transaktioner fra denne koncerninterne partner accepteres automatisk.;
                           ENU=Specifies that transactions from this intercompany partner are automatically accepted.];
                ApplicationArea=#Intercompany;
                SourceExpr="Auto. Accept Transactions";
                Enabled="Inbox Type" = "Inbox Type"::Database;
                Editable="Inbox Type" = "Inbox Type"::Database }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Intercompany;
                SourceExpr=Blocked }

    { 1904784501;1;Group  ;
                CaptionML=[DAN=Salgstransaktion;
                           ENU=Sales Transaction];
                GroupType=Group }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som er tilknyttet denne koncerninterne partner.;
                           ENU=Specifies the customer number that this intercompany partner is linked to.];
                ApplicationArea=#Intercompany;
                SourceExpr="Customer No.";
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE);
                             PropagateCustomerICPartner(xRec."Customer No.","Customer No.",Code);
                             FIND;
                           END;
                            }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer tilgodehavender fra debitorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post receivables from customers in this posting group.];
                ApplicationArea=#Intercompany;
                SourceExpr="Receivables Account" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket varenummer der bliver indsat i feltet Reference for IC-partner i forbindelse med varer p† k›bslinjer, som du sender til IC-partneren.;
                           ENU=Specifies what type of item number is entered in the IC Partner Reference field for items on purchase lines that you send to this IC partner.];
                ApplicationArea=#Advanced;
                SourceExpr="Outbound Sales Item No. Type" }

    { 11  ;1   ;Group     ;
                CaptionML=[DAN=K›bstransaktion;
                           ENU=Purchase Transaction];
                GroupType=Group }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, som er tilknyttet denne koncerneinterne partner.;
                           ENU=Specifies the vendor number that this intercompany partner is linked to.];
                ApplicationArea=#Intercompany;
                SourceExpr="Vendor No.";
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE);
                             PropagateVendorICPartner(xRec."Vendor No.","Vendor No.",Code);
                             FIND;
                           END;
                            }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer betalinger til kreditorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post payables due to vendors in this posting group.];
                ApplicationArea=#Intercompany;
                SourceExpr="Payables Account" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket varenummer der bliver indsat i feltet Reference for IC-partner i forbindelse med varer p† k›bslinjer, som du sender til IC-partneren.;
                           ENU=Specifies what type of item number is entered in the IC Partner Reference field for items on purchase lines that you send to this IC partner.];
                ApplicationArea=#Advanced;
                SourceExpr="Outbound Purch. Item No. Type" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om omkostninger allokeres i den lokale valuta til en eller flere IC-partnere.;
                           ENU=Specifies whether costs are allocated in local currency to one or several IC partners.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Distribution in LCY" }

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
      PermissionManager@1000 : Codeunit 9002;
      TransferTypeLbl@1001 : Text;
      CompanyNameTransferTypeTxt@1002 : TextConst 'DAN=Virksomhedsnavn;ENU=Company Name';
      FolderPathTransferTypeTxt@1003 : TextConst 'DAN=Mappesti;ENU=Folder Path';
      EmailAddressTransferTypeTxt@1004 : TextConst 'DAN=Mailadresse;ENU=Email Address';
      EnableInboxDetails@1006 : Boolean;

    LOCAL PROCEDURE SetInboxDetailsCaption@2();
    BEGIN
      EnableInboxDetails :=
        ("Inbox Type" <> "Inbox Type"::"No IC Transfer") AND
        NOT (("Inbox Type" = "Inbox Type"::"File Location") AND PermissionManager.SoftwareAsAService);
      CASE "Inbox Type" OF
        "Inbox Type"::Database:
          TransferTypeLbl := CompanyNameTransferTypeTxt;
        "Inbox Type"::"File Location":
          TransferTypeLbl := FolderPathTransferTypeTxt;
        "Inbox Type"::Email:
          TransferTypeLbl := EmailAddressTransferTypeTxt;
      END;
    END;

    BEGIN
    END.
  }
}

