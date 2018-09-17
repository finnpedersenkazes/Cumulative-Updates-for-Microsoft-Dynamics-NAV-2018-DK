OBJECT Page 5062 Business Relation Contacts
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Forretn.relation - kontakt;
               ENU=Business Relation Contacts];
    SourceTable=Table5054;
    DataCaptionFields=Business Relation Code;
    PageType=List;
    OnInsertRecord=VAR
                     Contact@1001 : Record 5050;
                   BEGIN
                     Contact.TouchContact("Contact No.")
                   END;

    OnModifyRecord=VAR
                     Contact@1000 : Record 5050;
                   BEGIN
                     Contact.TouchContact("Contact No.")
                   END;

    OnDeleteRecord=VAR
                     Contact@1000 : Record 5050;
                   BEGIN
                     Contact.TouchContact("Contact No.")
                   END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktnummeret p† den virksomhed, som du tildeler en forretningsrelation til.;
                           ENU=Specifies the contact number of the company you are assigning a business relation.];
                ApplicationArea=#All;
                SourceExpr="Contact No." }

    { 4   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den kontaktvirksomhed, som du tildeler en forretningsrelation til. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies the name of the contact company to which you assign a business relation. This field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Name" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver navnet p† den tabel, som kontakten er knyttet til. Der er fire indstillinger: &lt;blank&gt;, Kreditor, Debitor og Bank.";
                           ENU="Specifies the name of the table to which the contact is linked. There are four possible options: &lt;blank&gt;, Vendor, Customer, and Bank Account."];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Link to Table" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="No." }

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

    BEGIN
    END.
  }
}

