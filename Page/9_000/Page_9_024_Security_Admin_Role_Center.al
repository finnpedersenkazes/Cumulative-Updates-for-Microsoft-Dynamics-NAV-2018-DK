OBJECT Page 9024 Security Admin Role Center
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[@@@=Use same translation as 'Profile Description' (if applicable);
               DAN=Administration af brugere, brugergrupper og rettigheder;
               ENU=Administration of users, user groups and permissions];
    Description=Manage users, users groups and permissions;
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      Name=HomeItemsContainer;
                      ActionContainerType=HomeItems }
      { 10      ;1   ;Action    ;
                      Name=User Groups;
                      CaptionML=[DAN=Brugergrupper;
                                 ENU=User Groups];
                      ToolTipML=[DAN=Definer brugergrupper, s� du nemt kan tildele rettighedss�t til flere brugere. Du kan bruge en funktion til at kopiere alle rettighedss�t fra en eksisterende brugergruppe til din nye brugergruppe.;
                                 ENU=Define user groups so that you can assign permission sets to multiple users easily. You can use a function to copy all permission sets from an existing user group to your new user group.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9830 }
      { 9       ;1   ;Action    ;
                      Name=Users;
                      CaptionML=[DAN=Brugere;
                                 ENU=Users];
                      ToolTipML=[DAN=Angiv databasebrugere, og tildel angiver deres tilladelse til at definere, hvilke databaseobjekter, og dermed hvilke brugergr�nsefladeelementer, de har adgang til, og i hvilke virksomheder. Du kan f�je brugere til brugergrupper for at g�re det nemmere at tildele de samme rettighedss�t til flere brugere. I vinduet Brugerops�tning kan administratorer definere perioder, hvor angivne brugere kan bogf�re og angive, om systemet logf�rer, n�r brugere er logget p�.;
                                 ENU=Set up the database users and assign their permission sets to define which database objects, and thereby which UI elements, they have access to, and in which companies. You can add users to user groups to make it easier to assign the same permission sets to multiple users. In the User Setup window, administrators can define periods of time during which specified users are able to post, and also specify if the system logs when users are logged on.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9800 }
      { 13      ;1   ;Action    ;
                      Name=User Review Log;
                      CaptionML=[DAN=Brugerkontrollog;
                                 ENU=User Review Log];
                      ToolTipML=[DAN="Overv�g brugernes aktiviteter i databasen ved at gennemg� �ndringer af data i tabeller, som du har valgt skal spores. �ndringslogposter sorteres kronologisk og viser �ndringer, der foretages af felterne i de angivne tabeller. ";
                                 ENU="Monitor users' activities in the database by reviewing changes that are made to data in tables that you select to track. Change log entries are chronologically ordered and show changes that are made to the fields on the specified tables. "];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 710;
                      RunPageView=WHERE(Table No Filter=FILTER(9062)) }
      { 2       ;1   ;Action    ;
                      Name=Permission Sets;
                      CaptionML=[DAN=Rettighedss�t;
                                 ENU=Permission Sets];
                      ToolTipML=[DAN=Definer samlinger af tilladelser, der hver is�r repr�senterer forskellige adgangsrettigheder til bestemte databaseobjekter, og gennemse, hvilke rettighedss�t der er tildelt til databasens brugere, s� de kan udf�re deres opgaver i brugergr�nsefladen. Brugere tildeles rettighedss�t i henhold til Office 365-abonnementsplanen.;
                                 ENU=Define collections of permissions each representing different access rights to certain database objects, and review which permission sets are assigned to users of the database to enable them to perform their tasks in the user interface. Users are assigned permission sets according to the Office 365 subscription plan.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9802 }
      { 11      ;1   ;Action    ;
                      Name=Plans;
                      CaptionML=[DAN=Planer;
                                 ENU=Plans];
                      ToolTipML=[DAN=F� vist oplysninger om dit Office 365-abonnement, herunder dine forskellige brugerprofiler og deres tildelte licenser, f.eks. licensen Team Member. Bem�rk, at brugere oprettes i Office 365 og derefter importeres til Dynamics NAV vha. handlingen Hent brugere fra Office 365.;
                                 ENU=View the details of your Office 365 subscription, including your different user profiles and their assigned licenses, such as the Team Member license. Note that users are created in Office 365 and then imported into Dynamics NAV with the Get Users from Office 365 action.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9824;
                      RunPageMode=View }
      { 18      ;0   ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=Selvbetjening;
                                 ENU=Self-Service];
                      ToolTipML=[DAN=Administrer dine timesedler og opgaver.;
                                 ENU=Manage your time sheets and assignments.];
                      Image=HumanResources }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Timesedler;
                                 ENU=Time Sheets];
                      ToolTipML=[DAN=Giv ressourcer mulighed for at tidsregistere. Efter godkendelsen, hvis en s�dan kr�ves, kan timeseddelposterne bogf�res for den relevante sagskladde eller ressourcekladde som en del af registreringen af projektforl�bet. Hvis du vil spare konfigurationstid og sikre, at dataene er korrekte, kan du kopiere sagsplanl�gningslinjerne til timesedlerne.;
                                 ENU=Enable resources to register time. When approved, if approval is required, time sheet entries can be posted to the relevant job journal or resource journal as part of project progress reporting. To save setup time and to ensure data correctness, you can copy job planning lines into time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      Gesture=None }
      { 25      ;2   ;Action    ;
                      Name=Page Time Sheet List Open;
                      CaptionML=[DAN=�bn;
                                 ENU=Open];
                      ToolTipML=[DAN=�bn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Open Exists=CONST(Yes)) }
      { 23      ;2   ;Action    ;
                      Name=Page Time Sheet List Submitted;
                      CaptionML=[DAN=Sendt;
                                 ENU=Submitted];
                      ToolTipML=[DAN=F� vist sendte timesedler.;
                                 ENU=View submitted time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Submitted Exists=CONST(Yes)) }
      { 22      ;2   ;Action    ;
                      Name=Page Time Sheet List Rejected;
                      CaptionML=[DAN=Afvist;
                                 ENU=Rejected];
                      ToolTipML=[DAN=F� vist afviste timesedler.;
                                 ENU=View rejected time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Rejected Exists=CONST(Yes)) }
      { 20      ;2   ;Action    ;
                      Name=Page Time Sheet List Approved;
                      CaptionML=[DAN=Godkendt;
                                 ENU=Approved];
                      ToolTipML=[DAN=F� vist godkendte timesedler.;
                                 ENU=View approved time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Approved Exists=CONST(Yes)) }
      { 54      ;1   ;ActionGroup;
                      CaptionML=[DAN=Beskyttelse af data;
                                 ENU=Data Privacy];
                      ToolTipML=[DAN=Administrer klassificeringer af databeskyttelse, og besvar anmodninger fra dataemner.;
                                 ENU=Manage data privacy classifications, and respond to requests from data subjects.];
                      Image=HumanResources }
      { 56      ;2   ;Action    ;
                      Name=Page Data Classifications;
                      CaptionML=[DAN=Dataklassificeringer;
                                 ENU=Data Classifications];
                      ToolTipML=[DAN=Vis de aktuelle dataklassificeringer;
                                 ENU=View your current data classifications];
                      ApplicationArea=#All;
                      RunObject=Page 1751 }
      { 55      ;2   ;Action    ;
                      Name=Classified;
                      CaptionML=[DAN=Klassificerede felter;
                                 ENU=Classified Fields];
                      ToolTipML=[DAN=Vis kun klassificerede felter;
                                 ENU=View only classified fields];
                      ApplicationArea=#All;
                      RunObject=Page 1751;
                      RunPageView=WHERE(Data Sensitivity=FILTER(<>Unclassified)) }
      { 53      ;2   ;Action    ;
                      Name=Unclassified;
                      CaptionML=[DAN=Ikke-klassificerede felter;
                                 ENU=Unclassified Fields];
                      ToolTipML=[DAN=Vis kun ikke-klassificerede felter;
                                 ENU=View only unclassified fields];
                      ApplicationArea=#All;
                      RunObject=Page 1751;
                      RunPageView=WHERE(Data Sensitivity=CONST(Unclassified)) }
      { 51      ;2   ;Action    ;
                      Name=Page Data Subjects;
                      CaptionML=[DAN=Dataemner;
                                 ENU=Data Subjects];
                      ToolTipML=[DAN=Vis dine potentielle dataemner;
                                 ENU=View your potential data subjects];
                      ApplicationArea=#All;
                      RunObject=Page 1754 }
      { 57      ;2   ;Action    ;
                      Name=Page Change Log Entries;
                      CaptionML=[DAN=�ndringslogposter;
                                 ENU=Change Log Entries];
                      ToolTipML=[DAN=Vis logfilen med alle �ndringer i systemet;
                                 ENU=View the log with all the changes in your system];
                      ApplicationArea=#All;
                      RunObject=Page 595 }
      { 16      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Flow;
                                 ENU=Flow] }
      { 17      ;2   ;Action    ;
                      Name=Manage Flows;
                      CaptionML=[DAN=H�ndter flow;
                                 ENU=Manage Flows];
                      ToolTipML=[DAN=Vis eller rediger automatiske workflows, der er oprettet med Flow.;
                                 ENU=View or edit automated workflows created with Flow.;
                                 ENG=View and manage your flows.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 6401;
                      Image=Flow }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=RoleCenterArea }

    { 6   ;1   ;Group     ;
                Name=CueGroup;
                CaptionML=[DAN=K�indikatorgruppe;
                           ENU=Cue Group];
                GroupType=Group }

    { 7   ;2   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9062;
                PartType=Page }

    { 15  ;2   ;Part      ;
                ApplicationArea=#Suite;
                PagePartID=Page9042;
                PartType=Page }

    { 8   ;1   ;Group     ;
                Name=Lists;
                CaptionML=[DAN=Lister;
                           ENU=Lists];
                GroupType=Group }

    { 12  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page773;
                PartType=Page }

    { 3   ;2   ;Part      ;
                CaptionML=[DAN=Abonnementsplaner;
                           ENU=Subscription Plans];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9825;
                Editable=FALSE;
                PartType=Page }

    { 4   ;2   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9829;
                Editable=FALSE;
                PartType=Page }

    { 14  ;2   ;Part      ;
                CaptionML=[DAN=Planrettighedss�t;
                           ENU=Plan Permission Set];
                ToolTipML=[DAN=Angiver de rettighedss�t, der er inkluderet i planer.;
                           ENU=Specifies the permission sets included in plans.];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9844;
                Editable=FALSE;
                PartType=Page }

    { 26  ;1   ;Group     ;
                GroupType=Group }

    { 37  ;2   ;Part      ;
                AccessByPermission=TableData 477=R;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page681;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}

