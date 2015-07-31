using Interop.QBFC13;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Forms;

namespace SimpleQbCMS.Authorisations
{
    class QbOperations
    {
        private DataTable AddColumnsToDataTable(DataTable dt)
        {
            dt.Columns.Add("ListID", typeof(string));
            dt.Columns.Add("FullName", typeof(string));

            return dt;
        }

        public DataTable GetCustomerListFromQB()
        {
            try
            {
                QBSessionManager SessionManager = new QBSessionManager();
                IMsgSetResponse iMsgResponse;
                IResponseList iResponseList;
                ICustomerQuery IcustQuery;

                SessionManager = new Operations().OpenQBConnection();
                IMsgSetRequest ImsgReq = new Operations().StartQBSession(SessionManager);
                IcustQuery = ImsgReq.AppendCustomerQueryRq();
                iMsgResponse = SessionManager.DoRequests(ImsgReq);
                new Operations().CloseQBSession(SessionManager);
                iResponseList = iMsgResponse.ResponseList;
                DataTable dtCustList = new DataTable();
                dtCustList = AddColumnsToDataTable(dtCustList);
                IResponse IcustResponse = iResponseList.GetAt(0);
                ICustomerRetList ICustList = (ICustomerRetList)IcustResponse.Detail;

                if (ICustList != null && ICustList.Count > 0)
                {
                    int _pubIntCounter = 0;
                    for (_pubIntCounter = 0; _pubIntCounter <= ICustList.Count - 1; _pubIntCounter++)
                    {
                        dtCustList.Rows.Add(ICustList.GetAt(_pubIntCounter).ListID.GetValue().ToString(), ICustList.GetAt(_pubIntCounter).Name.GetValue().ToString());
                    }
                    dtCustList.AcceptChanges();

                }

                return dtCustList;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Problem in Loading Customer Data. " + Environment.NewLine + ex.Message + Environment.NewLine + ex.StackTrace.ToString());
                return null;
            }
        }

        public DataTable GetVendorListFromQB()
        {
            try
            {
                QBSessionManager SessionManager = new QBSessionManager();
                IMsgSetResponse iMsgResponse;
                IResponseList iResponseList;
                IVendorQuery IvendorQuery;


                SessionManager = new Operations().OpenQBConnection();

                IMsgSetRequest ImsgReq = new Operations().StartQBSession(SessionManager);

                IvendorQuery = ImsgReq.AppendVendorQueryRq();

                iMsgResponse = SessionManager.DoRequests(ImsgReq);

                new Operations().CloseQBSession(SessionManager);

                iResponseList = iMsgResponse.ResponseList;

                DataTable dtCustList = new DataTable();

                dtCustList = AddColumnsToDataTable(dtCustList);

                IResponse IVendorResponse = iResponseList.GetAt(0);

                IVendorRetList IVendorList = (IVendorRetList)IVendorResponse.Detail;

                if (IVendorList != null && IVendorList.Count > 0)
                {
                    int _pubIntCounter = 0;
                    for (_pubIntCounter = 0; _pubIntCounter <= IVendorList.Count - 1; _pubIntCounter++)
                    {
                        dtCustList.Rows.Add(IVendorList.GetAt(_pubIntCounter).ListID.GetValue().ToString(), IVendorList.GetAt(_pubIntCounter).Name.GetValue().ToString());
                    }
                    dtCustList.AcceptChanges();

                }

                return dtCustList;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Problem in Loading Customer Data. " + Environment.NewLine + ex.Message + Environment.NewLine + ex.StackTrace.ToString());
                return null;
            }
        }

        public DataTable GetAccountListFromQB()
        {
            try
            {
                QBSessionManager SessionManager = new QBSessionManager();
                IMsgSetResponse iMsgResponse;
                IResponseList iResponseList;
                ICustomerQuery IcustQuery;

                SessionManager = new Operations().OpenQBConnection();
                IMsgSetRequest ImsgReq = new Operations().StartQBSession(SessionManager);
                IcustQuery = ImsgReq.AppendCustomerQueryRq();
                iMsgResponse = SessionManager.DoRequests(ImsgReq);
                new Operations().CloseQBSession(SessionManager);
                iResponseList = iMsgResponse.ResponseList;
                DataTable dtCustList = new DataTable();
                dtCustList = AddColumnsToDataTable(dtCustList);
                IResponse IcustResponse = iResponseList.GetAt(0);
                ICustomerRetList ICustList = (ICustomerRetList)IcustResponse.Detail;

                if (ICustList != null && ICustList.Count > 0)
                {
                    int _pubIntCounter = 0;
                    for (_pubIntCounter = 0; _pubIntCounter <= ICustList.Count - 1; _pubIntCounter++)
                    {
                        dtCustList.Rows.Add(ICustList.GetAt(_pubIntCounter).ListID.GetValue().ToString(), ICustList.GetAt(_pubIntCounter).Name.GetValue().ToString());
                    }
                    dtCustList.AcceptChanges();

                }

                return dtCustList;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Problem in Loading Customer Data. " + Environment.NewLine + ex.Message + Environment.NewLine + ex.StackTrace.ToString());
                return null;
            }
        }

