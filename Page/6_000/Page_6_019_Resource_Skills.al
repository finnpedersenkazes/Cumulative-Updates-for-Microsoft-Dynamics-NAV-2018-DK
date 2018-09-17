OBJECT Page 6019 Resource Skills
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ressourcekvalifikationer;
               ENU=Resource Skills];
    SourceTable=Table5956;
    DataCaptionFields=No.,Skill Code;
    PageType=List;
    OnInit=BEGIN
             NoVisible := TRUE;
             SkillCodeVisible := TRUE;
             TypeVisible := TRUE;
           END;

    OnOpenPage=VAR
                 i@1000 : Integer;
               BEGIN
                 SkillCodeVisible := GETFILTER("Skill Code") = '';
                 NoVisible := GETFILTER("No.") = '';

                 TypeVisible := TRUE;

                 FOR i := 0 TO 3 DO BEGIN
                   FILTERGROUP(i);
                   IF GETFILTER(Type) <> '' THEN
                     TypeVisible := FALSE
                 END;

                 FILTERGROUP(0);
               END;

    OnDeleteRecord=BEGIN
                     CLEAR(ResSkill);
                     CurrPage.SETSELECTIONFILTER(ResSkill);
                     ResSkillMgt.PrepareRemoveMultipleResSkills(ResSkill);

                     ResSkillMgt.RemoveResSkill(Rec);

                     IF ResSkill.COUNT = 1 THEN
                       ResSkillMgt.DropGlobals;
                   END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kvalifikationstype, som er knyttet til posten.;
                           ENU=Specifies the skill type associated with the entry.];
                ApplicationArea=#Jobs;
                SourceExpr=Type;
                Visible=TypeVisible }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Jobs;
                SourceExpr="No.";
                Visible=NoVisible }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den kvalifikation, du vil tildele.;
                           ENU=Specifies the code of the skill you want to assign.];
                ApplicationArea=#Jobs;
                SourceExpr="Skill Code";
                Visible=SkillCodeVisible }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det objekt, eksempelvis en vare- eller serviceartikelgruppe, hvorfra kvalifikationskoden blev tildelt.;
                           ENU=Specifies the object, such as item or service item group, from which the skill code was assigned.];
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr="Assigned From";
                Editable=FALSE }

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
      ResSkill@1000 : Record 5956;
      ResSkillMgt@1003 : Codeunit 5931;
      TypeVisible@19063733 : Boolean INDATASET;
      SkillCodeVisible@19048210 : Boolean INDATASET;
      NoVisible@19001701 : Boolean INDATASET;

    BEGIN
    END.
  }
}

