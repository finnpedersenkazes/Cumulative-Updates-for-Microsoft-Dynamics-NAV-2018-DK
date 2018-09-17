OBJECT Page 6023 Skilled Resource List
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
    CaptionML=[DAN=Kval. ressourcer - oversigt;
               ENU=Skilled Resource List];
    SourceTable=Table156;
    DataCaptionExpr=GetCaption;
    PageType=List;
    CardPageID=Resource Card;
    OnAfterGetRecord=BEGIN
                       CLEAR(ServOrderAllocMgt);
                       Qualified := ServOrderAllocMgt.ResourceQualified("No.",ResourceSkillType,ResourceSkillNo);
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Kvalificeret;
                           ENU=Skilled];
                ToolTipML=[DAN=Angiver, at der kr�ves kvalifikationer for at reparere serviceartiklen, serviceartikelgruppen eller varen, hvis du har �bnet vinduet Kval. ressourcer - oversigt.;
                           ENU=Specifies that there are skills required to service the service item, service item group or item, if you have opened the Skilled Resource List window.];
                ApplicationArea=#Service;
                SourceExpr=Qualified;
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af ressourcen.;
                           ENU=Specifies a description of the resource.];
                ApplicationArea=#Service;
                SourceExpr=Name }

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
      ServOrderAllocMgt@1000 : Codeunit 5930;
      Qualified@1001 : Boolean;
      ResourceSkillType@1004 : 'Resource,Service Item Group,Item,Service Item';
      ResourceSkillNo@1005 : Code[20];
      Description@1006 : Text[50];

    [External]
    PROCEDURE Initialize@3(Type2@1000 : 'Resource,Service Item Group,Item,Service Item';No2@1001 : Code[20];Description2@1002 : Text[50]);
    BEGIN
      ResourceSkillType := Type2;
      ResourceSkillNo := No2;
      Description := Description2;
    END;

    LOCAL PROCEDURE GetCaption@4() Text : Text[260];
    BEGIN
      Text := COPYSTR(ResourceSkillNo + ' ' + Description,1,MAXSTRLEN(Text));
    END;

    BEGIN
    END.
  }
}