        public DataTable GetBillListFromQB()
        {
            try
            {
                QBSessionManager SessionManager = new QBSessionManager();
                IMsgSetResponse iMsgResponse;
                IResponseList iResponseList;
                IBillQuery IbillQuery;

                SessionManager = new Operations().OpenQBConnection();

                IMsgSetRequest ImsgReq = new Operations().StartQBSession(SessionManager);

                IbillQuery = ImsgReq.AppendBillQueryRq();

                iMsgResponse = SessionManager.DoRequests(ImsgReq);

                new Operations().CloseQBSession(SessionManager);

                iResponseList = iMsgResponse.ResponseList;

                DataTable dtBillList = new DataTable();

                dtBillList = AddColumnsToDataTable(dtBillList);

                IResponse IVendorResponse = iResponseList.GetAt(0);

                IBillRetList IbillRetList = (IBillRetList)IVendorResponse.Detail;

                if (IbillRetList != null && IbillRetList.Count > 0)
                {
                    int _pubIntCounter = 0;
                    for (_pubIntCounter = 0; _pubIntCounter <= IbillRetList.Count - 1; _pubIntCounter++)
                    {
                        dtBillList.Rows.Add(IbillRetList.GetAt(_pubIntCounter).TxnID.GetValue().ToString(), IbillRetList.GetAt(_pubIntCounter).TxnID.GetValue().ToString());
                    }
                    dtBillList.AcceptChanges();

                }

                return dtBillList;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Problem in Loading Customer Data. " + Environment.NewLine + ex.Message + Environment.NewLine + ex.StackTrace.ToString());
                return null;
            }
        }

        public DataTable GetBillPaymentCheckListFromQB()
        {
            try
            {
                QBSessionManager SessionManager = new QBSessionManager();
                IMsgSetResponse iMsgResponse;
                IResponseList iResponseList;
                IBillPaymentCheckQuery IbillPaymentCheckQuery;

                SessionManager = new Operations().OpenQBConnection();

                IMsgSetRequest ImsgReq = new Operations().StartQBSession(SessionManager);

                IbillPaymentCheckQuery = ImsgReq.AppendBillPaymentCheckQueryRq();

                iMsgResponse = SessionManager.DoRequests(ImsgReq);

                new Operations().CloseQBSession(SessionManager);

                iResponseList = iMsgResponse.ResponseList;

                DataTable dtBillPaymentList = new DataTable();

                dtBillPaymentList = AddColumnsToDataTable(dtBillPaymentList);

                IResponse IVendorResponse = iResponseList.GetAt(0);

                IBillRetList IbillRetList = (IBillRetList)IVendorResponse.Detail;

                if (IbillRetList != null && IbillRetList.Count > 0)
                {
                    int _pubIntCounter = 0;
                    for (_pubIntCounter = 0; _pubIntCounter <= IbillRetList.Count - 1; _pubIntCounter++)
                    {
                        dtBillPaymentList.Rows.Add(IbillRetList.GetAt(_pubIntCounter).TxnID.GetValue().ToString(), IbillRetList.GetAt(_pubIntCounter).TxnID.GetValue().ToString());
                    }
                    dtBillPaymentList.AcceptChanges();

                }

                return dtBillPaymentList;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Problem in Loading Customer Data. " + Environment.NewLine + ex.Message + Environment.NewLine + ex.StackTrace.ToString());
                return null;
            }
        }

        private static string GetPaymentsEditSeq(string PaymentQBId)
        {

            QBSessionManager SessionManager = new QBSessionManager();

            string Retval = string.Empty;
            try
            {
                IResponseList responseList;
                IReceivePaymentRetList PaymentList;
                IMsgSetResponse resp;
                IReceivePaymentQuery Payment;
                SessionManager = new Operations().OpenQBConnection();

                IMsgSetRequest req = new Operations().StartQBSession(SessionManager);

                
                Payment = req.AppendReceivePaymentQueryRq();

                Payment.ORTxnQuery.TxnIDList.Add(PaymentQBId);
                Payment.IncludeLineItems.SetValue(true);
                resp = SessionManager.DoRequests(req);
                new Operations().CloseQBSession(SessionManager);

                responseList = resp.ResponseList;
                IResponse response;
                if (responseList.Count > 0)
                {
                    response = responseList.GetAt(0);
                    PaymentList = (IReceivePaymentRetList)response.Detail;
                    if (PaymentList != null)
                    {
                        Retval = PaymentList.GetAt(0).EditSequence.GetValue();
                    }
                }

                new Operations().CloseQBSession(SessionManager);
                return Retval;
            }
            catch (Exception ex)
            {
                new Operations().CloseQBSession(SessionManager);
                 
            }
            return "";

        }

