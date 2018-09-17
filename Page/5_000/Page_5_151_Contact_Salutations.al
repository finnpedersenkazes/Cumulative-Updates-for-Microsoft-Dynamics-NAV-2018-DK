OBJECT Page 5151 Contact Salutations
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
    CaptionML=[DAN=Kontaktstarthilsener;
               ENU=Contact Salutations];
    SourceTable=Table5069;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#All;
                SourceExpr="Language Code" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om starthilsenen er formel eller uformel. Klik i feltet for at v‘lge.;
                           ENU=Specifies whether the salutation is formal or informal. Make your selection by clicking the field.];
                ApplicationArea=#All;
                SourceExpr="Salutation Type" }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Starthilsen;
                           ENU=Salutation];
                ToolTipML=[DAN=Angiver en hilsen. Brug en kode, der g›r det nemt at huske starthilsenen, f.eks. M-JOB for "Mand med stillingsbeskrivelse".;
                           ENU=Specifies a salutation. Use a code that makes it easy for you to remember the salutation, for example, M-JOB for "Male person with a job title".];
                ApplicationArea=#All;
                SourceExpr=GetContactSalutation }

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

