using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TestDataInsert.Objects;
using UtilsForDevelopCore.DataBase;

namespace TestDataInsert
{
    public class TestDataPublisher
    {
        private AccessDb _db;

        public TestDataPublisher(string connection)
        {
            _db = new AccessDb(DbServerEngine.PG, connection);
        }

        public void PublishTemplate(List<ProjectPartitionsTemplate> tmp)
        {
            _db.WriteDb("DELETE FROM public.project_partitions;");
            _db.WriteDb("DELETE FROM public.project_partitions_tree;");
            foreach (ProjectPartitionsTemplate template in tmp)
            {
                string query = "insert into public.project_partitions_tree(id, parent_row_id, name, type_id, element_number, element_code, deleted) " +
                               " values (@id, @pid, @name, @type, @num, @code, @d);";

                _db.WriteDb(query, new Hashtable
                {
                    {"@id", template.RowId},
                    {"pid", template.ParentRowId},
                    {"name", template.Name},
                    {"type", template.TypeId},
                    {"num", template.ElementNumber},
                    {"code", template.ElementCode},
                    {"d", template.Deleted},
                });
            }
        }

        public void PublishTitul(List<Titul> tituls)
        {
            _db.WriteDb("DELETE FROM public.contracts;");
            _db.WriteDb("DELETE FROM public.titul;");
            
            foreach (Titul titul in tituls)
            {
                string query = "insert into public.titul(id, name) values (@id, @n);";
                _db.WriteDb(query, new Hashtable()
                {
                    {"id", titul.Id},
                    {"n", titul.Name}
                });
            }
        }

        public void PublishTestTree(List<ProjectPartitions> data)
        {
            _db.WriteDb("DELETE FROM public.project_partitions;");
            int i = 0;
            foreach (ProjectPartitions prt in data)
            {
                string query = "insert into public.project_partitions(row_id, parent_row_id, template_partition_id, name, partition_number, stage, contract_id, titul_id) " +
                               " values (@id, @pid, @tmp, @name, @pnum, @stage, @contract, @titul);";

                _db.WriteDb(query, new Hashtable
                {
                    {"id", prt.RowId},
                    {"pid", prt.ParentRowId},
                    {"tmp", prt.Template},
                    {"name", prt.Name},
                    {"pnum", prt.PartitionNumber},
                    {"stage", prt.Stage},
                    {"contract", prt.ContractId},
                    {"titul", prt.TitulId}
                });
                i++;
                if(i % 20 ==10)
                    Console.WriteLine(i);
                if (i > 111000)
                    ;
            }
        }

        public void PublishContracts(List<Contracts> contracts)
        {
            _db.WriteDb("DELETE FROM public.contracts;");

            foreach (Contracts contract in contracts)
            {
                string query = "insert into public.contracts(id, titul_id, number, legal_number, name) " +
                               " values (@id, @t, @n, @ln, @name);";

                _db.WriteDb(query, new Hashtable
                {
                    {"id", contract.Id},
                    {"t", contract.TitulId},
                    {"n", contract.Number},
                    {"ln", contract.LegalNumber},
                    {"name", contract.Name},
                });
            }
        }
    }
}