        public bool UnApplyPaymentsInQBBySync()
        {
            QBSessionManager SessionManager = new QBSessionManager();

            bool RetVal = false;
            try
            {
                string PubStrEditSequence = "";
                //if (((ObjPayment.PubIntType == 2) || (ObjPayment.PubIntType == 6)) && string.Compare(ObjPayment.PubStrStatus, PaymentStatus.Approved, true) == 0)
                {
                    //if (string.IsNullOrEmpty(ObjPayment.PubStrEditSequence))

                    DataTable dt = GetVendorListFromQB();
                    string PubStrQBListID = Convert.ToString(dt.Rows[0]["ListID"]);
                    PubStrEditSequence = GetPaymentsEditSeq(PubStrQBListID);

                    IResponseList responseList;
                    IReceivePaymentRet PaymentRet;
                    IMsgSetResponse resp;
                    IReceivePaymentMod Payment;
                    SessionManager = new Operations().OpenQBConnection();
            
                    IMsgSetRequest req = new Operations().StartQBSession(SessionManager);

                    Payment = req.AppendReceivePaymentModRq();

                    Payment.EditSequence.SetValue(PubStrEditSequence);

                    Payment.TxnID.SetValue(PubStrQBListID);

                    IAppliedToTxnMod applied = Payment.AppliedToTxnModList.Append();

                    applied.TxnID.SetValue(PubStrQBListID);
                    
                    applied.PaymentAmount.SetEmpty();
                    
                    //if (ObjPayment.PubDecAmount < 0)
                    //    applied.PaymentAmount.SetValue(Convert.ToDouble((-ObjPayment.PubDecActualAmount) - (-ObjPayment.PubDecAmount)));
                    //else
                    //    applied.PaymentAmount.SetEmpty();

                    resp = SessionManager.DoRequests(req);

                    new Operations().CloseQBSession(SessionManager);

                    responseList = resp.ResponseList;

                    IResponse response;
                    if (responseList.Count > 0)
                    {
                        response = responseList.GetAt(0);
                        PaymentRet = (IReceivePaymentRet)response.Detail;
                        if (PaymentRet == null)
                        {
                            MessageBox.Show(resp.ResponseList.GetAt(0).StatusMessage);
                            //new ClsTransactionLayer().LogClientErrorSync(new Exception("UnApplying Failed, PaymentID " + ObjPayment.PubIntPaymentID + " " + resp.ResponseList.GetAt(0).StatusCode + " :" + resp.ResponseList.GetAt(0).StatusMessage));
                        }
                    }
                }

                RetVal = true;
            }
            catch (Exception ex)
            {
                new Operations().CloseQBSession(SessionManager);
                  
            }

            return RetVal;
        }

        public bool AddBill(string customerName , double amount)
        {
            QBSessionManager SessionManager = new QBSessionManager();
            SessionManager = new Operations().OpenQBConnection();
            IMsgSetRequest ImsgReq = new Operations().StartQBSession(SessionManager);

            IBillAdd Billadd = ImsgReq.AppendBillAddRq();

            //Billadd.ExternalGUID.SetValue(System.Guid.NewGuid().ToString("B"));
            Billadd.VendorRef.FullName.SetValue(customerName);

            Billadd.TxnDate.SetValue(DateTime.Today);
            Billadd.DueDate.SetValue(DateTime.Today);




            DataTable dt = GetVendorListFromQB();
            //Billadd.VendorRef.ListID.SetValue(dt.Rows[0]["ListID"].ToString());

            IExpenseLineAdd line = Billadd.ExpenseLineAddList.Append();
            line.AccountRef.FullName.SetValue("Automobile");
            line.Amount.SetValue(amount);
            line.Memo.SetValue("Hi");
            line.ClassRef.FullName.SetValue("New Construction");
            IORItemLineAdd lstItems = Billadd.ORItemLineAddList.Append();
            lstItems.ItemLineAdd.Amount.SetValue(10);
            lstItems.ItemLineAdd.ClassRef.FullName.SetValue("New Construction");
            lstItems.ItemLineAdd.ItemRef.FullName.SetValue("Cabinets");

            //IMsgSetResponse iMsgResponse;

            //iMsgResponse = SessionManager.DoRequests(ImsgReq);
            IResponse response = SessionManager.DoRequests(ImsgReq).ResponseList.GetAt(0);
            new Operations().CloseQBSession(SessionManager);

            ImsgReq.Attributes.OnError = ENRqOnError.roeContinue;
            var ss = response.Detail;

            MessageBox.Show(response.StatusCode + response.StatusMessage);

            return true;

        }

