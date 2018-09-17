OBJECT Codeunit 783 Relationship Performance Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      CreateOpportunityQst@1003 : TextConst '@@@=%1 - Contact No.;DAN=Vil du oprette en salgsmulighed for kontakten %1?;ENU=Do you want to create an opportunity for contact %1?';
      CreateOpportunityCaptionTxt@1001 : TextConst 'DAN=Opret salgsmulighed ...;ENU=Create opportunity...';

    LOCAL PROCEDURE CalcTopFiveOpportunities@2(VAR TempOpportunity@1004 : TEMPORARY Record 5092);
    VAR
      Opportunity@1002 : Record 5092;
      I@1003 : Integer;
    BEGIN
      TempOpportunity.DELETEALL;
      Opportunity.SETAUTOCALCFIELDS("Estimated Value (LCY)");
      Opportunity.SETRANGE(Closed,FALSE);
      Opportunity.SETCURRENTKEY("Estimated Value (LCY)");
      Opportunity.ASCENDING(FALSE);
      IF Opportunity.FINDSET THEN
        REPEAT
          I += 1;
          TempOpportunity := Opportunity;
          TempOpportunity.INSERT;
        UNTIL (Opportunity.NEXT = 0) OR (I = 5);
    END;

    [External]
    PROCEDURE DrillDown@31(VAR BusinessChartBuffer@1000 : Record 485;VAR TempOpportunity@1003 : TEMPORARY Record 5092);
    VAR
      Opportunity@1002 : Record 5092;
    BEGIN
      IF TempOpportunity.FINDSET THEN BEGIN
        TempOpportunity.NEXT(BusinessChartBuffer."Drill-Down X Index");
        Opportunity.SETRANGE("No.",TempOpportunity."No.");
        PAGE.RUN(PAGE::"Opportunity List",Opportunity);
      END;
    END;

    [Internal]
    PROCEDURE UpdateData@3(VAR BusinessChartBuffer@1000 : Record 485;VAR TempOpportunity@1005 : TEMPORARY Record 5092);
    VAR
      I@1002 : Integer;
    BEGIN
      WITH BusinessChartBuffer DO BEGIN
        Initialize;
        AddMeasure(TempOpportunity.FIELDCAPTION("Estimated Value (LCY)"),1,"Data Type"::Decimal,"Chart Type"::StackedColumn);
        SetXAxis(TempOpportunity.TABLECAPTION,"Data Type"::String);
        CalcTopFiveOpportunities(TempOpportunity);
        TempOpportunity.SETAUTOCALCFIELDS("Estimated Value (LCY)");
        IF TempOpportunity.FINDSET THEN
          REPEAT
            I += 1;
            AddColumn(TempOpportunity.Description);
            SetValueByIndex(0,I - 1,TempOpportunity."Estimated Value (LCY)");
          UNTIL TempOpportunity.NEXT = 0;
      END;
    END;

    PROCEDURE SendCreateOpportunityNotification@35(SegmentLine@1003 : Record 5077);
    VAR
      InteractionLogEntry@1001 : Record 5065;
      CreateOpportunityNotification@1000 : Notification;
    BEGIN
      CreateOpportunityNotification.ID := CREATEGUID;
      CreateOpportunityNotification.MESSAGE := STRSUBSTNO(CreateOpportunityQst,SegmentLine."Contact No.");
      InteractionLogEntry.SETRANGE("User ID",USERID);
      InteractionLogEntry.SETRANGE("Contact No.",SegmentLine."Contact No.");
      InteractionLogEntry.FINDFIRST;
      CreateOpportunityNotification.SETDATA(
        GetSegmentLineNotificationDataItemID,RecordsToXml(SegmentLine,InteractionLogEntry));
      CreateOpportunityNotification.SCOPE(NOTIFICATIONSCOPE::LocalScope);
      CreateOpportunityNotification.ADDACTION(
        CreateOpportunityCaptionTxt,CODEUNIT::"Relationship Performance Mgt.",'CreateOpportunityFromSegmentLineNotification');
      CreateOpportunityNotification.SEND;
    END;

    PROCEDURE CreateOpportunityFromSegmentLineNotification@32(VAR CreateOpportunityNotification@1002 : Notification);
    VAR
      TempSegmentLine@1001 : TEMPORARY Record 5077;
      InteractionLogEntry@1003 : Record 5065;
    BEGIN
      TempSegmentLine.INIT;
      TempSegmentLine.INSERT;
      XmlToRecords(
        CreateOpportunityNotification.GETDATA(GetSegmentLineNotificationDataItemID),TempSegmentLine,InteractionLogEntry);
      InteractionLogEntry."Opportunity No." := TempSegmentLine.CreateOpportunity;
      InteractionLogEntry.MODIFY;
    END;

    LOCAL PROCEDURE RecordsToXml@1(SegmentLine@1000 : Record 5077;InteractionLogEntry@1004 : Record 5065) : Text;
    VAR
      XMLDOMManagement@1001 : Codeunit 6224;
      RecRef@1006 : RecordRef;
      DotNetXmlDocument@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      XmlRootNode@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      XmlNode@1002 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      DotNetXmlDocument := DotNetXmlDocument.XmlDocument;

      XMLDOMManagement.AddRootElement(DotNetXmlDocument,'Notification',XmlRootNode);

      RecRef.GETTABLE(SegmentLine);
      XMLDOMManagement.AddElement(XmlRootNode,GetXmlTableName(RecRef),'','',XmlNode);
      AddFieldToXml(XmlNode,RecRef.FIELD(SegmentLine.FIELDNO("Segment No.")));
      AddFieldToXml(XmlNode,RecRef.FIELD(SegmentLine.FIELDNO(Description)));
      AddFieldToXml(XmlNode,RecRef.FIELD(SegmentLine.FIELDNO("Campaign No.")));
      AddFieldToXml(XmlNode,RecRef.FIELD(SegmentLine.FIELDNO("Salesperson Code")));
      AddFieldToXml(XmlNode,RecRef.FIELD(SegmentLine.FIELDNO("Contact No.")));
      AddFieldToXml(XmlNode,RecRef.FIELD(SegmentLine.FIELDNO("Contact Company No.")));
      RecRef.CLOSE;

      RecRef.GETTABLE(InteractionLogEntry);
      XMLDOMManagement.AddElement(XmlRootNode,GetXmlTableName(RecRef),'','',XmlNode);
      AddFieldToXml(XmlNode,RecRef.FIELD(InteractionLogEntry.FIELDNO("Entry No.")));
      RecRef.CLOSE;

      EXIT(DotNetXmlDocument.OuterXml);
    END;

    LOCAL PROCEDURE XmlToRecords@4(InText@1000 : Text;VAR SegmentLine@1001 : Record 5077;VAR InteractionLogEntry@1004 : Record 5065);
    VAR
      XMLDOMManagement@1003 : Codeunit 6224;
      RecRef@1002 : RecordRef;
      DotNetXmlDocument@1007 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      XmlRootNode@1006 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      XMLDOMManagement.LoadXMLDocumentFromText(InText,DotNetXmlDocument);

      RecRef.GETTABLE(SegmentLine);
      XMLDOMManagement.FindNode(DotNetXmlDocument.DocumentElement,GetXmlTableName(RecRef),XmlRootNode);
      SetFieldFromXml(RecRef,SegmentLine.FIELDNO("Segment No."),XmlRootNode);
      SetFieldFromXml(RecRef,SegmentLine.FIELDNO(Description),XmlRootNode);
      SetFieldFromXml(RecRef,SegmentLine.FIELDNO("Campaign No."),XmlRootNode);
      SetFieldFromXml(RecRef,SegmentLine.FIELDNO("Salesperson Code"),XmlRootNode);
      SetFieldFromXml(RecRef,SegmentLine.FIELDNO("Contact No."),XmlRootNode);
      SetFieldFromXml(RecRef,SegmentLine.FIELDNO("Contact Company No."),XmlRootNode);
      RecRef.MODIFY;
      RecRef.SETTABLE(SegmentLine);
      RecRef.CLOSE;

      RecRef.OPEN(DATABASE::"Interaction Log Entry");
      XMLDOMManagement.FindNode(DotNetXmlDocument.DocumentElement,GetXmlTableName(RecRef),XmlRootNode);
      SetFieldFromXml(RecRef,InteractionLogEntry.FIELDNO("Entry No."),XmlRootNode);
      RecRef.FIND;
      RecRef.SETTABLE(InteractionLogEntry);
    END;

    LOCAL PROCEDURE AddFieldToXml@9(VAR XmlNode@1002 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";FieldRef@1001 : FieldRef);
    VAR
      XMLDOMManagement@1003 : Codeunit 6224;
      XmlNodeChild@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      XMLDOMManagement.AddElement(XmlNode,GetXmlNodeName(FieldRef.NUMBER),FORMAT(FieldRef.VALUE),'',XmlNodeChild);
    END;

    LOCAL PROCEDURE SetFieldFromXml@15(RecRef@1000 : RecordRef;FieldNo@1001 : Integer;XmlRootNode@1006 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode");
    VAR
      XMLDOMManagement@1003 : Codeunit 6224;
      FieldRef@1002 : FieldRef;
    BEGIN
      FieldRef := RecRef.FIELD(FieldNo);
      FieldRef.VALUE :=
        XMLDOMManagement.FindNodeText(XmlRootNode,GetXmlNodeName(FieldNo));
    END;

    LOCAL PROCEDURE GetXmlNodeName@23(FieldNo@1000 : Integer) : Text;
    BEGIN
      EXIT(STRSUBSTNO('F_%1',FORMAT(FieldNo)));
    END;

    LOCAL PROCEDURE GetXmlTableName@5(RecRef@1000 : RecordRef) : Text;
    BEGIN
      EXIT(DELCHR(RecRef.NAME,'=',' '));
    END;

    LOCAL PROCEDURE GetSegmentLineNotificationDataItemID@6() : Text;
    BEGIN
      EXIT('SegmentLineNotificationTok');
    END;

    BEGIN
    END.
  }
}

