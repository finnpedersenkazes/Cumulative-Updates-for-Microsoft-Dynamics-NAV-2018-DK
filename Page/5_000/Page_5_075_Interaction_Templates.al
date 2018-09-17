OBJECT Page 5075 Interaction Templates
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Interaktionsskabeloner;
               ENU=Interaction Templates];
    SourceTable=Table5064;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       CALCFIELDS("Attachment No.");
                     END;

    OnNewRecord=BEGIN
                  IF GETFILTER("Interaction Group Code") <> '' THEN
                    IF GETRANGEMIN("Interaction Group Code") = GETRANGEMAX("Interaction Group Code") THEN
                      "Interaction Group Code" := GETRANGEMIN("Interaction Group Code");
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Interaktionsskabelon;
                                 ENU=&Interaction Template];
                      Image=Interaction }
      { 29      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Interaktionslogp&oster;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=Vis en liste med de interaktioner, som du har gemt, f.eks. hvis du vil oprette en interaktion, udskrive en fõlgeseddel en salgsordre osv.;
                                 ENU=View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5076;
                      RunPageView=SORTING(Interaction Template Code,Date);
                      RunPageLink=Interaction Template Code=FIELD(Code);
                      Image=InteractionLog }
      { 30      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger sÜsom vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5079;
                      RunPageLink=Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Sprog;
                                 ENU=Languages];
                      ToolTipML=[DAN=Opret og vëlg de õnskede sprog for interaktionerne med dine kontakter.;
                                 ENU=Set up and select the preferred languages for the interactions with your contacts.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5154;
                      RunPageLink=Interaction Template Code=FIELD(Code);
                      Image=Language }
      { 41      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&edhëftet fil;
                                 ENU=&Attachment];
                      Image=Attachments }
      { 43      ;2   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=èbn;
                                 ENU=Open];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Edit;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF InteractTemplLanguage.GET(Code,"Language Code (Default)") THEN
                                   InteractTemplLanguage.OpenAttachment;
                               END;
                                }
      { 44      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret;
                                 ENU=Create];
                      ToolTipML=[DAN=Opret en ny interaktionsskabelon.;
                                 ENU=Create a new interaction template.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=New;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF NOT InteractTemplLanguage.GET(Code,"Language Code (Default)") THEN BEGIN
                                   InteractTemplLanguage.INIT;
                                   InteractTemplLanguage."Interaction Template Code" := Code;
                                   InteractTemplLanguage."Language Code" := "Language Code (Default)";
                                   InteractTemplLanguage.Description := Description;
                                 END;
                                 InteractTemplLanguage.CreateAttachment;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 45      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier &fra;
                                 ENU=Copy &from];
                      ToolTipML=[DAN=Kopier en eksisterende interaktionsskabelon.;
                                 ENU=Copy an existing interaction template.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Copy;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF NOT InteractTemplLanguage.GET(Code,"Language Code (Default)") THEN BEGIN
                                   InteractTemplLanguage.INIT;
                                   InteractTemplLanguage."Interaction Template Code" := Code;
                                   InteractTemplLanguage."Language Code" := "Language Code (Default)";
                                   InteractTemplLanguage.Description := Description;
                                   InteractTemplLanguage.INSERT;
                                   COMMIT;
                                 END;
                                 InteractTemplLanguage.CopyFromAttachment;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 46      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indlës;
                                 ENU=Import];
                      ToolTipML=[DAN=Indlës interaktionsskabelon.;
                                 ENU=Import an interaction template.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Import;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF NOT InteractTemplLanguage.GET(Code,"Language Code (Default)") THEN BEGIN
                                   InteractTemplLanguage.INIT;
                                   InteractTemplLanguage."Interaction Template Code" := Code;
                                   InteractTemplLanguage."Language Code" := "Language Code (Default)";
                                   InteractTemplLanguage.Description := Description;
                                   InteractTemplLanguage.INSERT;
                                 END;
                                 InteractTemplLanguage.ImportAttachment;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 47      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udlës;
                                 ENU=E&xport];
                      ToolTipML=[DAN=Udlës interaktionsskabelon.;
                                 ENU=Export an interaction template.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Export;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF InteractTemplLanguage.GET(Code,"Language Code (Default)") THEN
                                   InteractTemplLanguage.ExportAttachment;
                               END;
                                }
      { 48      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Fjern;
                                 ENU=Remove];
                      ToolTipML=[DAN=Fjern interaktionsskabelon.;
                                 ENU=Remote an interaction template.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Cancel;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF InteractTemplLanguage.GET(Code,"Language Code (Default)") THEN
                                   InteractTemplLanguage.RemoveAttachment(TRUE);
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for interaktionsskabelonen.;
                           ENU=Specifies the code for the interaction template.];
                ApplicationArea=#All;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den interaktionsgruppe, som interaktionsskabelonen er med i.;
                           ENU=Specifies the code for the interaction group to which the interaction template belongs.];
                ApplicationArea=#All;
                SourceExpr="Interaction Group Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af interaktionsskabelonen.;
                           ENU=Specifies a description of the interaction template.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken handling, der skal udfõres, nÜr du klikker pÜ Nëste i det fõrste vindue i guiden Opret interaktion. Der er 3 indstillinger:;
                           ENU=Specifies the action to perform when you click Next in the first window of the Create Interaction wizard. There are 3 options:];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Wizard Action" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardsprogkoden for interaktionen. Hvis kontaktens foretrukne sprog ikke er tilgëngeligt, bruges standardsproget automatisk.;
                           ENU=Specifies the default language code for the interaction. If the contact's preferred language is not available, then the program uses this language as the default language.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Language Code (Default)" }

    { 27  ;2   ;Field     ;
                Name=Attachment;
                AssistEdit=Yes;
                CaptionML=[DAN=Vedhëftet fil;
                           ENU=Attachment];
                ToolTipML=[DAN=Angiver, om den tilknyttede vedhëftede fil er overfõrt eller entydig.;
                           ENU=Specifies if the linked attachment is inherited or unique.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Attachment No." <> 0;
                OnAssistEdit=VAR
                               InteractTmplLanguage@1001 : Record 5103;
                             BEGIN
                               IF InteractTmplLanguage.GET(Code,"Language Code (Default)") THEN BEGIN
                                 IF InteractTmplLanguage."Attachment No." <> 0 THEN
                                   InteractTmplLanguage.OpenAttachment
                                 ELSE
                                   InteractTmplLanguage.CreateAttachment;
                               END ELSE BEGIN
                                 InteractTmplLanguage.INIT;
                                 InteractTmplLanguage."Interaction Template Code" := Code;
                                 InteractTmplLanguage."Language Code" := "Language Code (Default)";
                                 InteractTmplLanguage.Description := Description;
                                 InteractTmplLanguage.CreateAttachment;
                               END;
                               CurrPage.UPDATE;
                             END;
                              }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den korrespondancetype, som du vëlger i feltet Korrespondancetype (standard), skal bruges.;
                           ENU=Specifies that the correspondence type that you select in the Correspondence Type (Default) field should be used.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Ignore Contact Corres. Type" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den foretrukne type korrespondance for interaktionen. BEMíRK: Hvis du bruger webklient, mÜ du ikke vëlge indstillingen Papirformat, fordi det ikke er muligt at udskrive fra webklienten.;
                           ENU=Specifies the preferred type of correspondence for the interaction. NOTE: If you use the Web client, you must not select the Hard Copy option because printing is not possible from the web client.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Correspondence Type (Default)" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Unit Cost (LCY)" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den normale varighed af de interaktioner, der oprettes vha. interaktionsskabelonen.;
                           ENU=Specifies the usual duration of interactions created using the interaction template.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Unit Duration (Min.)" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver retningen pÜ informationsstrõmmen i interaktionsskabelonen. Der er to indstillinger: UdgÜende og IndgÜende. Vëlg UdgÜende, hvis oplysningerne som regel sendes fra din virksomhed. Vëlg IndgÜende, hvis oplysningerne som regel modtages af din virksomhed.;
                           ENU=Specifies the direction of the information flow for the interaction template. There are two options: Outbound and Inbound. Select Outbound if the information is usually sent by your company. Select Inbound if the information is usually received by your company.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Information Flow" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvem der som regel ivërksëtter interaktioner, der oprettes vha. interaktionsskabelonen. Der er to indstillinger: Os eller Dem. Vëlg Os, hvis interaktionen som regel ivërksëttes af din virksomhed. Vëlg Dem, hvis interaktionen som regel ivërksëttes af kontakterne.;
                           ENU=Specifies who usually initiates interactions created using the interaction template. There are two options: Us and Them. Select Us if the interaction is usually initiated by your company. Select Them if the information is usually initiated by your contacts.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Initiated By" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, som interaktionsskabelonen er blevet oprettet til.;
                           ENU=Specifies the number of the campaign for which the interaction template has been created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den kontakt, der er involveret i interaktionen, er mÜl for kampagnen. Det anvendes til at mÜle svarprocenten for kampagnen.;
                           ENU=Specifies that the contact who is involved in the interaction is the target of a campaign. This is used to measure the response rate of a campaign.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Target" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at interaktionsskabelonen bruges til at registrere interaktioner, som er et svar pÜ kampagnen. Du kan f.eks. registrere kuponer, der sendes som svar pÜ kampagnen.;
                           ENU=Specifies that the interaction template is being used to record interactions that are a response to a campaign. For example, coupons that are sent in as a response to a campaign.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Response" }

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