        public bool AddVendorCreditMemo(IVendorCreditAdd creditMemoAdd)
        {
            QBSessionManager SessionManager = new QBSessionManager();
            SessionManager = new Operations().OpenQBConnection();
            IMsgSetRequest ImsgReq = new Operations().StartQBSession(SessionManager);

            creditMemoAdd = ImsgReq.AppendVendorCreditAddRq();
            //IVendorCreditAdd dd;

            creditMemoAdd.RefNumber.SetValue("15064428R9");
            //Billadd.ExternalGUID.SetValue(System.Guid.NewGuid().ToString("B"));
            creditMemoAdd.VendorRef.FullName.SetValue("1sai");

            creditMemoAdd.TxnDate.SetValue(DateTime.Today);
            //creditMemoAdd.DueDate.SetValue(DateTime.Today);
            //creditMemoAdd.TermsRef.FullName.SetValue(DateTime.Today);
            creditMemoAdd.Memo.SetValue("SMITHC1 JOHNC1    PO: NOFORM");

            creditMemoAdd.APAccountRef.FullName.SetValue("Accounts Payable");


            DataTable dt = GetVendorListFromQB();
            creditMemoAdd.VendorRef.ListID.SetValue(dt.Rows[0]["ListID"].ToString());

            IExpenseLineAdd line = creditMemoAdd.ExpenseLineAddList.Append();
            //line.AccountRef.FullName.SetValue("COGS - Accessories - Batteries");
            line.AccountRef.FullName.SetValue("Automobile");
            line.Amount.SetValue(100.00);
            line.Memo.SetValue("Hi");
            line.ClassRef.FullName.SetValue("New Construction");
            IORItemLineAdd lstItems = creditMemoAdd.ORItemLineAddList.Append();
            lstItems.ItemLineAdd.Amount.SetValue(10);
            lstItems.ItemLineAdd.ClassRef.FullName.SetValue("New Construction");
            lstItems.ItemLineAdd.ItemRef.FullName.SetValue("Cabinets");

            //IMsgSetResponse iMsgResponse;

            //iMsgResponse = SessionManager.DoRequests(ImsgReq);
            IResponse response = SessionManager.DoRequests(ImsgReq).ResponseList.GetAt(0);
            new Operations().CloseQBSession(SessionManager);

            ImsgReq.Attributes.OnError = ENRqOnError.roeContinue;
            var ss = response.Detail;

            MessageBox.Show(response.StatusCode + response.StatusMessage);

            return true;

        }

        public bool AddPayment(IBillPaymentCheckAdd Billpayment)
        {
            QBSessionManager SessionManager = new QBSessionManager();
            SessionManager = new Operations().OpenQBConnection();
            IMsgSetRequest ImsgReq = new Operations().StartQBSession(SessionManager);

            Billpayment = ImsgReq.AppendBillPaymentCheckAddRq();

            DataTable dt = GetVendorListFromQB();

            Billpayment.PayeeEntityRef.ListID.SetValue(dt.Rows[0]["ListID"].ToString());
            Billpayment.APAccountRef.FullName.SetValue("Automobile");
            Billpayment.BankAccountRef.FullName.SetValue("Checking");
            Billpayment.ORCheckPrint.IsToBePrinted.SetValue(true);
            Billpayment.TxnDate.SetValue(DateTime.Now);
            Billpayment.Memo.SetValue("");
            IAppliedToTxnAdd list = Billpayment.AppliedToTxnAddList.Append();
            list.PaymentAmount.SetValue(5010);
            list.DiscountAmount.SetValue(0);

            return true;

        }

        //public bool AddPaymentRefund(IRefundAppliedToTxnAdd refund)
        //{
        //    QBSessionManager SessionManager = new QBSessionManager();
        //    SessionManager = new Operations().OpenQBConnection();
        //    IMsgSetRequest ImsgReq = new Operations().StartQBSession(SessionManager);

        //    //refund = ImsgReq.();

        //    DataTable dt = GetVendorListFromQB();

        //    Billpayment.PayeeEntityRef.ListID.SetValue(dt.Rows[0]["ListID"].ToString());
        //    Billpayment.APAccountRef.FullName.SetValue("Automobile");
        //    Billpayment.BankAccountRef.FullName.SetValue("Checking");
        //    Billpayment.ORCheckPrint.IsToBePrinted.SetValue(true);
        //    Billpayment.TxnDate.SetValue(DateTime.Now);
        //    Billpayment.Memo.SetValue("");
        //    IAppliedToTxnAdd list = Billpayment.AppliedToTxnAddList.Append();
        //    list.PaymentAmount.SetValue(10);
        //    list.DiscountAmount.SetValue(0);


        //    return true;

        //}

