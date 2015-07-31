using Interop.QBFC13;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Forms;

namespace SimpleQbCMS.Authorisations
{
    public class Operations
    {
        public Operations()
        {

        }

        public QBSessionManager OpenQBConnection()
        {
            try
            {
                QBSessionManager SessionManager = new QBSessionManager();
                SessionManager.OpenConnection("", "Amplifon Plugin");
                return SessionManager;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Open Connection" + ex.Message);
                return null;
            }
        }

        public IMsgSetRequest StartQBSession(QBSessionManager SessionManager)
        {
            try
            {
                SessionManager.BeginSession("", ENOpenMode.omDontCare);
                IMsgSetRequest req = SessionManager.CreateMsgSetRequest("US", 6, 0);
                req.Attributes.OnError = ENRqOnError.roeStop;
                return req;
            }
            catch (Exception ex)
            {
                MessageBox.Show(" StartQBSession " + ex.Message);
                return null;
            }
        }

        public void CloseQBSession(QBSessionManager SessionManager)
        {
            try
            {
                SessionManager.EndSession();
                SessionManager.CloseConnection();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Close QB Session" + ex.Message);
            }
        }

        public void CheckQuickBookOpen()
        {
            try
            {
                QBSessionManager SessionManager = OpenQBConnection();
                IMsgSetRequest requestMsgset = StartQBSession(SessionManager);
                CloseQBSession(SessionManager);
                if (requestMsgset == null)
                {
                    MessageBox.Show("You will need to open QuickBooks as a normal user for ProCharge to function properly.");
                    Environment.Exit(0);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("CheckQuickBookOpen" + ex.Message);
                Environment.Exit(0);
            }
        }
    }
}
