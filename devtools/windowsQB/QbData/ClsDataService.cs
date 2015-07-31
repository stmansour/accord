using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SimpleQbCMS.Models
{
    public class ClsDataService
    {
        public List<ClsCustomer> getCustomer()
        {
            return new List<ClsCustomer>() 
            {
                new ClsCustomer(){Name="Adam",Address="Australia"},
                new ClsCustomer(){Name="Shyam",Address="Thane"},
                new ClsCustomer(){Name="Sachin",Address="G"},
                new ClsCustomer(){Name="Sharad",Address="Australia"},

            };
        }
    }
}
