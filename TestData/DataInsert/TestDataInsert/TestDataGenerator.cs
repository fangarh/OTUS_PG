using System;
using System.ComponentModel;
using TestDataInsert.Objects;

namespace TestDataInsert
{
    public class TestDataGenerator
    {
        public List<ProjectPartitions> GetPartitions(int count, List<ProjectPartitionsTemplate> tmp, List<Contracts> contracts)
        {
            List<ProjectPartitions> result = new();
            Random r = new Random(DateTime.Now.Second);

            for (int i = 0; i < count; i++)
            {
                Contracts ct = contracts[r.Next(0, contracts.Count - 1)];

                result.AddRange(BuildTitulTreeForContract(tmp.Where(elm=>!elm.Deleted && elm.TypeId == r.Next()%2).ToList(), r.Next()%2, ct, null, "", 0));
            }

            return result;
        }

        public IEnumerable<Titul> GenerateTituls(int count)
        {
            var res = new List<Titul>();

            for (int i = 0; i < count; i++)
            {
                res.Add(new Titul{Id = i, Name = Path.GetRandomFileName()});
            }

            return res;
        }

        public IEnumerable<ProjectPartitionsTemplate> BuildTemplatePartitions()
        {
            var result = new List<ProjectPartitionsTemplate>();

            result.AddRange(BuildTemplatePartitions(1));
            result.AddRange(BuildTemplatePartitions(0));
            return result;
        }
        public IEnumerable<ProjectPartitionsTemplate> BuildTemplatePartitions(int type, int lvl = 0, Guid? parent = null, string num = "")
        {
            List<ProjectPartitionsTemplate> result = new();
            Random rnd = new Random(DateTime.Now.Second);

            if (lvl == 3) return result;

            for (int i = 0; i < rnd.Next(3, lvl == 0 ? 10 : 21) + 1; i++)
            {
                ProjectPartitionsTemplate p = new ProjectPartitionsTemplate()
                {
                    
                    Deleted = false,
                    Name = Path.GetRandomFileName(),
                    ParentRowId = parent,
                    ElementNumber = num + "." + i,
                    RowId = Guid.NewGuid(),
                    ElementCode = "121",
                    TypeId = type
                    
                };
                result.Add(p);
                result.AddRange(BuildTemplatePartitions(type, lvl +1, p.RowId, p.ElementNumber));

            }

            return result;
        }

        public IEnumerable<ProjectPartitions> BuildTitulTreeForContract(List<ProjectPartitionsTemplate> templates, int type, Contracts ct, Guid? parent, string num, int lvl)
        {
            List<ProjectPartitions> result = new();
            Random rnd = new Random(DateTime.Now.Second);
            

            if (lvl == 4) return result;

            for (int i = 0; i < rnd.Next(3, lvl == 0 ? 10 : 21) + 1; i++)
            {
                var t = templates[rnd.Next(templates.Count-1)];

                ProjectPartitions p = new ProjectPartitions
                {
                    ContractId = ct.Id, Deleted = false, Name = t.Name, ParentRowId = parent, PartitionNumber = num + "." + i,
                    RowId = Guid.NewGuid(), TitulId = ct.TitulId, Stage = Path.GetRandomFileName(), Template = t.RowId
                };
                result.Add(p);
                result.AddRange(BuildTitulTreeForContract(templates, type, ct, p.RowId, p.PartitionNumber, lvl + 1));
                
            }

            return result;
        }

        public List<Contracts> Generate(int count, List<int> titulIds)
        {
            Random r = new Random(DateTime.Now.Second);
            var res = new List<Contracts>();

            for (int i = 0; i < count; i++)
            {
                int ud = titulIds[r.Next(0, titulIds.Count - 1)];
                res.Add(new Contracts
                {
                    Id = Guid.NewGuid(), LegalNumber = Path.GetRandomFileName(), Name = Path.GetRandomFileName(), Number = $"{i}_00_{ud}_{DateTime.Now.Year - 2000}", TitulId = ud
                });
            }

            return res;
        }
    }
}