        public void DoBillPaymentCheckAdd()
        {
            bool sessionBegun = false;
            bool connectionOpen = false;
            QBSessionManager SessionManager = null;

            try
            {
                //Create the session Manager object
                SessionManager = new QBSessionManager();
                SessionManager = new Operations().OpenQBConnection();
                IMsgSetRequest requestMsgSet = new Operations().StartQBSession(SessionManager);
                requestMsgSet.Attributes.OnError = ENRqOnError.roeContinue;

                BuildBillPaymentCheckAddRq(requestMsgSet);

                //Send the request and get the response from QuickBooks
                IMsgSetResponse responseMsgSet = SessionManager.DoRequests(requestMsgSet);

                //End the session and close the connection to QuickBooks
                SessionManager.EndSession();
                sessionBegun = false;
                SessionManager.CloseConnection();
                connectionOpen = false;

                WalkBillPaymentCheckAddRs(responseMsgSet);

            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message, "Error");
                if (sessionBegun)
                {
                    SessionManager.EndSession();
                }
                if (connectionOpen)
                {
                    SessionManager.CloseConnection();
                }
            }
        }

        void BuildBillPaymentCheckAddRq(IMsgSetRequest requestMsgSet)
        {
            IBillPaymentCheckAdd BillPaymentCheckAddRq = requestMsgSet.AppendBillPaymentCheckAddRq();
            //Set attributes
            //Set field value for defMacro
            BillPaymentCheckAddRq.defMacro.SetValue("IQBStringType");
            DataTable dt = GetVendorListFromQB();


            //IRefundAppliedToTxnAdd aa;
            

            //Set field value for ListID
            BillPaymentCheckAddRq.PayeeEntityRef.ListID.SetValue(dt.Rows[0]["ListID"].ToString());
            //Set field value for FullName
            BillPaymentCheckAddRq.PayeeEntityRef.FullName.SetValue("1Sai");
            //Set field value for ListID
            //BillPaymentCheckAddRq.APAccountRef.ListID.SetValue("200000-1011023419");
            ////Set field value for FullName
            BillPaymentCheckAddRq.APAccountRef.FullName.SetValue("Accounts Payable");
            //Set field value for TxnDate
            BillPaymentCheckAddRq.TxnDate.SetValue(DateTime.Now);
            //Set field value for ListID
            //BillPaymentCheckAddRq.BankAccountRef.ListID.SetValue("200000-1011023419");
            ////Set field value for FullName
            BillPaymentCheckAddRq.BankAccountRef.FullName.SetValue("Checking");
            string ORCheckPrintElementType64 = "IsToBePrinted";
            if (ORCheckPrintElementType64 == "IsToBePrinted")
            {
                //Set field value for IsToBePrinted
                BillPaymentCheckAddRq.ORCheckPrint.IsToBePrinted.SetValue(true);
            }
            if (ORCheckPrintElementType64 == "RefNumber")
            {
                //Set field value for RefNumber
                BillPaymentCheckAddRq.ORCheckPrint.RefNumber.SetValue("ab");
            }
            //Set field value for Memo
            BillPaymentCheckAddRq.Memo.SetValue("ab");
            //Set field value for ExchangeRate
            //BillPaymentCheckAddRq.ExchangeRate.SetValue(20.02F);
            //Set field value for ExternalGUID
            //BillPaymentCheckAddRq.ExternalGUID.SetValue(Guid.NewGuid().ToString());
            IAppliedToTxnAdd AppliedToTxnAdd65 = BillPaymentCheckAddRq.AppliedToTxnAddList.Append();
            //Set field value for TxnID
            AppliedToTxnAdd65.TxnID.SetValue("1AD7D-1513329942");
            //Set attributes
            //Set field value for useMacro
            //AppliedToTxnAdd65.useMacro.SetValue("IQBStringType");
            //Set field value for PaymentAmount
            AppliedToTxnAdd65.PaymentAmount.SetValue(105.01);
            ////////////ISetCredit SetCredit66 = AppliedToTxnAdd65.SetCreditList.Append();
            //////////////Set field value for CreditTxnID
            ////////////SetCredit66.CreditTxnID.SetValue("200000-1011023419");
            //////////////Set attributes
            //////////////Set field value for useMacro
            //////////////SetCredit66.useMacro.SetValue("IQBStringType");
            //////////////Set field value for AppliedAmount
            ////////////SetCredit66.AppliedAmount.SetValue(10.01);
            //////////////Set field value for Override
            ////////////SetCredit66.Override.SetValue(true);
            //////////////Set field value for DiscountAmount
            ////////////AppliedToTxnAdd65.DiscountAmount.SetValue(10.01);
            //////////////Set field value for ListID
            ////////////AppliedToTxnAdd65.DiscountAccountRef.ListID.SetValue("200000-1011023419");
            //////////////Set field value for FullName
            ////////////AppliedToTxnAdd65.DiscountAccountRef.FullName.SetValue("ab");
            //////////////Set field value for ListID
            ////////////AppliedToTxnAdd65.DiscountClassRef.ListID.SetValue("200000-1011023419");
            //////////////Set field value for FullName
            ////////////AppliedToTxnAdd65.DiscountClassRef.FullName.SetValue("ab");
            //Set field value for IncludeRetElementList
            //May create more than one of these if needed
            BillPaymentCheckAddRq.IncludeRetElementList.Add("ab");
        }

