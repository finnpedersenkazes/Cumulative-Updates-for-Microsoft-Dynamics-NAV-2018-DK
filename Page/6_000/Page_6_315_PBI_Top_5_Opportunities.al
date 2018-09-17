OBJECT Page 6315 PBI Top 5 Opportunities
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
    CaptionML=[DAN=5 vigtigste PBI-salgsmuligheder;
               ENU=PBI Top 5 Opportunities];
    SourceTable=Table6305;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=VAR
                 PBITopOpportunitiesCalc@1000 : Codeunit 6310;
               BEGIN
                 PBITopOpportunitiesCalc.GetValues(Rec);
               END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Id;
                           ENU=ID];
                ToolTipML=[DAN=Angiver id'et.;
                           ENU=Specifies the ID.];
                ApplicationArea=#All;
                SourceExpr=ID }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Salgsmulighedsnummer;
                           ENU=Opportunity No.];
                ToolTipML=[DAN=Angiver salgsmuligheden.;
                           ENU=Specifies the opportunity.];
                ApplicationArea=#All;
                SourceExpr="Measure No." }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=V‘rdi;
                           ENU=Value];
                ToolTipML=[DAN=Angiver v‘rdien.;
                           ENU=Specifies the value.];
                ApplicationArea=#All;
                SourceExpr=Value }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Navn p† m†l;
                           ENU=Measure Name];
                ToolTipML=[DAN=Angiver navnet.;
                           ENU=Specifies the name.];
                ApplicationArea=#All;
                SourceExpr="Measure Name" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

