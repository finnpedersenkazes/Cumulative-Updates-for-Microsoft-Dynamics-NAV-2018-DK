OBJECT Page 780 Certificates of Supply
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Leveringscertifikater;
               ENU=Certificates of Supply];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table780;
    PageType=List;
    OnOpenPage=BEGIN
                 IF GETFILTERS = '' THEN
                   SETFILTER(Status,'<>%1',Status::"Not Applicable")
                 ELSE
                   InitRecord("Document Type","Document No.")
               END;

    ActionList=ACTIONS
    {
      { 13      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 14      ;1   ;Action    ;
                      Name=PrintCertificateofSupply;
                      CaptionML=[DAN=Udskriv leveringscertifikat;
                                 ENU=Print Certificate of Supply];
                      ToolTipML=[DAN=Udskriv det leveringscertifikat, der skal sendes til signatur hos din debitor som bekr‘ftelse p† modtagelsen.;
                                 ENU=Print the certificate of supply that you must send to your customer for signature as confirmation of receipt.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=PrintReport;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CertificateOfSupply@1000 : Record 780;
                               BEGIN
                                 IF NOT ISEMPTY THEN BEGIN
                                   CertificateOfSupply.COPY(Rec);
                                   CertificateOfSupply.SETRANGE("Document Type","Document Type");
                                   CertificateOfSupply.SETRANGE("Document No.","Document No.");
                                 END;
                                 CertificateOfSupply.Print;
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
                ToolTipML=[DAN=Angiver den type af bogf›rte bilag, som leveringscertifikatet vedr›rer.;
                           ENU=Specifies the type of the posted document to which the certificate of supply applies.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Type";
                Editable=False }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for det bogf›rte leveringsbilag, som er tilknyttet leveringscertifikatet.;
                           ENU=Specifies the document number of the posted shipment document associated with the certificate of supply.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No.";
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver statussen for bilag, hvor du skal modtage et signeret leveringscertifikat fra debitoren.;
                           ENU=Specifies the status for documents where you must receive a signed certificate of supply from the customer.];
                ApplicationArea=#Advanced;
                SourceExpr=Status }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver modtagelsesdatoen for det signerede leveringscertifikat.;
                           ENU=Specifies the receipt date of the signed certificate of supply.];
                ApplicationArea=#Advanced;
                SourceExpr="Receipt Date" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om leveringscertifikatet udskrives og sendes til debitoren.;
                           ENU=Specifies whether the certificate of supply has been printed and sent to the customer.];
                ApplicationArea=#Advanced;
                SourceExpr=Printed;
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                Name=Customer/Vendor Name;
                ToolTipML=[DAN=Angiver navnet p† debitoren eller kreditoren.;
                           ENU=Specifies the name of the customer or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Customer/Vendor Name" }

    { 11  ;2   ;Field     ;
                Name=Shipment Date;
                ToolTipML=[DAN=Angiver den dato, hvor den bogf›rte levering blev leveret eller bogf›rt.;
                           ENU=Specifies the date that the posted shipment was shipped or posted.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment/Posting Date" }

    { 12  ;2   ;Field     ;
                Name=Shipment Country;
                ToolTipML=[DAN=Angiver lande-/omr†dekoden p† den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† debitoren eller kreditoren.;
                           ENU=Specifies the number of the customer or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Customer/Vendor No.";
                Editable=False }

    { 10  ;2   ;Field     ;
                Name=Shipment Method;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver k›ret›jets registreringsnummer, der er tilknyttet leverancen.;
                           ENU=Specifies the vehicle registration number associated with the shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Vehicle Registration No." }

  }
  CODE
  {

    BEGIN
    END.
  }
}

