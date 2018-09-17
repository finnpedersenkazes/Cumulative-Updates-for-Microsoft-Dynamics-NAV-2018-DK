OBJECT Page 5361 Integration Field Mapping List
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
    CaptionML=[DAN=Oversigt over integrationsfeltkoblinger;
               ENU=Integration Field Mapping List];
    SourceTable=Table5336;
    DataCaptionExpr="Integration Table Mapping Name";
    PageType=List;
    OnAfterGetRecord=BEGIN
                       GetFieldCaptions;
                     END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver feltets nummer i Dynamics NAV.;
                           ENU=Specifies the number of the field in Dynamics NAV.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Field No." }

    { 3   ;2   ;Field     ;
                Name=FieldName;
                CaptionML=[DAN=Feltnavn;
                           ENU=Field Name];
                ToolTipML=[DAN=Angiver navnet p† feltet i Dynamics NAV.;
                           ENU=Specifies the name of the field in Dynamics NAV.];
                ApplicationArea=#Suite;
                SourceExpr=NAVFieldName }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† feltet i Dynamics 365 for Sales.;
                           ENU=Specifies the number of the field in Dynamics 365 for Sales.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Integration Table Field No." }

    { 11  ;2   ;Field     ;
                Name=IntegrationFieldName;
                CaptionML=[DAN=Integrationsfeltnavn;
                           ENU=Integration Field Name];
                ToolTipML=[DAN=Angiver navnet p† feltet i Dynamics 365 for Sales.;
                           ENU=Specifies the name of the field in Dynamics 365 for Sales.];
                ApplicationArea=#Suite;
                SourceExpr=CRMFieldName }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver retningen for synkroniseringen.;
                           ENU=Specifies the direction of the synchronization.];
                ApplicationArea=#Suite;
                SourceExpr=Direction }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den konstante v‘rdi, som det tilknyttede felt vil blive indstillet til.;
                           ENU=Specifies the constant value that the mapped field will be set to.];
                ApplicationArea=#Suite;
                SourceExpr="Constant Value" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver, om feltet skal valideres under tildelingen i Dynamics NAV. ";
                           ENU="Specifies if the field should be validated during assignment in Dynamics NAV. "];
                ApplicationArea=#Suite;
                SourceExpr="Validate Field" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om integrationsfeltet skal valideres under tildelingen i Dynamics 365 for Sales.;
                           ENU=Specifies if the integration field should be validated during assignment in Dynamics 365 for Sales.];
                ApplicationArea=#Suite;
                SourceExpr="Validate Integration Table Fld" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om feltv‘rdien skal ryddes, hvis der opst†r integrationsfejl under tildelingen i Dynamics 365 for Sales.;
                           ENU=Specifies if the field value should be cleared in case of integration error during assignment in Dynamics 365 for Sales.];
                ApplicationArea=#Suite;
                SourceExpr="Clear Value on Failed Sync" }

  }
  CODE
  {
    VAR
      TypeHelper@1002 : Codeunit 10;
      NAVFieldName@1000 : Text;
      CRMFieldName@1001 : Text;

    LOCAL PROCEDURE GetFieldCaptions@3();
    VAR
      IntegrationTableMapping@1003 : Record 5335;
    BEGIN
      IntegrationTableMapping.GET("Integration Table Mapping Name");
      NAVFieldName := GetFieldCaption(IntegrationTableMapping."Table ID","Field No.");
      CRMFieldName := GetFieldCaption(IntegrationTableMapping."Integration Table ID","Integration Table Field No.");
    END;

    LOCAL PROCEDURE GetFieldCaption@1(TableID@1000 : Integer;FieldID@1001 : Integer) : Text;
    VAR
      Field@1002 : Record 2000000041;
    BEGIN
      IF (TableID <> 0) AND (FieldID <> 0) THEN
        IF TypeHelper.GetField(TableID,FieldID,Field) THEN
          EXIT(Field."Field Caption");
      EXIT('');
    END;

    BEGIN
    END.
  }
}

