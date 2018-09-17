OBJECT Page 5986 Service Item Component List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Komponentoversigt - serviceart.;
               ENU=Service Item Component List];
    SourceTable=Table5941;
    DelayedInsert=Yes;
    DataCaptionFields=Parent Service Item No.,Line No.;
    PageType=List;
    OnInsertRecord=BEGIN
                     "Line No." := SplitLineNo(xRec,BelowxRec);
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ko&mponent;
                                 ENU=Com&ponent];
                      Image=Components }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=&Kopier fra stykliste;
                                 ENU=&Copy from BOM];
                      ToolTipML=[DAN="Inds‘t serviceartikelkomponenterne p† serviceartiklens stykliste. ";
                                 ENU="Insert the service item components of the service item's bill of material. "];
                      ApplicationArea=#Service;
                      Image=CopyFromBOM;
                      OnAction=BEGIN
                                 ServItem.GET("Parent Service Item No.");
                                 CODEUNIT.RUN(CODEUNIT::"ServComponent-Copy from BOM",ServItem);
                               END;
                                }
      { 33      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Erstattet liste;
                                 ENU=&Replaced List];
                      Image=ItemSubstitution }
      { 34      ;3   ;Action    ;
                      Name=ThisLine;
                      CaptionML=[DAN=Denne linje;
                                 ENU=This Line];
                      ToolTipML=[DAN=Vis eller rediger listen over serviceartikelkomponenter, der er erstattet for den valgte serviceartikelkomponent.;
                                 ENU=View or edit the list of service item components that have been replaced for the selected service item component.];
                      ApplicationArea=#Service;
                      RunObject=Page 5987;
                      RunPageView=SORTING(Active,Parent Service Item No.,From Line No.);
                      RunPageLink=Active=CONST(No),
                                  Parent Service Item No.=FIELD(Parent Service Item No.),
                                  From Line No.=FIELD(Line No.);
                      Image=Line }
      { 35      ;3   ;Action    ;
                      Name=AllLines;
                      CaptionML=[DAN=Alle linjer;
                                 ENU=All Lines];
                      ToolTipML=[DAN=Vis eller rediger listen over alle serviceartikelkomponenter, der er blevet erstattet.;
                                 ENU=View or edit the list of all service item components that have been replaced.];
                      ApplicationArea=#Service;
                      RunObject=Page 5987;
                      RunPageView=SORTING(Active,Parent Service Item No.,From Line No.);
                      RunPageLink=Active=CONST(No),
                                  Parent Service Item No.=FIELD(Parent Service Item No.);
                      Image=AllLines }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceartikel, som komponenten indg†r i.;
                           ENU=Specifies the number of the service item in which the component is included.];
                ApplicationArea=#Service;
                SourceExpr="Parent Service Item No.";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† linjen.;
                           ENU=Specifies the number of the line.];
                ApplicationArea=#Service;
                SourceExpr="Line No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at komponenten er i brug.;
                           ENU=Specifies that the component is in use.];
                ApplicationArea=#Service;
                SourceExpr=Active;
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver komponenttypen.;
                           ENU=Specifies the component type.];
                ApplicationArea=#Service;
                SourceExpr=Type }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af komponenten.;
                           ENU=Specifies a description of the component.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p† komponenten.;
                           ENU=Specifies the serial number of the component.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                OnAssistEdit=BEGIN
                               AssistEditSerialNo;
                             END;
                              }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor komponenten blev installeret.;
                           ENU=Specifies the date when the component was installed.];
                ApplicationArea=#Service;
                SourceExpr="Date Installed" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det linjenummer, der er tildelt komponenten, da den er en aktiv del af serviceartiklen.;
                           ENU=Specifies the line number assigned to the component when it was an active component of the service item.];
                ApplicationArea=#Service;
                SourceExpr="From Line No.";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor komponenten sidst blev ‘ndret.;
                           ENU=Specifies the date when the component was last modified.];
                ApplicationArea=#Service;
                SourceExpr="Last Date Modified";
                Visible=FALSE }

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
      ServItem@1000 : Record 5940;

    BEGIN
    END.
  }
}

