OBJECT Page 5990 Troubleshooting
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Fejlfinding;
               ENU=Troubleshooting];
    SourceTable=Table5943;
    PageType=ListPlus;
    OnOpenPage=BEGIN
                 IF CaptionCode <> '' THEN
                   CurrPage.CAPTION := CaptionCode + ' ' + CaptionDescription + ' - ' + CurrPage.CAPTION;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=F&ejlfinding;
                                 ENU=T&roublesh.];
                      Image=Setup }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Ops�tning;
                                 ENU=Setup];
                      ToolTipML=[DAN=Konfigurer fejlfinding.;
                                 ENU=Set up troubleshooting.];
                      ApplicationArea=#Service;
                      Image=Setup;
                      OnAction=BEGIN
                                 TblshtgSetup.RESET;
                                 TblshtgSetup.SETCURRENTKEY("Troubleshooting No.");
                                 TblshtgSetup.SETRANGE("Troubleshooting No.","No.");
                                 PAGE.RUNMODAL(PAGE::"Troubleshooting Setup",TblshtgSetup)
                               END;
                                }
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af det problem, der skal l�ses.;
                           ENU=Specifies a description of the troubleshooting issue.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 7   ;1   ;Part      ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page5992;
                PartType=Page }

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
      TblshtgSetup@1000 : Record 5945;
      CaptionCode@1001 : Code[20];
      CaptionDescription@1002 : Text[30];

    [External]
    PROCEDURE SetCaption@1(CaptionCode2@1000 : Code[20];CaptionDescription2@1001 : Text[30]);
    BEGIN
      CaptionCode := CaptionCode2;
      CaptionDescription := CaptionDescription2;
    END;

    BEGIN
    END.
  }
}