        void WalkBillPaymentCheckAddRs(IMsgSetResponse responseMsgSet)
        {
            if (responseMsgSet == null) return;

            IResponseList responseList = responseMsgSet.ResponseList;
            if (responseList == null) return;

            //if we sent only one request, there is only one response, we'll walk the list for this sample
            for (int i = 0; i < responseList.Count; i++)
            {
                IResponse response = responseList.GetAt(i);
                //check the status code of the response, 0=ok, >0 is warning
                if (response.StatusCode >= 0)
                {
                    //the request-specific response is in the details, make sure we have some
                    if (response.Detail != null)
                    {
                        //make sure the response is the type we're expecting
                        ENResponseType responseType = (ENResponseType)response.Type.GetValue();
                        if (responseType == ENResponseType.rtBillPaymentCheckAddRs)
                        {
                            //upcast to more specific type here, this is safe because we checked with response.Type check above
                            IBillPaymentCheckRet BillPaymentCheckRet = (IBillPaymentCheckRet)response.Detail;
                            WalkBillPaymentCheckRet(BillPaymentCheckRet);
                        }
                    }
                }
            }
        }

        void WalkBillPaymentCheckRet(IBillPaymentCheckRet BillPaymentCheckRet)
        {
            if (BillPaymentCheckRet == null) return;

            //Go through all the elements of IBillPaymentCheckRet
            //Get value of TxnID
            if (BillPaymentCheckRet.TxnID != null)
            {
                string TxnID67 = (string)BillPaymentCheckRet.TxnID.GetValue();
            }
            //Get value of TimeCreated
            if (BillPaymentCheckRet.TimeCreated != null)
            {
                DateTime TimeCreated68 = (DateTime)BillPaymentCheckRet.TimeCreated.GetValue();
            }
            //Get value of TimeModified
            if (BillPaymentCheckRet.TimeModified != null)
            {
                DateTime TimeModified69 = (DateTime)BillPaymentCheckRet.TimeModified.GetValue();
            }
            //Get value of EditSequence
            if (BillPaymentCheckRet.EditSequence != null)
            {
                string EditSequence70 = (string)BillPaymentCheckRet.EditSequence.GetValue();
            }
            //Get value of TxnNumber
            if (BillPaymentCheckRet.TxnNumber != null)
            {
                int TxnNumber71 = (int)BillPaymentCheckRet.TxnNumber.GetValue();
            }
            if (BillPaymentCheckRet.PayeeEntityRef != null)
            {
                //Get value of ListID
                if (BillPaymentCheckRet.PayeeEntityRef.ListID != null)
                {
                    string ListID72 = (string)BillPaymentCheckRet.PayeeEntityRef.ListID.GetValue();
                }
                //Get value of FullName
                if (BillPaymentCheckRet.PayeeEntityRef.FullName != null)
                {
                    string FullName73 = (string)BillPaymentCheckRet.PayeeEntityRef.FullName.GetValue();
                }
            }
            if (BillPaymentCheckRet.APAccountRef != null)
            {
                //Get value of ListID
                if (BillPaymentCheckRet.APAccountRef.ListID != null)
                {
                    string ListID74 = (string)BillPaymentCheckRet.APAccountRef.ListID.GetValue();
                }
                //Get value of FullName
                if (BillPaymentCheckRet.APAccountRef.FullName != null)
                {
                    string FullName75 = (string)BillPaymentCheckRet.APAccountRef.FullName.GetValue();
                }
            }
            //Get value of TxnDate
            if (BillPaymentCheckRet.TxnDate != null)
            {
                DateTime TxnDate76 = (DateTime)BillPaymentCheckRet.TxnDate.GetValue();
            }
            if (BillPaymentCheckRet.BankAccountRef != null)
            {
                //Get value of ListID
                if (BillPaymentCheckRet.BankAccountRef.ListID != null)
                {
                    string ListID77 = (string)BillPaymentCheckRet.BankAccountRef.ListID.GetValue();
                }
                //Get value of FullName
                if (BillPaymentCheckRet.BankAccountRef.FullName != null)
                {
                    string FullName78 = (string)BillPaymentCheckRet.BankAccountRef.FullName.GetValue();
                }
            }
            //Get value of Amount
            if (BillPaymentCheckRet.Amount != null)
            {
                double Amount79 = (double)BillPaymentCheckRet.Amount.GetValue();
            }
            if (BillPaymentCheckRet.CurrencyRef != null)
            {
                //Get value of ListID
                if (BillPaymentCheckRet.CurrencyRef.ListID != null)
                {
                    string ListID80 = (string)BillPaymentCheckRet.CurrencyRef.ListID.GetValue();
                }
                //Get value of FullName
                if (BillPaymentCheckRet.CurrencyRef.FullName != null)
                {
                    string FullName81 = (string)BillPaymentCheckRet.CurrencyRef.FullName.GetValue();
                }
            }
            //Get value of ExchangeRate
            if (BillPaymentCheckRet.ExchangeRate != null)
            {
                //IQBFloatType ExchangeRate82 = (IQBFloatType)BillPaymentCheckRet.ExchangeRate.GetValue();
            }
            //Get value of AmountInHomeCurrency
            if (BillPaymentCheckRet.AmountInHomeCurrency != null)
            {
                double AmountInHomeCurrency83 = (double)BillPaymentCheckRet.AmountInHomeCurrency.GetValue();
            }
            //Get value of RefNumber
            if (BillPaymentCheckRet.RefNumber != null)
            {
                string RefNumber84 = (string)BillPaymentCheckRet.RefNumber.GetValue();
            }
            //Get value of Memo
            if (BillPaymentCheckRet.Memo != null)
            {
                string Memo85 = (string)BillPaymentCheckRet.Memo.GetValue();
            }
            if (BillPaymentCheckRet.Address != null)
            {
                //Get value of Addr1
                if (BillPaymentCheckRet.Address.Addr1 != null)
                {
                    string Addr186 = (string)BillPaymentCheckRet.Address.Addr1.GetValue();
                }
                //Get value of Addr2
                if (BillPaymentCheckRet.Address.Addr2 != null)
                {
                    string Addr287 = (string)BillPaymentCheckRet.Address.Addr2.GetValue();
                }
                //Get value of Addr3
                if (BillPaymentCheckRet.Address.Addr3 != null)
                {
                    string Addr388 = (string)BillPaymentCheckRet.Address.Addr3.GetValue();
                }
                //Get value of Addr4
                if (BillPaymentCheckRet.Address.Addr4 != null)
                {
                    string Addr489 = (string)BillPaymentCheckRet.Address.Addr4.GetValue();
                }
                //Get value of Addr5
                if (BillPaymentCheckRet.Address.Addr5 != null)
                {
                    string Addr590 = (string)BillPaymentCheckRet.Address.Addr5.GetValue();
                }
                //Get value of City
                if (BillPaymentCheckRet.Address.City != null)
                {
                    string City91 = (string)BillPaymentCheckRet.Address.City.GetValue();
                }
                //Get value of State
                if (BillPaymentCheckRet.Address.State != null)
                {
                    string State92 = (string)BillPaymentCheckRet.Address.State.GetValue();
                }
                //Get value of PostalCode
                if (BillPaymentCheckRet.Address.PostalCode != null)
                {
                    string PostalCode93 = (string)BillPaymentCheckRet.Address.PostalCode.GetValue();
                }
                //Get value of Country
                if (BillPaymentCheckRet.Address.Country != null)
                {
                    string Country94 = (string)BillPaymentCheckRet.Address.Country.GetValue();
                }
                //Get value of Note
                if (BillPaymentCheckRet.Address.Note != null)
                {
                    string Note95 = (string)BillPaymentCheckRet.Address.Note.GetValue();
                }
            }
            if (BillPaymentCheckRet.AddressBlock != null)
            {
                //Get value of Addr1
                if (BillPaymentCheckRet.AddressBlock.Addr1 != null)
                {
                    string Addr196 = (string)BillPaymentCheckRet.AddressBlock.Addr1.GetValue();
                }
                //Get value of Addr2
                if (BillPaymentCheckRet.AddressBlock.Addr2 != null)
                {
                    string Addr297 = (string)BillPaymentCheckRet.AddressBlock.Addr2.GetValue();
                }
                //Get value of Addr3
                if (BillPaymentCheckRet.AddressBlock.Addr3 != null)
                {
                    string Addr398 = (string)BillPaymentCheckRet.AddressBlock.Addr3.GetValue();
                }
                //Get value of Addr4
                if (BillPaymentCheckRet.AddressBlock.Addr4 != null)
                {
                    string Addr499 = (string)BillPaymentCheckRet.AddressBlock.Addr4.GetValue();
                }
                //Get value of Addr5
                if (BillPaymentCheckRet.AddressBlock.Addr5 != null)
                {
                    string Addr5100 = (string)BillPaymentCheckRet.AddressBlock.Addr5.GetValue();
                }
            }
            //Get value of IsToBePrinted
            if (BillPaymentCheckRet.IsToBePrinted != null)
            {
                bool IsToBePrinted101 = (bool)BillPaymentCheckRet.IsToBePrinted.GetValue();
            }
            //Get value of ExternalGUID
            if (BillPaymentCheckRet.ExternalGUID != null)
            {
                string ExternalGUID102 = (string)BillPaymentCheckRet.ExternalGUID.GetValue();
            }
            if (BillPaymentCheckRet.AppliedToTxnRetList != null)
            {
                for (int i103 = 0; i103 < BillPaymentCheckRet.AppliedToTxnRetList.Count; i103++)
                {
                    IAppliedToTxnRet AppliedToTxnRet = BillPaymentCheckRet.AppliedToTxnRetList.GetAt(i103);
                    //Get value of TxnID
                    string TxnID104 = (string)AppliedToTxnRet.TxnID.GetValue();
                    //Get value of TxnType
                    ENTxnType TxnType105 = (ENTxnType)AppliedToTxnRet.TxnType.GetValue();
                    //Get value of TxnDate
                    if (AppliedToTxnRet.TxnDate != null)
                    {
                        DateTime TxnDate106 = (DateTime)AppliedToTxnRet.TxnDate.GetValue();
                    }
                    //Get value of RefNumber
                    if (AppliedToTxnRet.RefNumber != null)
                    {
                        string RefNumber107 = (string)AppliedToTxnRet.RefNumber.GetValue();
                    }
                    //Get value of BalanceRemaining
                    if (AppliedToTxnRet.BalanceRemaining != null)
                    {
                        double BalanceRemaining108 = (double)AppliedToTxnRet.BalanceRemaining.GetValue();
                    }
                    //Get value of Amount
                    if (AppliedToTxnRet.Amount != null)
                    {
                        double Amount109 = (double)AppliedToTxnRet.Amount.GetValue();
                    }
                    //Get value of DiscountAmount
                    if (AppliedToTxnRet.DiscountAmount != null)
                    {
                        double DiscountAmount110 = (double)AppliedToTxnRet.DiscountAmount.GetValue();
                    }
                    if (AppliedToTxnRet.DiscountAccountRef != null)
                    {
                        //Get value of ListID
                        if (AppliedToTxnRet.DiscountAccountRef.ListID != null)
                        {
                            string ListID111 = (string)AppliedToTxnRet.DiscountAccountRef.ListID.GetValue();
                        }
                        //Get value of FullName
                        if (AppliedToTxnRet.DiscountAccountRef.FullName != null)
                        {
                            string FullName112 = (string)AppliedToTxnRet.DiscountAccountRef.FullName.GetValue();
                        }
                    }
                    if (AppliedToTxnRet.DiscountClassRef != null)
                    {
                        //Get value of ListID
                        if (AppliedToTxnRet.DiscountClassRef.ListID != null)
                        {
                            string ListID113 = (string)AppliedToTxnRet.DiscountClassRef.ListID.GetValue();
                        }
                        //Get value of FullName
                        if (AppliedToTxnRet.DiscountClassRef.FullName != null)
                        {
                            string FullName114 = (string)AppliedToTxnRet.DiscountClassRef.FullName.GetValue();
                        }
                    }
                    if (AppliedToTxnRet.LinkedTxnList != null)
                    {
                        for (int i115 = 0; i115 < AppliedToTxnRet.LinkedTxnList.Count; i115++)
                        {
                            ILinkedTxn LinkedTxn = AppliedToTxnRet.LinkedTxnList.GetAt(i115);
                            //Get value of TxnID
                            string TxnID116 = (string)LinkedTxn.TxnID.GetValue();
                            //Get value of TxnType
                            ENTxnType TxnType117 = (ENTxnType)LinkedTxn.TxnType.GetValue();
                            //Get value of TxnDate
                            DateTime TxnDate118 = (DateTime)LinkedTxn.TxnDate.GetValue();
                            //Get value of RefNumber
                            if (LinkedTxn.RefNumber != null)
                            {
                                string RefNumber119 = (string)LinkedTxn.RefNumber.GetValue();
                            }
                            //Get value of LinkType
                            if (LinkedTxn.LinkType != null)
                            {
                                ENLinkType LinkType120 = (ENLinkType)LinkedTxn.LinkType.GetValue();
                            }
                            //Get value of Amount
                            double Amount121 = (double)LinkedTxn.Amount.GetValue();
                        }
                    }
                }
            }
            if (BillPaymentCheckRet.DataExtRetList != null)
            {
                for (int i122 = 0; i122 < BillPaymentCheckRet.DataExtRetList.Count; i122++)
                {
                    IDataExtRet DataExtRet = BillPaymentCheckRet.DataExtRetList.GetAt(i122);
                    //Get value of OwnerID
                    if (DataExtRet.OwnerID != null)
                    {
                        string OwnerID123 = (string)DataExtRet.OwnerID.GetValue();
                    }
                    //Get value of DataExtName
                    string DataExtName124 = (string)DataExtRet.DataExtName.GetValue();
                    //Get value of DataExtType
                    ENDataExtType DataExtType125 = (ENDataExtType)DataExtRet.DataExtType.GetValue();
                    //Get value of DataExtValue
                    string DataExtValue126 = (string)DataExtRet.DataExtValue.GetValue();
                }
            }
        }
    }
}
