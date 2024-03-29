OBJECT Codeunit 248 VAT Lookup Ext. Data Hndl
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    TableNo=249;
    Permissions=TableData 249=rimd;
    OnRun=BEGIN
            VATRegistrationLog := Rec;

            LookupVatRegistrationFromWebService(TRUE);

            Rec := VATRegistrationLog;
          END;

  }
  CODE
  {
    VAR
      NamespaceTxt@1003 : TextConst '@@@={Locked};DAN=urn:ec.europa.eu:taxud:vies:services:checkVat:types;ENU=urn:ec.europa.eu:taxud:vies:services:checkVat:types';
      VATRegistrationLog@1000 : Record 249;
      VATRegistrationLogMgt@1002 : Codeunit 249;
      VatRegNrValidationWebServiceURLTxt@1001 : TextConst '@@@={Locked};DAN=http://ec.europa.eu/taxation_customs/vies/services/checkVatService;ENU=http://ec.europa.eu/taxation_customs/vies/services/checkVatService';
      VATRegistrationURL@1005 : Text;

    LOCAL PROCEDURE LookupVatRegistrationFromWebService@7(ShowErrors@1000 : Boolean);
    VAR
      RequestBodyTempBlob@1002 : Record 99008535;
    BEGIN
      RequestBodyTempBlob.INIT;

      SendRequestToVatRegistrationService(RequestBodyTempBlob,ShowErrors);

      InsertLogEntry(RequestBodyTempBlob);

      COMMIT;
    END;

    LOCAL PROCEDURE SendRequestToVatRegistrationService@1(VAR BodyTempBlob@1004 : Record 99008535;ShowErrors@1003 : Boolean);
    VAR
      VATRegNoSrvConfig@1005 : Record 248;
      SOAPWebServiceRequestMgt@1001 : Codeunit 1290;
      ResponseInStream@1002 : InStream;
      InStream@1006 : InStream;
      ResponseOutStream@1008 : OutStream;
    BEGIN
      PrepareSOAPRequestBody(BodyTempBlob);

      BodyTempBlob.Blob.CREATEINSTREAM(InStream);
      VATRegistrationURL := VATRegNoSrvConfig.GetVATRegNoURL;
      SOAPWebServiceRequestMgt.SetGlobals(InStream,VATRegistrationURL,'','');
      SOAPWebServiceRequestMgt.DisableHttpsCheck;
      SOAPWebServiceRequestMgt.SetTimeout(60000);

      IF SOAPWebServiceRequestMgt.SendRequestToWebService THEN BEGIN
        SOAPWebServiceRequestMgt.GetResponseContent(ResponseInStream);

        BodyTempBlob.Blob.CREATEOUTSTREAM(ResponseOutStream);
        COPYSTREAM(ResponseOutStream,ResponseInStream);
      END ELSE
        IF ShowErrors THEN
          SOAPWebServiceRequestMgt.ProcessFaultResponse('');
    END;

    LOCAL PROCEDURE PrepareSOAPRequestBody@12(VAR BodyTempBlob@1000 : Record 99008535);
    VAR
      XMLDOMMgt@1006 : Codeunit 6224;
      BodyContentInputStream@1004 : InStream;
      BodyContentOutputStream@1005 : OutStream;
      BodyContentXmlDoc@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      EnvelopeXmlNode@1012 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      CreatedXmlNode@1001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      BodyTempBlob.Blob.CREATEINSTREAM(BodyContentInputStream);
      BodyContentXmlDoc := BodyContentXmlDoc.XmlDocument;

      XMLDOMMgt.AddRootElementWithPrefix(BodyContentXmlDoc,'checkVatApprox','',NamespaceTxt,EnvelopeXmlNode);
      XMLDOMMgt.AddElement(EnvelopeXmlNode,'countryCode',VATRegistrationLog.GetCountryCode,NamespaceTxt,CreatedXmlNode);
      XMLDOMMgt.AddElement(EnvelopeXmlNode,'vatNumber',VATRegistrationLog.GetVATRegNo,NamespaceTxt,CreatedXmlNode);

      CLEAR(BodyTempBlob.Blob);
      BodyTempBlob.Blob.CREATEOUTSTREAM(BodyContentOutputStream);
      BodyContentXmlDoc.Save(BodyContentOutputStream);
    END;

    LOCAL PROCEDURE InsertLogEntry@4(ResponseBodyTempBlob@1000 : Record 99008535);
    VAR
      XMLDOMManagement@1001 : Codeunit 6224;
      XMLDocOut@1012 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      InStream@1009 : InStream;
    BEGIN
      ResponseBodyTempBlob.Blob.CREATEINSTREAM(InStream);
      XMLDOMManagement.LoadXMLDocumentFromInStream(InStream,XMLDocOut);

      VATRegistrationLogMgt.LogVerification(VATRegistrationLog,XMLDocOut,NamespaceTxt);
    END;

    [External]
    PROCEDURE GetVATRegNrValidationWebServiceURL@5() : Text[250];
    BEGIN
      EXIT(VatRegNrValidationWebServiceURLTxt);
    END;

    BEGIN
    END.
  }
}

