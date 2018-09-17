OBJECT Page 5201 Employee List
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
    CaptionML=[DAN=Medarbejderoversigt;
               ENU=Employee List];
    SourceTable=Table5200;
    PageType=List;
    CardPageID=Employee Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Medarb.;
                                 ENU=E&mployee];
                      Image=Employee }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5222;
                      RunPageLink=Table Name=CONST(Employee),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 20      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 184     ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=FÜ vist eller rediger de enkelte sët af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5200),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 19      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#BasicHR;
                      Image=DimensionSets;
                      OnAction=VAR
                                 Employee@1001 : Record 5200;
                                 DefaultDimMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Employee);
                                 DefaultDimMultiple.SetMultiEmployee(Employee);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=&Billede;
                                 ENU=&Picture];
                      ToolTipML=[DAN=Vis eller tilfõj et billede af medarbejderen eller f.eks. virksomhedens logo.;
                                 ENU=View or add a picture of the employee or, for example, the company's logo.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5202;
                      RunPageLink=No.=FIELD(No.);
                      Image=Picture }
      { 45      ;2   ;Action    ;
                      Name=AlternativeAddresses;
                      CaptionML=[DAN=&Alternative adresser;
                                 ENU=&Alternate Addresses];
                      ToolTipML=[DAN=èbn listen over adresser, der er registrerede for medarbejderen.;
                                 ENU=Open the list of addresses that are registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5204;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Addresses }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=Familiemed&lemmer;
                                 ENU=&Relatives];
                      ToolTipML=[DAN=èbn listen over familiemedlemmer, der er registreret for medarbejderen.;
                                 ENU=Open the list of relatives that are registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5209;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Relatives }
      { 47      ;2   ;Action    ;
                      CaptionML=[DAN=&Udstyrsoplysninger;
                                 ENU=Mi&sc. Article Information];
                      ToolTipML=[DAN=èbn listen over udstyr, der er registreret for medarbejderen.;
                                 ENU=Open the list of miscellaneous articles that are registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5219;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Filed }
      { 48      ;2   ;Action    ;
                      CaptionML=[DAN=&Fortrolige oplysninger;
                                 ENU=Co&nfidential Information];
                      ToolTipML=[DAN=èbn listen over eventuelle fortrolige oplysninger, der er registreret for medarbejderen.;
                                 ENU=Open the list of any confidential information that is registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5221;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Lock }
      { 49      ;2   ;Action    ;
                      CaptionML=[DAN=Kvalifika&tioner;
                                 ENU=Q&ualifications];
                      ToolTipML=[DAN=èbn listen over kvalifikationer, der er registreret for medarbejderen.;
                                 ENU=Open the list of qualifications that are registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5206;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Certificate }
      { 50      ;2   ;Action    ;
                      CaptionML=[DAN=Fra&vër;
                                 ENU=A&bsences];
                      ToolTipML=[DAN=FÜ vist fravërsoplysninger for medarbejderen.;
                                 ENU=View absence information for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5211;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Absence }
      { 51      ;2   ;Separator  }
      { 54      ;2   ;Action    ;
                      CaptionML=[DAN=Fravër &pr. kategori;
                                 ENU=Absences by Ca&tegories];
                      ToolTipML=[DAN=FÜ vist kategoriserede fravërsoplysninger for medarbejderen.;
                                 ENU=View categorized absence information for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5226;
                      RunPageLink=No.=FIELD(No.),
                                  Employee No. Filter=FIELD(No.);
                      Image=AbsenceCategory }
      { 55      ;2   ;Action    ;
                      CaptionML=[DAN=Ud&styrsoversigt;
                                 ENU=Misc. Articles &Overview];
                      ToolTipML=[DAN=FÜ vist udstyr, der er registreret for medarbejderen.;
                                 ENU=View miscellaneous articles that are registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5228;
                      Image=FiledOverview }
      { 56      ;2   ;Action    ;
                      CaptionML=[DAN=Fo&rtrolige oplysn. - oversigt;
                                 ENU=Con&fidential Info. Overview];
                      ToolTipML=[DAN=FÜ vist fortrolige oplysninger, der er registreret for medarbejderen.;
                                 ENU=View confidential information that is registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5229;
                      Image=ConfidentialOverview }
      { 57      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 58      ;1   ;Action    ;
                      CaptionML=[DAN=Fravërsregistrering;
                                 ENU=Absence Registration];
                      ToolTipML=[DAN=Registrer fravër for medarbejderen.;
                                 ENU=Register absence for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5212;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Absence;
                      PromotedCategory=Process }
      { 3       ;1   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Varepos&ter;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5237;
                      RunPageView=SORTING(Employee No.)
                                  ORDER(Descending);
                      RunPageLink=Employee No.=FIELD(No.);
                      Promoted=Yes;
                      Image=VendorLedger;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#BasicHR;
                SourceExpr="No." }

    { 17  ;2   ;Field     ;
                Name=FullName;
                CaptionML=[DAN=Fulde navn;
                           ENU=Full Name];
                ToolTipML=[DAN=Angiver medarbejderens fulde navn.;
                           ENU=Specifies the full name of the employee.];
                ApplicationArea=#BasicHR;
                SourceExpr=FullName;
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens fornavn.;
                           ENU=Specifies the employee's first name.];
                ApplicationArea=#BasicHR;
                NotBlank=Yes;
                SourceExpr="First Name" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens mellemnavn.;
                           ENU=Specifies the employee's middle name.];
                ApplicationArea=#BasicHR;
                SourceExpr="Middle Name";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens efternavn.;
                           ENU=Specifies the employee's last name.];
                ApplicationArea=#BasicHR;
                NotBlank=Yes;
                SourceExpr="Last Name" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens initialer.;
                           ENU=Specifies the employee's initials.];
                ApplicationArea=#Advanced;
                SourceExpr=Initials;
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens stilling.;
                           ENU=Specifies the employee's job title.];
                ApplicationArea=#BasicHR;
                SourceExpr="Job Title" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#BasicHR;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omrÜde.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#BasicHR;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                CaptionML=[DAN=Virksomhedstlf.nr.;
                           ENU=Company Phone No.];
                ToolTipML=[DAN=Angiver medarbejderens telefonnummer.;
                           ENU=Specifies the employee's telephone number.];
                ApplicationArea=#BasicHR;
                SourceExpr="Phone No." }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens lokaltelefonnummer.;
                           ENU=Specifies the employee's telephone extension.];
                ApplicationArea=#BasicHR;
                SourceExpr=Extension;
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                CaptionML=[DAN=Privat telefonnr.;
                           ENU=Private Phone No.];
                ToolTipML=[DAN=Angiver medarbejderens private telefonnummer.;
                           ENU=Specifies the employee's private telephone number.];
                ApplicationArea=#BasicHR;
                SourceExpr="Mobile Phone No.";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                CaptionML=[DAN=Privat mail;
                           ENU=Private Email];
                ToolTipML=[DAN=Angiver medarbejderens private mailadresse.;
                           ENU=Specifies the employee's private email address.];
                ApplicationArea=#BasicHR;
                SourceExpr="E-Mail";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en statistikgruppekode, der tildeles medarbejderen til statistiske formÜl.;
                           ENU=Specifies a statistics group code to assign to the employee for statistical purposes.];
                ApplicationArea=#Advanced;
                SourceExpr="Statistics Group Code";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et ressourcenummer for medarbejderen.;
                           ENU=Specifies a resource number for the employee.];
                ApplicationArea=#Jobs;
                SourceExpr="Resource No.";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at sõge efter den õnskede record, hvis du ikke kan huske vërdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Name" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der er indtastet en bemërkning til posten.;
                           ENU=Specifies if a comment has been entered for this entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                ApplicationArea=#BasicHR;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                ApplicationArea=#BasicHR;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

