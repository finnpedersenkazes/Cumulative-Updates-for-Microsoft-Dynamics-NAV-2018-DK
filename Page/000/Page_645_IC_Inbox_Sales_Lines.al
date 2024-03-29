OBJECT Page 645 IC Inbox Sales Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table435;
    PageType=ListPart;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1903099104;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDimensions;
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
                ToolTipML=[DAN=Angiver den vare eller konto i IC-partnerens virksomhed, der svarer til varen eller kontoen p� linjen.;
                           ENU=Specifies the item or account in your IC partner's company that corresponds to the item or account on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Ref. Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den koncernspecifikke partner. Hvis denne linje sendes til en af dine koncerninterne partnere, bruges dette felt sammen med feltet Ref.type for IC-partner for at angive den vare eller den konto i partnerens regnskab, der svarer til linjen.;
                           ENU=Specifies the IC partner. If the line is being sent to one of your intercompany partners, this field is used together with the IC Partner Ref. Type field to indicate the item or account in your partner's company that corresponds to the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Reference" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten. Beskrivelsen er afh�ngig af, hvad du v�lger i feltet Type. Hvis du ikke har valgt at lade feltet v�re tomt, udfyldes det automatisk, n�r du indtaster noget i feltet Nummer.;
                           ENU=Specifies a description of the entry. The description depends on what you chose in the Type field. If you did not choose Blank, the program will fill in the field when you enter something in the No. field.];
                ApplicationArea=#Intercompany;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen, der angives p� linjen.;
                           ENU=Specifies how many units of the item will be specified on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr=Quantity }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for �n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f� den angivet i henhold til feltet Avancepct.beregning p� det dertilh�rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Intercompany;
                SourceExpr="Unit Price" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel�b, der ydes p� varen, p� linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="Line Discount Amount" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nettobel�bet inklusive moms for denne linje.;
                           ENU=Specifies the net amount, including VAT, for this line.];
                ApplicationArea=#Intercompany;
                SourceExpr="Amount Including VAT" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om din kreditor sender varerne p� linjen direkte til din debitor.;
                           ENU=Specifies if your vendor ships the items directly to your customer.];
                ApplicationArea=#Intercompany;
                SourceExpr="Drop Shipment";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel�b, der fungerer som grundlag for beregning i feltet Bel�b inkl. moms.;
                           ENU=Specifies the amount that serves as a base for calculating the Amount Including VAT field.];
                ApplicationArea=#Intercompany;
                SourceExpr="VAT Base Amount";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobel�b uden eventuelt fakturarabatbel�b, som skal betales for produkterne p� linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="Line Amount";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du har lovet at levere ordren som resultat af funktionen Beregning af leveringstid.;
                           ENU=Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.];
                ApplicationArea=#Intercompany;
                SourceExpr="Promised Delivery Date";
                Visible=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

