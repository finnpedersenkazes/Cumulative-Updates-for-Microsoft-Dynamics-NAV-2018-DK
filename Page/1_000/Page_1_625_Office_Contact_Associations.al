OBJECT Page 1625 Office Contact Associations
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Office-kontaktrelationer;
               ENU=Office Contact Associations];
    SourceTable=Table1625;
    PageType=List;
    SourceTableTemporary=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Relaterede oplysninger;
                                ENU=New,Process,Report,Related Information];
    ShowFilter=No;
    OnAfterGetRecord=BEGIN
                       GetName;
                     END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 10      ;1   ;Action    ;
                      Name=Customer/Vendor;
                      ShortCutKey=Return;
                      CaptionML=[DAN=D&ebitor/kreditor;
                                 ENU=C&ustomer/Vendor];
                      ToolTipML=[DAN=Se den relaterede debitor- eller kreditorkonto, der er knyttet til den aktuelle record.;
                                 ENU=View the related customer or vendor account that is associated with the current record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ContactReference;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Contact@1001 : Record 5050;
                                 TempOfficeAddinContext@1003 : TEMPORARY Record 1600;
                                 OfficeMgt@1000 : Codeunit 1630;
                                 OfficeContactHandler@1002 : Codeunit 1636;
                               BEGIN
                                 OfficeMgt.GetContext(TempOfficeAddinContext);
                                 CASE "Associated Table" OF
                                   "Associated Table"::" ":
                                     BEGIN
                                       IF Contact.GET("Contact No.") THEN
                                         PAGE.RUN(PAGE::"Contact Card",Contact);
                                     END;
                                   "Associated Table"::Company,
                                   "Associated Table"::"Bank Account":
                                     BEGIN
                                       IF Contact.GET("Contact No.") THEN
                                         PAGE.RUN(PAGE::"Contact Card",Contact)
                                     END;
                                   ELSE
                                     OfficeContactHandler.ShowCustomerVendor(TempOfficeAddinContext,Contact,"Associated Table","No.");
                                 END;
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

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tabel, der er tilknyttet kontakten, f.eks. debitor, kreditor, bankkonto eller virksomhed.;
                           ENU=Specifies the table that is associated with the contact, such as Customer, Vendor, Bank Account, or Company.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Associated Table" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 7   ;2   ;Field     ;
                Name=Name;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p� kontakten.;
                           ENU=Specifies the name of the contact.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede Office-kontakt.;
                           ENU=Specifies the number of the associated Office contact.];
                ApplicationArea=#Advanced;
                SourceExpr="Contact No.";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontakttypen, f.eks. virksomhedslogoet eller kontaktpersonen.;
                           ENU=Specifies the type of the contact, such as company or contact person.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� Office-kontakten.;
                           ENU=Specifies the name of the Office contact.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Name" }

  }
  CODE
  {
    VAR
      Name@1000 : Text[50];

    LOCAL PROCEDURE GetName@2();
    VAR
      Customer@1000 : Record 18;
      Vendor@1001 : Record 23;
      Contact@1002 : Record 5050;
    BEGIN
      CASE "Associated Table" OF
        "Associated Table"::Customer:
          BEGIN
            IF Customer.GET("No.") THEN
              Name := Customer.Name;
          END;
        "Associated Table"::Vendor:
          BEGIN
            IF Vendor.GET("No.") THEN
              Name := Vendor.Name;
          END;
        "Associated Table"::Company:
          BEGIN
            IF Contact.GET("No.") THEN
              Name := Contact."Company Name";
          END;
        ELSE
          CLEAR(Name);
      END;
    END;

    BEGIN
    END.
  }
}

