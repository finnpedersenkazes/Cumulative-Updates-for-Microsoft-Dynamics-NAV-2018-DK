OBJECT Page 5920 Service Document Log
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
    CaptionML=[DAN=Servicedokumentlog;
               ENU=Service Document Log];
    SourceTable=Table5912;
    DataCaptionExpr=GetCaptionHeader;
    SourceTableView=SORTING(Change Date,Change Time)
                    ORDER(Descending);
    PageType=List;
    RefreshOnActivate=Yes;
    OnInit=BEGIN
             DocumentNoVisible := TRUE;
             DocumentTypeVisible := TRUE;
           END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 17      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Slet servicedokumentlog;
                                 ENU=&Delete Service Document Log];
                      ToolTipML=[DAN=Slet de poster, der automatisk logf›res for servicedokumenter, f.eks. un›dvendige poster eller poster, der ikke er opdaterede.;
                                 ENU=Delete the automatically generated service document log entries, for example, the unnecessary or outdated ones.];
                      ApplicationArea=#Service;
                      Image=Delete;
                      OnAction=VAR
                                 ServOrderLog@1002 : Record 5912;
                                 DeleteServOrderLog@1000 : Report 6002;
                               BEGIN
                                 ServOrderLog.SETRANGE("Document Type","Document Type");
                                 ServOrderLog.SETRANGE("Document No.","Document No.");
                                 DeleteServOrderLog.SETTABLEVIEW(ServOrderLog);
                                 DeleteServOrderLog.RUNMODAL;

                                 IF DeleteServOrderLog.GetOnPostReportStatus THEN BEGIN
                                   ServOrderLog.RESET;
                                   DeleteServOrderLog.GetServDocLog(ServOrderLog);
                                   COPYFILTERS(ServOrderLog);
                                   DELETEALL;
                                   RESET;
                                   SETCURRENTKEY("Change Date","Change Time");
                                   ASCENDING(FALSE);
                                 END;
                               END;
                                }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=Vi&s;
                                 ENU=&Show];
                      ToolTipML=[DAN=Vis logoplysningerne.;
                                 ENU=View the log details.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ServShptHeader@1001 : Record 5990;
                                 ServInvHeader@1002 : Record 5992;
                                 ServCrMemoHeader@1003 : Record 5994;
                                 PageManagement@1000 : Codeunit 700;
                                 isError@1004 : Boolean;
                               BEGIN
                                 IF "Document Type" IN
                                    ["Document Type"::Order,"Document Type"::Quote,
                                     "Document Type"::Invoice,"Document Type"::"Credit Memo"]
                                 THEN
                                   IF ServOrderHeaderRec.GET("Document Type","Document No.") THEN BEGIN
                                     isError := FALSE;
                                     PageManagement.PageRun(ServOrderHeaderRec);
                                   END ELSE
                                     isError := TRUE
                                 ELSE BEGIN // posted documents
                                   isError := TRUE;
                                   CASE "Document Type" OF
                                     "Document Type"::Shipment:
                                       IF ServShptHeader.GET("Document No.") THEN BEGIN
                                         isError := FALSE;
                                         PAGE.RUN(PAGE::"Posted Service Shipment",ServShptHeader);
                                       END;
                                     "Document Type"::"Posted Invoice":
                                       IF ServInvHeader.GET("Document No.") THEN BEGIN
                                         isError := FALSE;
                                         PAGE.RUN(PAGE::"Posted Service Invoice",ServInvHeader);
                                       END;
                                     "Document Type"::"Posted Credit Memo":
                                       IF ServCrMemoHeader.GET("Document No.") THEN BEGIN
                                         isError := FALSE;
                                         PAGE.RUN(PAGE::"Posted Service Credit Memo",ServCrMemoHeader);
                                       END;
                                   END;
                                 END;
                                 IF isError THEN
                                   ERROR(Text001,"Document Type","Document No.");
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

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for det servicedokument, der er foretaget ‘ndringer i.;
                           ENU=Specifies the type of the service document that underwent changes.];
                ApplicationArea=#Service;
                SourceExpr="Document Type";
                Visible=DocumentTypeVisible }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det servicedokument, der er foretaget ‘ndringer i.;
                           ENU=Specifies the number of the service document that has undergone changes.];
                ApplicationArea=#Service;
                SourceExpr="Document No.";
                Visible=DocumentNoVisible }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† serviceartikellinjen, hvis denne h‘ndelse er knyttet til en serviceartikellinje.;
                           ENU=Specifies the number of the service item line, if the event is linked to a service item line.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Line No.";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Service;
                SourceExpr="Entry No.";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ToolTipML=[DAN=Angiver beskrivelsen af den h‘ndelse, der forekom i et bestemt servicedokument.;
                           ENU=Specifies the description of the event that occurred to a particular service document.];
                ApplicationArea=#Service;
                SourceExpr=ServLogMgt.ServOrderEventDescription("Event No.") }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysningerne fra det ‘ndrede felt, efter h‘ndelsen har fundet sted.;
                           ENU=Specifies the contents of the modified field after the event takes place.];
                ApplicationArea=#Service;
                SourceExpr=After }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver indholdet af fra det ‘ndrede felt, f›r h‘ndelsen har fundet sted.;
                           ENU=Specifies the contents of the modified field before the event takes place.];
                ApplicationArea=#Service;
                SourceExpr=Before }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for h‘ndelsen.;
                           ENU=Specifies the date of the event.];
                ApplicationArea=#Service;
                SourceExpr="Change Date" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver klokkesl‘ttet for h‘ndelsen.;
                           ENU=Specifies the time of the event.];
                ApplicationArea=#Service;
                SourceExpr="Change Time" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Service;
                SourceExpr="User ID" }

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
      ServOrderHeaderRec@1001 : Record 5900;
      ServLogMgt@1000 : Codeunit 5906;
      Text001@1003 : TextConst '@@@=Service Order 2001 does not exist.;DAN=Tjenesten %1 %2 findes ikke.;ENU=Service %1 %2 does not exist.';
      DocumentTypeVisible@19012068 : Boolean INDATASET;
      DocumentNoVisible@19042234 : Boolean INDATASET;

    LOCAL PROCEDURE GetCaptionHeader@1() : Text[250];
    VAR
      ServHeader@1000 : Record 5900;
    BEGIN
      IF GETFILTER("Document No.") <> '' THEN BEGIN
        DocumentTypeVisible := FALSE;
        DocumentNoVisible := FALSE;
        IF ServHeader.GET("Document Type","Document No.") THEN
          EXIT(FORMAT("Document Type") + ' ' + "Document No." + ' ' + ServHeader.Description);

        EXIT(FORMAT("Document Type") + ' ' + "Document No.");
      END;

      DocumentTypeVisible := TRUE;
      DocumentNoVisible := TRUE;
      EXIT('');
    END;

    BEGIN
    END.
  }
}

