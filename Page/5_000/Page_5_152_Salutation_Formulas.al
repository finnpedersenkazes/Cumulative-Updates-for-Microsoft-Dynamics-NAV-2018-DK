OBJECT Page 5152 Salutation Formulas
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Starthilsenformler;
               ENU=Salutation Formulas];
    SourceTable=Table5069;
    DataCaptionFields=Salutation Code;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#All;
                SourceExpr="Language Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om starthilsenen er formel eller uformel. Klik i feltet for at v‘lge.;
                           ENU=Specifies whether the salutation is formal or informal. Make your selection by clicking the field.];
                ApplicationArea=#All;
                SourceExpr="Salutation Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver selve hilsenen.;
                           ENU=Specifies the salutation itself.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Salutation }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en hilsen. Der er f›lgende muligheder: Stilling, Fornavn, Mellemnavn, Efternavn, Initialer og Virksomhedsnavn.;
                           ENU=Specifies a salutation. The options are: Job Title, First Name, Middle Name, Surname, Initials and Company Name.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Name 1" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en hilsen. Der er f›lgende muligheder: Stilling, Fornavn, Mellemnavn, Efternavn, Initialer og Virksomhedsnavn.;
                           ENU=Specifies a salutation. The options are: Job Title, First Name, Middle Name, Surname, Initials and Company Name.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Name 2" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en hilsen. Der er f›lgende muligheder: Stilling, Fornavn, Mellemnavn, Efternavn, Initialer og Virksomhedsnavn.;
                           ENU=Specifies a salutation. The options are: Job Title, First Name, Middle Name, Surname, Initials and Company Name.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Name 3" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en hilsen. Der er f›lgende muligheder: Stilling, Fornavn, Mellemnavn, Efternavn, Initialer og Virksomhedsnavn.;
                           ENU=Specifies a salutation. The options are: Job Title, First Name, Middle Name, Surname, Initials and Company Name.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Name 4" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a starthilsen.;
                           ENU=Specifies a salutation.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Name 5" }

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

