using Interop.QBFC13;
using SimpleQbCMS.Authorisations;
using SimpleQbCMS.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SimpleQbCMS.BusinessLogic
{
    public class CustomerLogic
    {
        public bool AddCutomer(ClsCustomer customer)
        {
            try
            {
                QBSessionManager SessionManager = new QBSessionManager();
                SessionManager = new Operations().OpenQBConnection();
                IMsgSetRequest ImsgReq = new Operations().StartQBSession(SessionManager);

                ICustomerAdd Customeradd = ImsgReq.AppendCustomerAddRq();

                Customeradd.Name.SetValue(customer.Name);
                
                Customeradd.BillAddress.Addr1.SetValue(customer.Address);
                Customeradd.BillAddress.Addr2.SetValue(customer.Address);
                Customeradd.BillAddress.Addr3.SetValue(customer.Address);
                Customeradd.BillAddress.Addr4.SetValue(customer.Address);
                Customeradd.BillAddress.Addr5.SetValue(customer.Address);


                MessageBox.Show("Customer Added with name" + customer.Name);

                IResponse response = SessionManager.DoRequests(ImsgReq).ResponseList.GetAt(0);
                new Operations().CloseQBSession(SessionManager);

                ImsgReq.Attributes.OnError = ENRqOnError.roeContinue;
                var ss = response.Detail;

                MessageBox.Show(response.StatusCode + response.StatusMessage);
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            return true;
        }
    }
}
