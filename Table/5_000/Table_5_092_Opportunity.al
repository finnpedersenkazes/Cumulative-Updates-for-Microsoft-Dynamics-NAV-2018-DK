OBJECT Table 5092 Opportunity
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Description;
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 RMSetup.GET;
                 RMSetup.TESTFIELD("Opportunity Nos.");
                 NoSeriesMgt.InitSeries(RMSetup."Opportunity Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;

               IF "Salesperson Code" = '' THEN
                 SetDefaultSalesperson;

               "Creation Date" := WORKDATE;
             END;

    OnDelete=VAR
               OppEntry@1000 : Record 5093;
             BEGIN
               IF Status = Status::"In Progress" THEN
                 ERROR(Text000);

               RMCommentLine.SETRANGE("Table Name",RMCommentLine."Table Name"::Opportunity);
               RMCommentLine.SETRANGE("No.","No.");
               RMCommentLine.DELETEALL;

               OppEntry.SETCURRENTKEY("Opportunity No.");
               OppEntry.SETRANGE("Opportunity No.","No.");
               OppEntry.DELETEALL;
             END;

    CaptionML=[DAN=Salgsmulighed;
               ENU=Opportunity];
    LookupPageID=Page5123;
    DrillDownPageID=Page5123;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  RMSetup.GET;
                                                                  NoSeriesMgt.TestManual(RMSetup."Opportunity Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   OnValidate=VAR
                                                                Task@1000 : Record 5080;
                                                                Task2@1004 : Record 5080;
                                                                OppEntry@1001 : Record 5093;
                                                                Attendee@1005 : Record 5199;
                                                                Window@1009 : Dialog;
                                                                TotalRecordsNumber@1003 : Integer;
                                                                Counter@1002 : Integer;
                                                              BEGIN
                                                                IF ("Salesperson Code" <> xRec."Salesperson Code") AND
                                                                   (xRec."Salesperson Code" <> '') AND
                                                                   ("No." <> '')
                                                                THEN BEGIN
                                                                  TESTFIELD("Salesperson Code");
                                                                  Task.RESET;
                                                                  Task.SETCURRENTKEY("Opportunity No.",Date,Closed);
                                                                  Task.SETRANGE("Opportunity No.","No.");
                                                                  Task.SETRANGE(Closed,FALSE);
                                                                  Task.SETRANGE("Salesperson Code",xRec."Salesperson Code");
                                                                  TotalRecordsNumber := Task.COUNT;
                                                                  Counter := 0;
                                                                  IF Task.FIND('-') THEN
                                                                    IF CONFIRM(ChangeConfirmQst,FALSE,FIELDCAPTION("Salesperson Code")) THEN BEGIN
                                                                      Window.OPEN(Text012 + Text013);
                                                                      Window.UPDATE(2,Text014);
                                                                      REPEAT
                                                                        Counter := Counter + 1;
                                                                        Window.UPDATE(1,ROUND(Counter / TotalRecordsNumber * 10000,1));
                                                                        IF Task.Type = Task.Type::Meeting THEN BEGIN
                                                                          Task.GetMeetingOrganizerTask(Task2);
                                                                          IF Task."Salesperson Code" <> Task2."Salesperson Code" THEN BEGIN
                                                                            Task.VALIDATE("Salesperson Code","Salesperson Code");
                                                                            Task.MODIFY;
                                                                          END;
                                                                          Attendee.RESET;
                                                                          Attendee.SETRANGE("To-do No.",Task2."No.");
                                                                          Attendee.SETRANGE("Attendee No.",xRec."Salesperson Code");
                                                                          Attendee.SETRANGE("Attendee Type",Attendee."Attendee Type"::Salesperson);
                                                                          Attendee.SETRANGE("Attendance Type",Attendee."Attendance Type"::Required,Attendee."Attendance Type"::Optional);
                                                                          IF Attendee.FINDFIRST THEN BEGIN
                                                                            Attendee.VALIDATE("Attendee No.","Salesperson Code");
                                                                            Attendee.MODIFY(TRUE);
                                                                          END;
                                                                        END
                                                                        ELSE BEGIN
                                                                          Task.VALIDATE("Salesperson Code","Salesperson Code");
                                                                          Task.MODIFY(TRUE);
                                                                        END;
                                                                      UNTIL Task.NEXT = 0;
                                                                      Window.CLOSE;
                                                                    END;

                                                                  OppEntry.RESET;
                                                                  OppEntry.SETCURRENTKEY(Active,"Opportunity No.");
                                                                  OppEntry.SETRANGE(Active,TRUE);
                                                                  OppEntry.SETRANGE("Opportunity No.","No.");
                                                                  IF OppEntry.FIND('-') THEN
                                                                    REPEAT
                                                                      OppEntry."Salesperson Code" := "Salesperson Code";
                                                                      OppEntry.MODIFY;
                                                                    UNTIL OppEntry.NEXT = 0;

                                                                  MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=S�lgerkode;
                                                              ENU=Salesperson Code] }
    { 4   ;   ;Campaign No.        ;Code20        ;TableRelation=Campaign;
                                                   OnValidate=VAR
                                                                Task@1001 : Record 5080;
                                                                OppEntry@1000 : Record 5093;
                                                              BEGIN
                                                                IF ("Campaign No." <> xRec."Campaign No.") AND
                                                                   ("No." <> '')
                                                                THEN BEGIN
                                                                  CheckCampaign;
                                                                  SetDefaultSegmentNo;
                                                                  Task.RESET;
                                                                  Task.SETCURRENTKEY("Opportunity No.",Date,Closed);
                                                                  Task.SETRANGE("Opportunity No.","No.");
                                                                  Task.SETRANGE(Closed,FALSE);
                                                                  Task.SETRANGE("Campaign No.",xRec."Campaign No.");
                                                                  IF Task.FIND('-') THEN
                                                                    IF CONFIRM(ChangeConfirmQst,FALSE,FIELDCAPTION("Campaign No.")) THEN
                                                                      REPEAT
                                                                        Task."Campaign No." := "Campaign No.";
                                                                        Task.MODIFY;
                                                                      UNTIL Task.NEXT = 0;

                                                                  OppEntry.RESET;
                                                                  OppEntry.SETCURRENTKEY(Active,"Opportunity No.");
                                                                  OppEntry.SETRANGE(Active,TRUE);
                                                                  OppEntry.SETRANGE("Opportunity No.","No.");
                                                                  IF OppEntry.FIND('-') THEN
                                                                    REPEAT
                                                                      OppEntry."Campaign No." := "Campaign No.";
                                                                      OppEntry.MODIFY;
                                                                    UNTIL OppEntry.NEXT = 0;

                                                                  MODIFY;
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              LookupCampaigns;
                                                            END;

                                                   CaptionML=[DAN=Kampagnenr.;
                                                              ENU=Campaign No.] }
    { 5   ;   ;Contact No.         ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                Cont@1000 : Record 5050;
                                                                Task@1002 : Record 5080;
                                                                Task2@1005 : Record 5080;
                                                                OppEntry@1001 : Record 5093;
                                                                SalesHeader@1003 : Record 36;
                                                                Attendee@1004 : Record 5199;
                                                                Window@1007 : Dialog;
                                                                TotalRecordsNumber@1011 : Integer;
                                                                Counter@1012 : Integer;
                                                              BEGIN
                                                                TESTFIELD("Contact No.");
                                                                Cont.GET("Contact No.");

                                                                IF ("Contact No." <> xRec."Contact No.") AND
                                                                   (xRec."Contact No." <> '') AND
                                                                   ("No." <> '')
                                                                THEN BEGIN
                                                                  CALCFIELDS("Contact Name");
                                                                  IF ("Contact Company No." <> Cont."Company No.") AND
                                                                     (Status <> Status::"Not Started")
                                                                  THEN
                                                                    ERROR(Text009,Cont."No.",Cont.Name);

                                                                  IF ("Sales Document No." <> '') AND ("Sales Document Type" = "Sales Document Type"::Quote) THEN BEGIN
                                                                    SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.");
                                                                    IF SalesHeader."Sell-to Contact No." <> "Contact No." THEN BEGIN
                                                                      MODIFY;
                                                                      SalesHeader.SetHideValidationDialog(TRUE);
                                                                      SalesHeader.VALIDATE("Sell-to Contact No.","Contact No.");
                                                                      SalesHeader.MODIFY
                                                                    END
                                                                  END;
                                                                  Task.RESET;
                                                                  Task.SETCURRENTKEY("Opportunity No.",Date,Closed);
                                                                  Task.SETRANGE("Opportunity No.","No.");
                                                                  Task.SETRANGE(Closed,FALSE);
                                                                  Task.SETRANGE("Contact No.",xRec."Contact No.");
                                                                  TotalRecordsNumber := Task.COUNT;
                                                                  Counter := 0;
                                                                  IF Task.FIND('-') THEN
                                                                    IF CONFIRM(ChangeConfirmQst,FALSE,FIELDCAPTION("Contact No.")) THEN BEGIN
                                                                      Window.OPEN(Text012 + Text013);
                                                                      Window.UPDATE(2,Text014);
                                                                      REPEAT
                                                                        Counter := Counter + 1;
                                                                        Window.UPDATE(1,ROUND(Counter / TotalRecordsNumber * 10000,1));
                                                                        IF Task.Type = Task.Type::Meeting THEN BEGIN
                                                                          Task.GetMeetingOrganizerTask(Task2);
                                                                          Task.VALIDATE("Contact No.","Contact No.");
                                                                          Task.MODIFY;
                                                                          Attendee.RESET;
                                                                          Attendee.SETRANGE("To-do No.",Task2."No.");
                                                                          Attendee.SETRANGE("Attendee No.",xRec."Contact No.");
                                                                          Attendee.SETRANGE("Attendee Type",Attendee."Attendee Type"::Contact);
                                                                          IF Attendee.FINDFIRST THEN BEGIN
                                                                            Attendee.VALIDATE("Attendee No.","Contact No.");
                                                                            Attendee.MODIFY(TRUE);
                                                                          END;
                                                                        END ELSE BEGIN
                                                                          Task.VALIDATE("Contact No.","Contact No.");
                                                                          Task.MODIFY(TRUE);
                                                                        END;
                                                                      UNTIL Task.NEXT = 0;
                                                                      Window.CLOSE;
                                                                    END;

                                                                  OppEntry.RESET;
                                                                  OppEntry.SETCURRENTKEY(Active,"Opportunity No.");
                                                                  OppEntry.SETRANGE(Active,TRUE);
                                                                  OppEntry.SETRANGE("Opportunity No.","No.");
                                                                  IF OppEntry.FIND('-') THEN
                                                                    REPEAT
                                                                      OppEntry.VALIDATE("Contact No.","Contact No.");
                                                                      OppEntry.MODIFY;
                                                                    UNTIL OppEntry.NEXT = 0;

                                                                  MODIFY;
                                                                END;

                                                                "Contact Company No." := Cont."Company No.";
                                                                CALCFIELDS("Contact Name","Contact Company Name");
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1000 : Record 5050;
                                                            BEGIN
                                                              IF Cont.GET("Contact No.") AND (Status <> Status::"Not Started") THEN
                                                                Cont.SETRANGE("Company No.",Cont."Company No.");
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                                                                xRec."Contact No." := "Contact No.";
                                                                VALIDATE("Contact No.",Cont."No.");
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Kontaktnr.;
                                                              ENU=Contact No.] }
    { 6   ;   ;Contact Company No. ;Code20        ;TableRelation=Contact WHERE (Type=CONST(Company));
                                                   CaptionML=[DAN=Virksomhedsnummer;
                                                              ENU=Contact Company No.] }
    { 7   ;   ;Sales Cycle Code    ;Code10        ;TableRelation="Sales Cycle";
                                                   OnValidate=VAR
                                                                SalesCycle@1000 : Record 5090;
                                                              BEGIN
                                                                SalesCycle.GET("Sales Cycle Code");
                                                                SalesCycle.TESTFIELD(Blocked,FALSE);
                                                              END;

                                                   CaptionML=[DAN=Salgsproceskode;
                                                              ENU=Sales Cycle Code] }
    { 8   ;   ;Sales Document No.  ;Code20        ;TableRelation=IF (Sales Document Type=CONST(Quote)) "Sales Header".No. WHERE (Document Type=CONST(Quote),
                                                                                                                                 Sell-to Contact No.=FIELD(Contact No.))
                                                                                                                                 ELSE IF (Sales Document Type=CONST(Order)) "Sales Header".No. WHERE (Document Type=CONST(Order),
                                                                                                                                                                                                      Sell-to Contact No.=FIELD(Contact No.))
                                                                                                                                                                                                      ELSE IF (Sales Document Type=CONST(Posted Invoice)) "Sales Invoice Header".No. WHERE (Sell-to Contact No.=FIELD(Contact No.));
                                                   OnValidate=VAR
                                                                Opp@1000 : Record 5092;
                                                                SalesHeader@1001 : Record 36;
                                                              BEGIN
                                                                IF "Sales Document No." = '' THEN BEGIN
                                                                  "Sales Document Type" := "Sales Document Type"::" ";
                                                                  IF xRec."Sales Document Type" = "Sales Document Type"::Quote THEN
                                                                    IF SalesHeader.GET(SalesHeader."Document Type"::Quote,xRec."Sales Document No.") THEN BEGIN
                                                                      SalesHeader."Opportunity No." := '';
                                                                      SalesHeader.MODIFY
                                                                    END
                                                                END ELSE
                                                                  IF "Sales Document No." <> xRec."Sales Document No." THEN BEGIN
                                                                    Opp.RESET;
                                                                    Opp.SETCURRENTKEY("Sales Document Type","Sales Document No.");
                                                                    Opp.SETRANGE("Sales Document Type","Sales Document Type");
                                                                    Opp.SETRANGE("Sales Document No.","Sales Document No.");
                                                                    IF Opp.FINDFIRST THEN
                                                                      IF Opp."No." <> "No." THEN
                                                                        ERROR(Text006,Opp."Sales Document Type",Opp."Sales Document No.",Opp."No.");

                                                                    IF xRec."Sales Document Type" = "Sales Document Type"::Quote THEN
                                                                      IF SalesHeader.GET(SalesHeader."Document Type"::Quote,xRec."Sales Document No.") THEN BEGIN
                                                                        SalesHeader."Opportunity No." := '';
                                                                        SalesHeader.MODIFY
                                                                      END;
                                                                    IF "Sales Document Type" = "Sales Document Type"::Quote THEN
                                                                      IF SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.") THEN BEGIN
                                                                        SalesHeader."Opportunity No." := "No.";
                                                                        SalesHeader.MODIFY
                                                                      END
                                                                  END;
                                                              END;

                                                   CaptionML=[DAN=Salgsbilagsnr.;
                                                              ENU=Sales Document No.] }
    { 9   ;   ;Creation Date       ;Date          ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date] }
    { 10  ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Ikke startet,Igangsat,Vundet,Tabt;
                                                                    ENU=Not Started,In Progress,Won,Lost];
                                                   OptionString=Not Started,In Progress,Won,Lost;
                                                   Editable=No }
    { 11  ;   ;Priority            ;Option        ;InitValue=Normal;
                                                   CaptionML=[DAN=Prioritet;
                                                              ENU=Priority];
                                                   OptionCaptionML=[DAN=Lav,Normal,H�j;
                                                                    ENU=Low,Normal,High];
                                                   OptionString=Low,Normal,High }
    { 12  ;   ;Closed              ;Boolean       ;CaptionML=[DAN=Lukket;
                                                              ENU=Closed];
                                                   Editable=No }
    { 13  ;   ;Date Closed         ;Date          ;CaptionML=[DAN=Lukket den;
                                                              ENU=Date Closed];
                                                   Editable=No }
    { 15  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 16  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Rlshp. Mgt. Comment Line" WHERE (Table Name=CONST(Opportunity),
                                                                                                       No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 17  ;   ;Current Sales Cycle Stage;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Opportunity Entry"."Sales Cycle Stage" WHERE (Opportunity No.=FIELD(No.),
                                                                                                                     Active=CONST(Yes)));
                                                   CaptionML=[DAN=Aktuel salgsprocesfase;
                                                              ENU=Current Sales Cycle Stage];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 18  ;   ;Estimated Value (LCY);Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Opportunity Entry"."Estimated Value (LCY)" WHERE (Opportunity No.=FIELD(No.),
                                                                                                                      Active=CONST(Yes)));
                                                   CaptionML=[DAN=Ansl�et v�rdi (RV);
                                                              ENU=Estimated Value (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 19  ;   ;Probability %       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Opportunity Entry"."Probability %" WHERE (Opportunity No.=FIELD(No.),
                                                                                                                 Active=CONST(Yes)));
                                                   CaptionML=[DAN=Sandsynlighed %;
                                                              ENU=Probability %];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 20  ;   ;Calcd. Current Value (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Opportunity Entry"."Calcd. Current Value (LCY)" WHERE (Opportunity No.=FIELD(No.),
                                                                                                                           Active=CONST(Yes)));
                                                   CaptionML=[DAN=Beregnet aktuel v�rdi (RV);
                                                              ENU=Calcd. Current Value (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 21  ;   ;Chances of Success %;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Opportunity Entry"."Chances of Success %" WHERE (Opportunity No.=FIELD(No.),
                                                                                                                        Active=CONST(Yes)));
                                                   CaptionML=[DAN=Succespotentiale %;
                                                              ENU=Chances of Success %];
                                                   DecimalPlaces=0:0;
                                                   Editable=No }
    { 22  ;   ;Completed %         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Opportunity Entry"."Completed %" WHERE (Opportunity No.=FIELD(No.),
                                                                                                               Active=CONST(Yes)));
                                                   CaptionML=[DAN=Afsluttet %;
                                                              ENU=Completed %];
                                                   DecimalPlaces=0:0;
                                                   Editable=No }
    { 23  ;   ;Contact Name        ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Contact.Name WHERE (No.=FIELD(Contact No.)));
                                                   CaptionML=[DAN=Kontaktnavn;
                                                              ENU=Contact Name];
                                                   Editable=No }
    { 24  ;   ;Contact Company Name;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Contact.Name WHERE (No.=FIELD(Contact Company No.)));
                                                   CaptionML=[DAN=Virksomhed;
                                                              ENU=Contact Company Name];
                                                   Editable=No }
    { 25  ;   ;Salesperson Name    ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Salesperson/Purchaser.Name WHERE (Code=FIELD(Salesperson Code)));
                                                   CaptionML=[DAN=S�lgernavn;
                                                              ENU=Salesperson Name];
                                                   Editable=No }
    { 26  ;   ;Campaign Description;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Campaign.Description WHERE (No.=FIELD(Campaign No.)));
                                                   CaptionML=[DAN=Kampagnebeskrivelse;
                                                              ENU=Campaign Description];
                                                   Editable=No }
    { 27  ;   ;Segment No.         ;Code20        ;TableRelation="Segment Header";
                                                   OnValidate=BEGIN
                                                                IF ("Segment No." <> xRec."Segment No.") AND ("Segment No." <> '') AND ("Campaign No." <> '') THEN
                                                                  CheckSegmentCampaignNo;
                                                              END;

                                                   OnLookup=BEGIN
                                                              LookupSegments;
                                                            END;

                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=M�lgruppenr.;
                                                              ENU=Segment No.] }
    { 28  ;   ;Estimated Closing Date;Date        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Opportunity Entry"."Estimated Close Date" WHERE (Opportunity No.=FIELD(No.),
                                                                                                                        Active=CONST(Yes)));
                                                   CaptionML=[DAN=Ansl�et ultimodato;
                                                              ENU=Estimated Closing Date];
                                                   Editable=No }
    { 29  ;   ;Sales Document Type ;Option        ;OnValidate=BEGIN
                                                                IF "Sales Document Type" = xRec."Sales Document Type" THEN
                                                                  EXIT;
                                                                IF "Sales Document Type" = "Sales Document Type"::" " THEN
                                                                  VALIDATE("Sales Document No.",'');
                                                              END;

                                                   CaptionML=[DAN=Salgsbilagstype;
                                                              ENU=Sales Document Type];
                                                   OptionCaptionML=[DAN=" ,Tilbud,Ordre,Bogf. faktura";
                                                                    ENU=" ,Quote,Order,Posted Invoice"];
                                                   OptionString=[ ,Quote,Order,Posted Invoice] }
    { 30  ;   ;No. of Interactions ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Interaction Log Entry" WHERE (Opportunity No.=FIELD(FILTER(No.)),
                                                                                                    Canceled=CONST(No),
                                                                                                    Postponed=CONST(No)));
                                                   CaptionML=[DAN=Antal interaktioner;
                                                              ENU=No. of Interactions];
                                                   Editable=No }
    { 9501;   ;Wizard Step         ;Option        ;CaptionML=[DAN=Trin i guide;
                                                              ENU=Wizard Step];
                                                   OptionCaptionML=[DAN=" ,1,2,3,4,5,6";
                                                                    ENU=" ,1,2,3,4,5,6"];
                                                   OptionString=[ ,1,2,3,4,5,6];
                                                   Editable=No }
    { 9502;   ;Activate First Stage;Boolean       ;CaptionML=[DAN=Aktiver f�rste fase;
                                                              ENU=Activate First Stage] }
    { 9503;   ;Segment Description ;Text50        ;CaptionML=[DAN=M�lgruppebeskrivelse;
                                                              ENU=Segment Description] }
    { 9504;   ;Wizard Estimated Value (LCY);Decimal;
                                                   CaptionML=[DAN=Ansl�et v�rdi i guide (RV);
                                                              ENU=Wizard Estimated Value (LCY)];
                                                   AutoFormatType=1 }
    { 9505;   ;Wizard Chances of Success %;Decimal;CaptionML=[DAN=Sandsynlighed for succes i guide i %;
                                                              ENU=Wizard Chances of Success %];
                                                   DecimalPlaces=0:0 }
    { 9506;   ;Wizard Estimated Closing Date;Date ;CaptionML=[DAN=Ansl�et ultimodato i guide;
                                                              ENU=Wizard Estimated Closing Date] }
    { 9507;   ;Wizard Contact Name ;Text50        ;CaptionML=[DAN=Kontaktnavn for guide;
                                                              ENU=Wizard Contact Name] }
    { 9508;   ;Wizard Campaign Description;Text50 ;CaptionML=[DAN=Kampagnebeskrivelse for guide;
                                                              ENU=Wizard Campaign Description] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Contact Company No.,Contact No.,Closed   }
    {    ;Salesperson Code,Closed                  }
    {    ;Campaign No.,Closed                      }
    {    ;Segment No.,Closed                       }
    {    ;Sales Document Type,Sales Document No.   }
    {    ;Description                              }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Description,Creation Date,Status     }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke slette salgsmuligheden, s� l�nge det er aktivt.;ENU=You cannot delete this opportunity while it is active.';
      Text001@1001 : TextConst 'DAN=Du kan ikke oprette salgsmuligheder i en tom m�lgruppe.;ENU=You cannot create opportunities on an empty segment.';
      Text002@1002 : TextConst 'DAN=Vil du oprette en salgsmulighed for alle kontakter i m�lgruppen %1?;ENU=Do you want to create an opportunity for all contacts in the %1 segment?';
      Text003@1009 : TextConst 'DAN=Der er ikke tildelt et salgstilbud til denne salgsmulighed.;ENU=There is no sales quote that is assigned to this opportunity.';
      Text004@1003 : TextConst 'DAN=Salgstilbuddet %1 findes ikke.;ENU=Sales quote %1 does not exist.';
      Text005@1005 : TextConst 'DAN=Du kan ikke tildele et salgstilbud til recorden %2 i %1, mens recorden %2 i %1 ikke har en tilknyttet kontaktvirksomhed.;ENU=You cannot assign a sales quote to the %2 record of the %1 while the %2 record of the %1 has no contact company assigned.';
      RMSetup@1011 : Record 5079;
      Opp@1012 : Record 5092;
      RMCommentLine@1013 : Record 5061;
      SegHeader@1018 : Record 5076;
      OppEntry@1020 : Record 5093;
      RMCommentLineTmp@1022 : TEMPORARY Record 5061;
      NoSeriesMgt@1014 : Codeunit 396;
      Text006@1004 : TextConst 'DAN=%1 %2 er allerede tildelt til salgsmulighed %3.;ENU=Sales %1 %2 is already assigned to opportunity %3.';
      ChangeConfirmQst@1007 : TextConst '@@@="%1 = Field Caption";DAN=Vil du �ndre %1 i de relaterede �bne opgaver med samme %1?;ENU=Do you want to change %1 on the related open tasks with the same %1?';
      Text009@1008 : TextConst 'DAN=Kontakten %1 %2 er knyttet til en anden virksomhed.;ENU=Contact %1 %2 is related to another company.';
      Text011@1010 : TextConst 'DAN=Der er allerede tildelt et salgstilbud til denne salgsmulighed.;ENU=A sales quote has already been assigned to this opportunity.';
      Text012@1017 : TextConst 'DAN=Aktuel proces   @1@@@@@@@@@@@@@@@\;ENU=Current process @1@@@@@@@@@@@@@@@\';
      Text013@1016 : TextConst 'DAN=Aktuel status   #2###############;ENU=Current status  #2###############';
      Text014@1015 : TextConst 'DAN=Opdaterer opgaver;ENU=Updating Tasks';
      Text022@1026 : TextConst 'DAN=Feltet %1 skal udfyldes.;ENU=You must fill in the %1 field.';
      Text023@1025 : TextConst 'DAN=Du skal angive den kontakt, der er knyttet til leadet.;ENU=You must fill in the contact that is involved in the opportunity.';
      Text024@1024 : TextConst 'DAN=%1 skal v�re st�rre end 0.;ENU=%1 must be greater than 0.';
      Text025@1023 : TextConst 'DAN=Den ansl�ede ultimodato skal v�re efter denne �ndring;ENU=The Estimated closing date has to be later than this change';
      ActivateFirstStageQst@1021 : TextConst 'DAN=Vil du aktivere f�rste fase for denne salgsmulighed?;ENU=Would you like to activate first stage for this opportunity?';
      SalesCycleNotFoundErr@1019 : TextConst 'DAN=Salgsprocesfase blev ikke fundet.;ENU=Sales Cycle Stage not found.';
      UpdateSalesQuoteWithCustTemplateQst@1006 : TextConst 'DAN=Skal salgstilbuddet opdateres med en debitorskabelon?;ENU=Do you want to update the sales quote with a customer template?';

    [External]
    PROCEDURE CreateFromInteractionLogEntry@21(InteractionLogEntry@1000 : Record 5065);
    BEGIN
      INIT;
      "No." := '';
      "Creation Date" := WORKDATE;
      Description := InteractionLogEntry.Description;
      "Segment No." := InteractionLogEntry."Segment No.";
      "Segment Description" := InteractionLogEntry.Description;
      "Campaign No." := InteractionLogEntry."Campaign No.";
      "Salesperson Code" := InteractionLogEntry."Salesperson Code";
      "Contact No." := InteractionLogEntry."Contact No.";
      "Contact Company No." := InteractionLogEntry."Contact Company No.";
      SetDefaultSalesCycle;
      INSERT(TRUE);
      CopyCommentLinesFromIntLogEntry(InteractionLogEntry);
    END;

    [External]
    PROCEDURE CreateFromSegmentLine@14(SegmentLine@1000 : Record 5077);
    BEGIN
      INIT;
      "No." := '';
      "Creation Date" := WORKDATE;
      Description := SegmentLine.Description;
      "Segment No." := SegmentLine."Segment No.";
      "Segment Description" := SegmentLine.Description;
      "Campaign No." := SegmentLine."Campaign No.";
      "Salesperson Code" := SegmentLine."Salesperson Code";
      "Contact No." := SegmentLine."Contact No.";
      "Contact Company No." := SegmentLine."Contact Company No.";
      SetDefaultSalesCycle;
      INSERT(TRUE);
    END;

    [External]
    PROCEDURE CreateOppFromOpp@1(VAR Opp@1007 : Record 5092);
    VAR
      Cont@1001 : Record 5050;
      SalesPurchPerson@1002 : Record 13;
      Campaign@1003 : Record 5071;
      SegHeader@1004 : Record 5076;
      SegLine@1005 : Record 5077;
    BEGIN
      DELETEALL;
      INIT;
      "Creation Date" := WORKDATE;
      SetDefaultSalesCycle;
      IF Cont.GET(Opp.GETFILTER("Contact Company No.")) THEN BEGIN
        VALIDATE("Contact No.",Cont."No.");
        "Salesperson Code" := Cont."Salesperson Code";
        SETRANGE("Contact Company No.","Contact No.");
      END;
      IF Cont.GET(Opp.GETFILTER("Contact No.")) THEN BEGIN
        VALIDATE("Contact No.",Cont."No.");
        "Salesperson Code" := Cont."Salesperson Code";
        SETRANGE("Contact No.","Contact No.");
      END;
      IF SalesPurchPerson.GET(Opp.GETFILTER("Salesperson Code")) THEN BEGIN
        "Salesperson Code" := SalesPurchPerson.Code;
        SETRANGE("Salesperson Code","Salesperson Code");
      END;
      IF Campaign.GET(Opp.GETFILTER("Campaign No.")) THEN BEGIN
        "Campaign No." := Campaign."No.";
        "Salesperson Code" := Campaign."Salesperson Code";
        SETRANGE("Campaign No.","Campaign No.");
      END;
      IF SegHeader.GET(Opp.GETFILTER("Segment No.")) THEN BEGIN
        SegLine.SETRANGE("Segment No.",SegHeader."No.");
        IF SegLine.COUNT = 0 THEN
          ERROR(Text001);
        "Segment No." := SegHeader."No.";
        "Campaign No." := SegHeader."Campaign No.";
        "Salesperson Code" := SegHeader."Salesperson Code";
        SETRANGE("Segment No.","Segment No.");
      END;

      StartWizard;
    END;

    LOCAL PROCEDURE InsertOpportunity@3(VAR Opp2@1000 : Record 5092;OppEntry2@1004 : Record 5093;VAR RMCommentLineTmp@1007 : Record 5061;ActivateFirstStage@1006 : Boolean);
    VAR
      SegHeader@1001 : Record 5076;
      SegLine@1002 : Record 5077;
      SalesCycleStage@1003 : Record 5091;
      OppEntry@1005 : Record 5093;
    BEGIN
      Opp := Opp2;

      IF ActivateFirstStage THEN BEGIN
        SalesCycleStage.RESET;
        SalesCycleStage.SETRANGE("Sales Cycle Code",Opp."Sales Cycle Code");
        IF SalesCycleStage.FINDFIRST THEN
          OppEntry2."Sales Cycle Stage" := SalesCycleStage.Stage;
      END;

      IF SegHeader.GET(GETFILTER("Segment No.")) THEN BEGIN
        SegLine.SETRANGE("Segment No.",SegHeader."No.");
        SegLine.SETFILTER("Contact No.",'<>%1','');
        IF SegLine.FIND('-') THEN BEGIN
          IF CONFIRM(Text002,TRUE,SegHeader."No.") THEN
            REPEAT
              Opp."Contact No." := SegLine."Contact No.";
              Opp."Contact Company No." := SegLine."Contact Company No.";
              CLEAR(Opp."No.");
              Opp.INSERT(TRUE);
              CreateCommentLines(RMCommentLineTmp,Opp."No.");
              IF ActivateFirstStage THEN BEGIN
                OppEntry.INIT;
                OppEntry := OppEntry2;
                OppEntry.InitOpportunityEntry(Opp);
                OppEntry.InsertEntry(OppEntry,FALSE,TRUE);
                OppEntry.UpdateEstimates;
              END;
            UNTIL SegLine.NEXT = 0;
        END;
      END ELSE BEGIN
        Opp.INSERT(TRUE);
        CreateCommentLines(RMCommentLineTmp,Opp."No.");
        IF ActivateFirstStage THEN BEGIN
          OppEntry.INIT;
          OppEntry := OppEntry2;
          OppEntry.InitOpportunityEntry(Opp);
          OppEntry.InsertEntry(OppEntry,FALSE,TRUE);
          OppEntry.UpdateEstimates;
        END;
      END;
    END;

    [External]
    PROCEDURE UpdateOpportunity@4();
    VAR
      TempOppEntry@1000 : TEMPORARY Record 5093;
    BEGIN
      IF "No." <> '' THEN
        TempOppEntry.UpdateOppFromOpp(Rec);
    END;

    [External]
    PROCEDURE CloseOpportunity@5();
    VAR
      TempOppEntry@1000 : TEMPORARY Record 5093;
    BEGIN
      IF "No." <> '' THEN
        TempOppEntry.CloseOppFromOpp(Rec);
    END;

    [External]
    PROCEDURE AssignQuote@6();
    VAR
      Cont@1001 : Record 5050;
      ContactBusinessRelation@1002 : Record 5054;
      SalesHeader@1000 : Record 36;
      CustTemplate@1004 : Record 5105;
      CustTemplateCode@1003 : Code[10];
    BEGIN
      Cont.GET("Contact No.");

      IF (Cont.Type = Cont.Type::Person) AND (Cont."Company No." = '') THEN
        ERROR(
          Text005,
          Cont.TABLECAPTION,Cont."No.");

      IF SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.") THEN
        ERROR(Text011);

      IF Cont.Type = Cont.Type::Person THEN
        Cont.GET(Cont."Company No.");

      IF Cont.Type = Cont.Type::Company THEN BEGIN
        ContactBusinessRelation.SETRANGE("Contact No.",Cont."No.");
        ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
        IF ContactBusinessRelation.ISEMPTY THEN
          IF GUIALLOWED THEN BEGIN
            CustTemplateCode := Cont.ChooseCustomerTemplate;
            IF CustTemplateCode <> '' THEN
              Cont.CreateCustomer(CustTemplateCode)
            ELSE
              IF CONFIRM(UpdateSalesQuoteWithCustTemplateQst) THEN
                IF PAGE.RUNMODAL(0,CustTemplate) = ACTION::LookupOK THEN
                  CustTemplateCode := CustTemplate.Code;
          END;
      END;

      TESTFIELD(Status,Status::"In Progress");

      SalesHeader.SETRANGE("Sell-to Contact No.","Contact No.");
      SalesHeader.INIT;
      SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
      SalesHeader.INSERT(TRUE);
      SalesHeader.VALIDATE("Salesperson Code","Salesperson Code");
      SalesHeader.VALIDATE("Campaign No.","Campaign No.");
      SalesHeader."Opportunity No." := "No.";
      SalesHeader."Order Date" := GetEstimatedClosingDate;
      SalesHeader."Shipment Date" := SalesHeader."Order Date";
      IF CustTemplateCode <> '' THEN
        SalesHeader.VALIDATE("Sell-to Customer Template Code",CustTemplateCode);
      SalesHeader.MODIFY;
      "Sales Document Type" := "Sales Document Type"::Quote;
      "Sales Document No." := SalesHeader."No.";
      MODIFY;

      PAGE.RUN(PAGE::"Sales Quote",SalesHeader);
    END;

    LOCAL PROCEDURE GetEstimatedClosingDate@8() : Date;
    VAR
      OppEntry@1000 : Record 5093;
    BEGIN
      OppEntry.SETCURRENTKEY(Active,"Opportunity No.");
      OppEntry.SETRANGE(Active,TRUE);
      OppEntry.SETRANGE("Opportunity No.","No.");
      IF OppEntry.FINDFIRST THEN
        EXIT(OppEntry."Estimated Close Date");
    END;

    [External]
    PROCEDURE ShowQuote@2();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      IF SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.") THEN
        PAGE.RUNMODAL(PAGE::"Sales Quote",SalesHeader);
    END;

    LOCAL PROCEDURE CreateCommentLines@7(VAR RMCommentLineTmp@1001 : Record 5061;OppNo@1000 : Code[20]);
    BEGIN
      IF RMCommentLineTmp.FIND('-') THEN
        REPEAT
          RMCommentLine.INIT;
          RMCommentLine := RMCommentLineTmp;
          RMCommentLine."No." := OppNo;
          RMCommentLine.INSERT;
        UNTIL RMCommentLineTmp.NEXT = 0;
    END;

    LOCAL PROCEDURE CopyCommentLinesFromIntLogEntry@23(InteractionLogEntry@1000 : Record 5065);
    VAR
      RlshpMgtCommentLine@1001 : Record 5061;
      InterLogEntryCommentLine@1002 : Record 5123;
    BEGIN
      InterLogEntryCommentLine.SETRANGE("Entry No.",InteractionLogEntry."Entry No.");
      IF InterLogEntryCommentLine.FINDSET THEN
        REPEAT
          RlshpMgtCommentLine.INIT;
          RlshpMgtCommentLine."Table Name" := RlshpMgtCommentLine."Table Name"::Opportunity;
          RlshpMgtCommentLine."No." := "No.";
          RlshpMgtCommentLine."Line No." := InterLogEntryCommentLine."Line No.";
          RlshpMgtCommentLine.Date := InterLogEntryCommentLine.Date;
          RlshpMgtCommentLine.Code := InterLogEntryCommentLine.Code;
          RlshpMgtCommentLine.Comment := InterLogEntryCommentLine.Comment;
          RlshpMgtCommentLine."Last Date Modified" := InterLogEntryCommentLine."Last Date Modified";
          RlshpMgtCommentLine.INSERT;
        UNTIL InterLogEntryCommentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE StartWizard@11();
    VAR
      Cont@1000 : Record 5050;
      Campaign@1001 : Record 5071;
      SegHeader@1002 : Record 5076;
    BEGIN
      "Wizard Step" := "Wizard Step"::"1";

      IF Cont.GET(GETFILTER("Contact No.")) THEN
        "Wizard Contact Name" := Cont.Name
      ELSE
        IF Cont.GET(GETFILTER("Contact Company No.")) THEN
          "Wizard Contact Name" := Cont.Name;

      IF Campaign.GET(GETFILTER("Campaign No.")) THEN
        "Wizard Campaign Description" := Campaign.Description;
      IF SegHeader.GET(GETFILTER("Segment No.")) THEN
        "Segment Description" := SegHeader.Description;

      INSERT;
      IF PAGE.RUNMODAL(PAGE::"Create Opportunity",Rec) = ACTION::OK THEN;
    END;

    [External]
    PROCEDURE CheckStatus@16();
    BEGIN
      IF "Creation Date" = 0D THEN
        ErrorMessage(FIELDCAPTION("Creation Date"));
      IF Description = '' THEN
        ErrorMessage(FIELDCAPTION(Description));

      IF NOT SegHeader.GET(GETFILTER("Segment No.")) THEN
        IF "Contact No." = '' THEN
          ERROR(Text023);
      IF "Salesperson Code" = '' THEN
        ErrorMessage(FIELDCAPTION("Salesperson Code"));
      IF "Sales Cycle Code" = '' THEN
        ErrorMessage(FIELDCAPTION("Sales Cycle Code"));

      IF "Activate First Stage" THEN BEGIN
        IF "Wizard Estimated Value (LCY)" <= 0 THEN
          ERROR(Text024,FIELDCAPTION("Wizard Estimated Value (LCY)"));
        IF "Wizard Chances of Success %" <= 0 THEN
          ERROR(Text024,FIELDCAPTION("Wizard Chances of Success %"));
        IF "Wizard Estimated Closing Date" = 0D THEN
          ErrorMessage(FIELDCAPTION("Wizard Estimated Closing Date"));
        IF "Wizard Estimated Closing Date" < OppEntry."Date of Change" THEN
          ERROR(Text025);
      END;
    END;

    [Internal]
    PROCEDURE FinishWizard@18();
    VAR
      ActivateFirstStage@1000 : Boolean;
    BEGIN
      "Wizard Step" := Opp."Wizard Step"::" ";
      ActivateFirstStage := "Activate First Stage";
      "Activate First Stage" := FALSE;
      OppEntry."Chances of Success %" := "Wizard Chances of Success %";
      OppEntry."Estimated Close Date" := "Wizard Estimated Closing Date";
      OppEntry."Estimated Value (LCY)" := "Wizard Estimated Value (LCY)";

      "Wizard Chances of Success %" := 0;
      "Wizard Estimated Closing Date" := 0D;
      "Wizard Estimated Value (LCY)" := 0;
      "Segment Description" := '';
      "Wizard Contact Name" := '';
      "Wizard Campaign Description" := '';

      InsertOpportunity(Rec,OppEntry,RMCommentLineTmp,ActivateFirstStage);
      DELETE;
    END;

    LOCAL PROCEDURE ErrorMessage@10(FieldName@1000 : Text[1024]);
    BEGIN
      ERROR(Text022,FieldName);
    END;

    [External]
    PROCEDURE SetComments@53(VAR RMCommentLine@1001 : Record 5061);
    BEGIN
      RMCommentLineTmp.DELETEALL;

      IF RMCommentLine.FINDSET THEN
        REPEAT
          RMCommentLineTmp := RMCommentLine;
          RMCommentLineTmp.INSERT;
        UNTIL RMCommentLine.NEXT = 0;
    END;

    [External]
    PROCEDURE ShowSalesQuoteWithCheck@15();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      IF ("Sales Document Type" <> "Sales Document Type"::Quote) OR
         ("Sales Document No." = '')
      THEN
        ERROR(Text003);

      IF NOT SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.") THEN
        ERROR(Text004,"Sales Document No.");
      PAGE.RUN(PAGE::"Sales Quote",SalesHeader);
    END;

    [External]
    PROCEDURE SetSegmentFromFilter@9();
    VAR
      SegmentNo@1000 : Code[20];
    BEGIN
      SegmentNo := GetFilterSegmentNo;
      IF SegmentNo = '' THEN BEGIN
        FILTERGROUP(2);
        SegmentNo := GetFilterSegmentNo;
        FILTERGROUP(0);
      END;
      IF SegmentNo <> '' THEN
        VALIDATE("Segment No.",SegmentNo);
    END;

    LOCAL PROCEDURE GetFilterSegmentNo@12() : Code[20];
    BEGIN
      IF GETFILTER("Segment No.") <> '' THEN
        IF GETRANGEMIN("Segment No.") = GETRANGEMAX("Segment No.") THEN
          EXIT(GETRANGEMAX("Segment No."));
    END;

    [External]
    PROCEDURE SetContactFromFilter@19();
    VAR
      ContactNo@1000 : Code[20];
    BEGIN
      ContactNo := GetFilterContactNo;
      IF ContactNo = '' THEN BEGIN
        FILTERGROUP(2);
        ContactNo := GetFilterContactNo;
        FILTERGROUP(0);
      END;
      IF ContactNo <> '' THEN
        VALIDATE("Contact No.",ContactNo);
    END;

    LOCAL PROCEDURE GetFilterContactNo@17() : Code[20];
    BEGIN
      IF (GETFILTER("Contact No.") <> '') AND (GETFILTER("Contact No.") <> '<>''''') THEN
        IF GETRANGEMIN("Contact No.") = GETRANGEMAX("Contact No.") THEN
          EXIT(GETRANGEMAX("Contact No."));
      IF GETFILTER("Contact Company No.") <> '' THEN
        IF GETRANGEMIN("Contact Company No.") = GETRANGEMAX("Contact Company No.") THEN
          EXIT(GETRANGEMAX("Contact Company No."));
    END;

    [Internal]
    PROCEDURE StartActivateFirstStage@20();
    VAR
      SalesCycleStage@1000 : Record 5091;
      OpportunityEntry@1001 : Record 5093;
    BEGIN
      IF CONFIRM(ActivateFirstStageQst) THEN BEGIN
        TESTFIELD("Sales Cycle Code");
        TESTFIELD(Status,Status::"Not Started");
        SalesCycleStage.SETRANGE("Sales Cycle Code","Sales Cycle Code");
        IF SalesCycleStage.FINDFIRST THEN BEGIN
          OpportunityEntry.INIT;
          OpportunityEntry."Sales Cycle Stage" := SalesCycleStage.Stage;
          OpportunityEntry."Sales Cycle Stage Description" := SalesCycleStage.Description;
          OpportunityEntry.InitOpportunityEntry(Rec);
          OpportunityEntry.InsertEntry(OpportunityEntry,FALSE,TRUE);
          OpportunityEntry.UpdateEstimates;
        END ELSE
          ERROR(SalesCycleNotFoundErr);
      END;
    END;

    [External]
    PROCEDURE SetDefaultSalesCycle@13();
    VAR
      SalesCycle@1000 : Record 5090;
    BEGIN
      RMSetup.GET;
      IF RMSetup."Default Sales Cycle Code" <> '' THEN
        IF SalesCycle.GET(RMSetup."Default Sales Cycle Code") THEN
          IF NOT SalesCycle.Blocked THEN
            "Sales Cycle Code" := RMSetup."Default Sales Cycle Code";
    END;

    LOCAL PROCEDURE SetDefaultSalesperson@22();
    VAR
      UserSetup@1000 : Record 91;
    BEGIN
      IF NOT UserSetup.GET(USERID) THEN
        EXIT;

      IF UserSetup."Salespers./Purch. Code" <> '' THEN
        VALIDATE("Salesperson Code",UserSetup."Salespers./Purch. Code");
    END;

    LOCAL PROCEDURE LookupCampaigns@24();
    VAR
      Campaign@1000 : Record 5071;
      Opportunity@1001 : Record 5092;
    BEGIN
      Campaign.SETFILTER("Starting Date",'..%1',"Creation Date");
      Campaign.SETFILTER("Ending Date",'%1..',"Creation Date");
      Campaign.CALCFIELDS(Activated);
      Campaign.SETRANGE(Activated,TRUE);
      IF PAGE.RUNMODAL(0,Campaign) = ACTION::LookupOK THEN BEGIN
        Opportunity := Rec;
        Opportunity.VALIDATE("Campaign No.",Campaign."No.");
        Rec := Opportunity;
      END;
    END;

    LOCAL PROCEDURE LookupSegments@25();
    VAR
      SegmentHeader@1000 : Record 5076;
    BEGIN
      IF "Campaign No." <> '' THEN
        SegmentHeader.SETRANGE("Campaign No.","Campaign No.");
      IF PAGE.RUNMODAL(0,SegmentHeader) = ACTION::LookupOK THEN
        VALIDATE("Segment No.",SegmentHeader."No.");
    END;

    LOCAL PROCEDURE CheckCampaign@28();
    VAR
      Campaign@1000 : Record 5071;
    BEGIN
      IF "Campaign No." <> '' THEN BEGIN
        Campaign.GET("Campaign No.");
        IF (Campaign."Starting Date" > "Creation Date") OR (Campaign."Ending Date" < "Creation Date") THEN
          FIELDERROR("Campaign No.");
        Campaign.CALCFIELDS(Activated);
        Campaign.TESTFIELD(Activated,TRUE);
      END;
    END;

    LOCAL PROCEDURE CheckSegmentCampaignNo@26();
    VAR
      SegmentHeader@1000 : Record 5076;
    BEGIN
      SegmentHeader.GET("Segment No.");
      IF SegmentHeader."Campaign No." <> '' THEN
        SegmentHeader.TESTFIELD("Campaign No.","Campaign No.");
    END;

    LOCAL PROCEDURE SetDefaultSegmentNo@33();
    VAR
      SegmentHeader@1000 : Record 5076;
    BEGIN
      "Segment No." := '';
      IF "Campaign No." <> '' THEN BEGIN
        SegmentHeader.SETRANGE("Campaign No.","Campaign No.");
        IF SegmentHeader.FINDFIRST AND (SegmentHeader.COUNT = 1) THEN
          "Segment No." := SegmentHeader."No."
      END;
    END;

    [External]
    PROCEDURE SetCampaignFromFilter@27();
    VAR
      CampaignNo@1000 : Code[20];
    BEGIN
      CampaignNo := GetFilterCampaignNo;
      IF CampaignNo = '' THEN BEGIN
        FILTERGROUP(2);
        CampaignNo := GetFilterCampaignNo;
        FILTERGROUP(0);
      END;
      IF CampaignNo <> '' THEN
        VALIDATE("Campaign No.",CampaignNo);
    END;

    LOCAL PROCEDURE GetFilterCampaignNo@30() : Code[20];
    BEGIN
      IF GETFILTER("Campaign No.") <> '' THEN
        IF GETRANGEMIN("Campaign No.") = GETRANGEMAX("Campaign No.") THEN
          EXIT(GETRANGEMAX("Campaign No."));
    END;

    BEGIN
    END.
  }
}

