OBJECT Page 5993 Troubleshooting Setup
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ops‘tning af Fejlfinding;
               ENU=Troubleshooting Setup];
    SourceTable=Table5945;
    DelayedInsert=Yes;
    DataCaptionFields=No.;
    PageType=List;
    OnInit=BEGIN
             NoVisible := TRUE;
             TypeVisible := TRUE;
           END;

    OnOpenPage=BEGIN
                 TypeVisible := GETFILTER(Type) = '';
                 NoVisible := GETFILTER("No.") = '';

                 IF (GETFILTER(Type) <> '') AND (GETFILTER("No.") <> '') THEN BEGIN
                   RecType := GETRANGEMIN(Type);
                   No := GETRANGEMIN("No.");
                 END;
               END;

    OnNewRecord=BEGIN
                  VALIDATE(Type,RecType);
                  VALIDATE("No.",No);
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&ejlfinding;
                                 ENU=T&roublesh.];
                      Image=Setup }
      { 14      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Service;
                      Image=EditLines;
                      OnAction=BEGIN
                                 CLEAR(Tblshtg);
                                 IF TblshtgHeader.GET("Troubleshooting No.") THEN
                                   IF "No." <> '' THEN BEGIN
                                     Tblshtg.SetCaption(FORMAT(Type),"No.");
                                     Tblshtg.SETRECORD(TblshtgHeader);
                                   END;

                                 Tblshtg.RUN;
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

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type problem der skal l›ses.;
                           ENU=Specifies the type of troubleshooting issue.];
                ApplicationArea=#Service;
                SourceExpr=Type;
                Visible=TypeVisible }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No.";
                Visible=NoVisible }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det problem, der skal l›ses.;
                           ENU=Specifies the number of the troubleshooting issue.];
                ApplicationArea=#Service;
                SourceExpr="Troubleshooting No." }

    { 6   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver en beskrivelse af det problem, der skal l›ses.;
                           ENU=Specifies a description of the troubleshooting issue.];
                ApplicationArea=#Service;
                SourceExpr="Troubleshooting Description" }

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
      TblshtgHeader@1000 : Record 5943;
      Tblshtg@1001 : Page 5990;
      TypeVisible@19063733 : Boolean INDATASET;
      NoVisible@19001701 : Boolean INDATASET;
      RecType@1003 : Option;
      No@1002 : Code[20];

    BEGIN
    END.
  }
}

