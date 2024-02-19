using UtilsForDevelopCore.DataBase;
using UtilsForDevelopCore.Security;

namespace TestDataInsert
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello, World!");
            string key = "n2dbjzcCPIf1R7UPg7jV7Q==";
            string con = $"Server=172.17.18.51:5432;User Id=postgres;Password=\"{Crypto.Decrypt(key)}\";Database=uis";

            IAccessDb db = new AccessDb(DbServerEngine.PG, con);

            Random r = new Random(200);

            TestDataGenerator tg = new TestDataGenerator();
            var tituls = tg.GenerateTituls(180).ToList();
            var templates = tg.BuildTemplatePartitions().ToList();
            var contracts = tg.Generate(30, tituls.Select(e=>e.Id).ToList());
            var data = tg.GetPartitions(1800,templates, contracts);

            Console.WriteLine(data.Count);

            TestDataPublisher tp = new TestDataPublisher(con);
            tp.PublishTitul(tituls);
            tp.PublishTemplate(templates);
            tp.PublishContracts(contracts);
            tp.PublishTestTree(data);

            Console.WriteLine("Data filled!");
        }
    }
}