OBJECT Page 5200 Employee Card
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Medarbejderkort;
               ENU=Employee Card];
    SourceTable=Table5200;
    PageType=Card;
    OnOpenPage=BEGIN
                 SetNoFieldVisible;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Medarb.;
                                 ENU=E&mployee];
                      Image=Employee }
      { 81      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5222;
                      RunPageLink=Table Name=CONST(Employee),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 184     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5200),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 76      ;2   ;Action    ;
                      CaptionML=[DAN=&Billede;
                                 ENU=&Picture];
                      ToolTipML=[DAN=Vis eller tilf�j et billede af medarbejderen eller f.eks. virksomhedens logo.;
                                 ENU=View or add a picture of the employee or, for example, the company's logo.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5202;
                      RunPageLink=No.=FIELD(No.);
                      Image=Picture }
      { 75      ;2   ;Action    ;
                      Name=AlternativeAddresses;
                      CaptionML=[DAN=&Alternative adresser;
                                 ENU=&Alternate Addresses];
                      ToolTipML=[DAN=�bn listen over adresser, der er registrerede for medarbejderen.;
                                 ENU=Open the list of addresses that are registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5204;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Addresses }
      { 83      ;2   ;Action    ;
                      CaptionML=[DAN=Familiemed&lemmer;
                                 ENU=&Relatives];
                      ToolTipML=[DAN=�bn listen over familiemedlemmer, der er registreret for medarbejderen.;
                                 ENU=Open the list of relatives that are registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5209;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Relatives }
      { 84      ;2   ;Action    ;
                      CaptionML=[DAN=&Udstyrsoplysninger;
                                 ENU=Mi&sc. Article Information];
                      ToolTipML=[DAN=�bn listen over udstyr, der er registreret for medarbejderen.;
                                 ENU=Open the list of miscellaneous articles that are registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5219;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Filed }
      { 88      ;2   ;Action    ;
                      CaptionML=[DAN=&Fortrolige oplysninger;
                                 ENU=&Confidential Information];
                      ToolTipML=[DAN=�bn listen over eventuelle fortrolige oplysninger, der er registreret for medarbejderen.;
                                 ENU=Open the list of any confidential information that is registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5221;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Lock }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Kvalifika&tioner;
                                 ENU=Q&ualifications];
                      ToolTipML=[DAN=�bn listen over kvalifikationer, der er registreret for medarbejderen.;
                                 ENU=Open the list of qualifications that are registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5206;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Certificate }
      { 87      ;2   ;Action    ;
                      CaptionML=[DAN=Fra&v�r;
                                 ENU=A&bsences];
                      ToolTipML=[DAN=F� vist frav�rsoplysninger for medarbejderen.;
                                 ENU=View absence information for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5211;
                      RunPageLink=Employee No.=FIELD(No.);
                      Image=Absence }
      { 23      ;2   ;Separator  }
      { 95      ;2   ;Action    ;
                      CaptionML=[DAN=Frav�r &pr. kategori;
                                 ENU=Absences by Ca&tegories];
                      ToolTipML=[DAN=F� vist kategoriserede frav�rsoplysninger for medarbejderen.;
                                 ENU=View categorized absence information for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5226;
                      RunPageLink=No.=FIELD(No.),
                                  Employee No. Filter=FIELD(No.);
                      Image=AbsenceCategory }
      { 70      ;2   ;Action    ;
                      CaptionML=[DAN=Ud&styrsoversigt;
                                 ENU=Misc. Articles &Overview];
                      ToolTipML=[DAN=F� vist udstyr, der er registreret for medarbejderen.;
                                 ENU=View miscellaneous articles that are registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5228;
                      Image=FiledOverview }
      { 71      ;2   ;Action    ;
                      CaptionML=[DAN=Fo&rtrolige oplysn. - oversigt;
                                 ENU=Co&nfidential Info. Overview];
                      ToolTipML=[DAN=F� vist fortrolige oplysninger, der er registreret for medarbejderen.;
                                 ENU=View confidential information that is registered for the employee.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5229;
                      Image=ConfidentialOverview }
      { 61      ;2   ;Separator  }
      { 27      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Varepos&ter;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf�rt for den valgte record.;
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
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Importance=Additional;
                Visible=NoFieldVisible;
                OnAssistEdit=BEGIN
                               AssistEdit;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens fornavn.;
                           ENU=Specifies the employee's first name.];
                ApplicationArea=#BasicHR;
                SourceExpr="First Name";
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens mellemnavn.;
                           ENU=Specifies the employee's middle name.];
                ApplicationArea=#BasicHR;
                SourceExpr="Middle Name" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens efternavn.;
                           ENU=Specifies the employee's last name.];
                ApplicationArea=#BasicHR;
                SourceExpr="Last Name";
                ShowMandatory=TRUE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens stilling.;
                           ENU=Specifies the employee's job title.];
                ApplicationArea=#BasicHR;
                SourceExpr="Job Title";
                Importance=Promoted }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens initialer.;
                           ENU=Specifies the employee's initials.];
                ApplicationArea=#Advanced;
                SourceExpr=Initials }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s�ge efter den �nskede record, hvis du ikke kan huske v�rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Name" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens k�n.;
                           ENU=Specifies the employee's gender.];
                ApplicationArea=#Advanced;
                SourceExpr=Gender }

    { 74  ;2   ;Field     ;
                Name=Phone No.2;
                CaptionML=[DAN=Virksomhedstlf.nr.;
                           ENU=Company Phone No.];
                ToolTipML=[DAN=Angiver medarbejderens telefonnummer.;
                           ENU=Specifies the employee's telephone number.];
                ApplicationArea=#BasicHR;
                SourceExpr="Phone No." }

    { 48  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver medarbejderens mailadresse i virksomheden.;
                           ENU=Specifies the employee's email address at the company.];
                ApplicationArea=#BasicHR;
                SourceExpr="Company E-Mail" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r denne record sidst blev �ndret.;
                           ENU=Specifies when this record was last modified.];
                ApplicationArea=#BasicHR;
                SourceExpr="Last Date Modified";
                Importance=Additional }

    { 1901147547;2;Field  ;
                ToolTipML=[DAN=Angiver, om adgangen til data skal begr�nses for dataemnet i den daglige drift. Dette er eksempelvis nyttigt, n�r du vil beskytte data mod �ndringer, mens det kontrolleres, om de indeholder personlige oplysninger.;
                           ENU=Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.];
                ApplicationArea=#BasicHR;
                SourceExpr="Privacy Blocked";
                Importance=Additional }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Adresse og kontakt;
                           ENU=Address & Contact];
                GroupType=Group }

    { 13  ;2   ;Group     ;
                GroupType=Group }

    { 14  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens adresse.;
                           ENU=Specifies the employee's address.];
                ApplicationArea=#BasicHR;
                SourceExpr=Address }

    { 16  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#BasicHR;
                SourceExpr="Address 2" }

    { 20  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#BasicHR;
                SourceExpr="Post Code" }

    { 18  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#BasicHR;
                SourceExpr=City }

    { 82  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr�de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#BasicHR;
                SourceExpr="Country/Region Code" }

    { 5   ;3   ;Field     ;
                Name=ShowMap;
                ToolTipML=[DAN=Angiver medarbejderens adresse p� dit foretrukne onlinekort.;
                           ENU=Specifies the employee's address on your preferred online map.];
                ApplicationArea=#BasicHR;
                SourceExpr=ShowMapLbl;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              CurrPage.UPDATE(TRUE);
                              DisplayMap;
                            END;

                ShowCaption=No }

    { 7   ;2   ;Group     ;
                GroupType=Group }

    { 26  ;3   ;Field     ;
                CaptionML=[DAN=Privat telefonnr.;
                           ENU=Private Phone No.];
                ToolTipML=[DAN=Angiver medarbejderens private telefonnummer.;
                           ENU=Specifies the employee's private telephone number.];
                ApplicationArea=#BasicHR;
                SourceExpr="Mobile Phone No.";
                Importance=Promoted }

    { 93  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens persons�gernummer.;
                           ENU=Specifies the employee's pager number.];
                ApplicationArea=#Advanced;
                SourceExpr=Pager }

    { 72  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens lokaltelefonnummer.;
                           ENU=Specifies the employee's telephone extension.];
                ApplicationArea=#BasicHR;
                SourceExpr=Extension;
                Importance=Promoted }

    { 24  ;3   ;Field     ;
                CaptionML=[DAN=Direkte telefonnummer;
                           ENU=Direct Phone No.];
                ToolTipML=[DAN=Angiver medarbejderens telefonnummer.;
                           ENU=Specifies the employee's telephone number.];
                ApplicationArea=#Advanced;
                SourceExpr="Phone No.";
                Importance=Promoted }

    { 28  ;3   ;Field     ;
                CaptionML=[DAN=Privat mail;
                           ENU=Private Email];
                ToolTipML=[DAN=Angiver medarbejderens private mailadresse.;
                           ENU=Specifies the employee's private email address.];
                ApplicationArea=#BasicHR;
                SourceExpr="E-Mail";
                Importance=Promoted }

    { 32  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ adresse.;
                           ENU=Specifies a code for an alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr="Alt. Address Code" }

    { 34  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen, hvor den alternative adresse tr�der i kraft.;
                           ENU=Specifies the starting date when the alternate address is valid.];
                ApplicationArea=#Advanced;
                SourceExpr="Alt. Address Start Date" }

    { 36  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dag, hvor den alternative adresse er gyldig.;
                           ENU=Specifies the last day when the alternate address is valid.];
                ApplicationArea=#Advanced;
                SourceExpr="Alt. Address End Date" }

    { 1900121501;1;Group  ;
                CaptionML=[DAN=Ops�tning;
                           ENU=Administration] }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor medarbejderen begyndte at arbejde i virksomheden.;
                           ENU=Specifies the date when the employee began to work for the company.];
                ApplicationArea=#BasicHR;
                SourceExpr="Employment Date";
                Importance=Promoted }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens ans�ttelsesstatus.;
                           ENU=Specifies the employment status of the employee.];
                ApplicationArea=#BasicHR;
                SourceExpr=Status;
                Importance=Promoted }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor medarbejderen blev inaktiv, f.eks. p� grund af en skade eller barselsorlov.;
                           ENU=Specifies the date when the employee became inactive, due to disability or maternity leave, for example.];
                ApplicationArea=#Advanced;
                SourceExpr="Inactive Date" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for inaktivitets�rsagen for medarbejderen.;
                           ENU=Specifies a code for the cause of inactivity by the employee.];
                ApplicationArea=#Advanced;
                SourceExpr="Cause of Inactivity Code" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor medarbejderen fratr�dte f.eks. p� grund af pensionering eller afskedigelse.;
                           ENU=Specifies the date when the employee was terminated, due to retirement or dismissal, for example.];
                ApplicationArea=#BasicHR;
                SourceExpr="Termination Date" }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en fratr�delseskode for den medarbejder, der er fratr�dt.;
                           ENU=Specifies a termination code for the employee who has been terminated.];
                ApplicationArea=#Advanced;
                SourceExpr="Grounds for Term. Code" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for medarbejderens ans�ttelseskontrakt.;
                           ENU=Specifies the employment contract code for the employee.];
                ApplicationArea=#Advanced;
                SourceExpr="Emplymt. Contract Code" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en statistikgruppekode, der tildeles medarbejderen til statistiske form�l.;
                           ENU=Specifies a statistics group code to assign to the employee for statistical purposes.];
                ApplicationArea=#Advanced;
                SourceExpr="Statistics Group Code" }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et ressourcenummer for medarbejderen.;
                           ENU=Specifies a resource number for the employee.];
                ApplicationArea=#BasicHR;
                SourceExpr="Resource No." }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en s�lger- eller indk�berkode for medarbejderen.;
                           ENU=Specifies a salesperson or purchaser code for the employee.];
                ApplicationArea=#Advanced;
                SourceExpr="Salespers./Purch. Code" }

    { 1901160401;1;Group  ;
                CaptionML=[DAN=Personlig;
                           ENU=Personal] }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens f�dselsdato.;
                           ENU=Specifies the employee's date of birth.];
                ApplicationArea=#BasicHR;
                SourceExpr="Birth Date";
                Importance=Promoted }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens CPR-nummer.;
                           ENU=Specifies the social security number of the employee.];
                ApplicationArea=#BasicHR;
                SourceExpr="Social Security No.";
                Importance=Promoted }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens kode for fagforeningsmedlemskab.;
                           ENU=Specifies the employee's labor union membership code.];
                ApplicationArea=#Advanced;
                SourceExpr="Union Code" }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens fagforeningsmedlemsnummer.;
                           ENU=Specifies the employee's labor union membership number.];
                ApplicationArea=#Advanced;
                SourceExpr="Union Membership No." }

    { 9   ;1   ;Group     ;
                CaptionML=[DAN=Udbetaling kladde;
                           ENU=Payments];
                GroupType=Group }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens type for at knytte forretningstransaktioner, der er foretaget for denne medarbejder, til den relevante finanskonto.;
                           ENU=Specifies the employee's type to link business transactions made for the employee with the appropriate account in the general ledger.];
                ApplicationArea=#BasicHR;
                SourceExpr="Employee Posting Group";
                LookupPageID=Employee Posting Groups }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan du kan udligne betalinger p� poster for denne medarbejder.;
                           ENU=Specifies how to apply payments to entries for this employee.];
                ApplicationArea=#BasicHR;
                SourceExpr="Application Method" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankens registreringsnummer.;
                           ENU=Specifies a number of the bank branch.];
                ApplicationArea=#BasicHR;
                SourceExpr="Bank Branch No." }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den bankkonto, der benyttes af banken.;
                           ENU=Specifies the number used by the bank for the bank account.];
                ApplicationArea=#BasicHR;
                SourceExpr="Bank Account No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontoens internationale bankkontonummer.;
                           ENU=Specifies the bank account's international bank account number.];
                ApplicationArea=#BasicHR;
                SourceExpr=IBAN }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver SWIFT-koden (internationalt bank-id) p� den bank, hvor medarbejderen har bankkontoen.;
                           ENU=Specifies the SWIFT code (international bank identifier code) of the bank where the employee has the account.];
                ApplicationArea=#BasicHR;
                SourceExpr="SWIFT Code" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 3   ;1   ;Part      ;
                ApplicationArea=#BasicHR;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page5202;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ShowMapLbl@1000 : TextConst 'DAN=Vis p� kort;ENU=Show on Map';
      NoFieldVisible@1001 : Boolean;

    LOCAL PROCEDURE SetNoFieldVisible@13();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      NoFieldVisible := DocumentNoVisibility.EmployeeNoIsVisible;
    END;

    BEGIN
    END.
  }
}

