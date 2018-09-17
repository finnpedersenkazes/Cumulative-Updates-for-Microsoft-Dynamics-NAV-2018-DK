OBJECT Page 5233 Human Resources Setup
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opsëtning af Personale;
               ENU=Human Resources Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5218;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Medarbejder,Dokumenter;
                                ENU=New,Process,Report,Employee,Documents];
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
               END;

    ActionList=ACTIONS
    {
      { 10      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Personaleenheder;
                                 ENU=Human Res. Units of Measure];
                      ToolTipML=[DAN=Konfigurer de enheder, f.eks. DAG eller TIME, som du kan vëlge mellem, i vinduet Opsëtning af Personale for at definere, hvordan ansëttelsestiden registreres.;
                                 ENU=Set up the units of measure, such as DAY or HOUR, that you can select from in the Human Resources Setup window to define how employment time is recorded.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5236;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=UnitOfMeasure;
                      PromotedCategory=Process }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=FravërsÜrsager;
                                 ENU=Causes of Absence];
                      ToolTipML=[DAN=Konfigurer Ürsager til, at en medarbejder kan vëre fravërende.;
                                 ENU=Set up reasons why an employee can be absent.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5210;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AbsenceCategory;
                      PromotedCategory=Process }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=InaktivitetsÜrsager;
                                 ENU=Causes of Inactivity];
                      ToolTipML=[DAN=Konfigurer Ürsager til, at en medarbejder kan vëre inaktiv.;
                                 ENU=Set up reasons why an employee can be inactive.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5214;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=InactivityDescription;
                      PromotedCategory=Process }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=FratrëdelsesÜrsag;
                                 ENU=Grounds for Termination];
                      ToolTipML=[DAN=Konfigurer Ürsager til, at en ansëttelse kan ophõre.;
                                 ENU=Set up reasons why an employment can be terminated.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5215;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=TerminationDescription;
                      PromotedCategory=Process }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Fagforeninger;
                                 ENU=Unions];
                      ToolTipML=[DAN=Konfigurer de forskellige fagforeninger, som medarbejdere kan vëre medlem af, sÜ du kan vëlge dem pÜ medarbejderkortet.;
                                 ENU=Set up different worker unions that employees may be members of, so that you can select it on the employee card.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5213;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Union;
                      PromotedCategory=Category4 }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=Ansëttelseskontrakter;
                                 ENU=Employment Contracts];
                      ToolTipML=[DAN=Konfigurer de forskellige kontrakttyper, som medarbejdere kan ansëttes under, f.eks. administration eller produktion.;
                                 ENU=Set up the different types of contracts that employees can be employed under, such as Administration or Production.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5217;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=EmployeeAgreement;
                      PromotedCategory=Category5 }
      { 17      ;1   ;Action    ;
                      CaptionML=[DAN=Familiemedlemmer;
                                 ENU=Relatives];
                      ToolTipML=[DAN=Konfigurer de typer af familiemedlemmer, du kan vëlge mellem pÜ medarbejderkort.;
                                 ENU=Set up the types of relatives that you can select from on employee cards.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5208;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Relatives;
                      PromotedCategory=Category4 }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=Udstyr;
                                 ENU=Misc. Articles];
                      ToolTipML=[DAN=Konfigurer de typer af virksomhedsaktiver, som medarbejdere bruger, som f.eks. BIL eller COMPUTER, som du kan vëlge mellem pÜ medarbejderkort.;
                                 ENU=Set up types of company assets that employees use, such as CAR or COMPUTER, that you can select from on employee cards.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5218;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Archive;
                      PromotedCategory=Category5 }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=Fortroligt;
                                 ENU=Confidential];
                      ToolTipML=[DAN=Konfigurer de typer af fortrolige oplysninger, som f.eks. LùN eller FORSIKRING, som du kan vëlge mellem pÜ medarbejderkort.;
                                 ENU=Set up types of confidential information, such as SALARY or INSURANCE, that you can select from on employee cards.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5220;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ConfidentialOverview;
                      PromotedCategory=Category5 }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=Kvalifikationer;
                                 ENU=Qualifications];
                      ToolTipML=[DAN=Konfigurer de typer af kvalifikationer, som f.eks. DESIGN eller REGNSKAB, som du kan vëlge mellem pÜ medarbejderkort.;
                                 ENU=Set up types of qualifications, such as DESIGN or ACCOUNTANT, that you can select from on employee cards.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5205;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=QualificationOverview;
                      PromotedCategory=Category4 }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Medarbejderstatistikgrupper;
                                 ENU=Employee Statistics Groups];
                      ToolTipML=[DAN=Konfigurer lõntyper, som f.eks. TIMELùN eller MèNEDSLùN, som du bruger i forbindelse med statistik.;
                                 ENU=Set up salary types, such as HOURLY or MONTHLY, that you use for statistical purposes.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5216;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=StatisticsGroup;
                      PromotedCategory=Category4 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Nummerering;
                           ENU=Numbering] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der skal bruges ved tildeling af numre til medarbejdere.;
                           ENU=Specifies the number series code to use when assigning numbers to employees.];
                ApplicationArea=#BasicHR;
                SourceExpr="Employee Nos." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver basisenheden som f.eks. time eller dag.;
                           ENU=Specifies the base unit of measure, such as hour or day.];
                ApplicationArea=#Advanced;
                SourceExpr="Base Unit of Measure" }

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

