namespace TestDataInsert.Objects
{
    public class ProjectPartitions
    {
        public Guid RowId { get; set; }
        public int TitulId { get; set; }
        public Guid Template { get; set; }
        public Guid? ParentRowId { get; set; }
        public string Name { get; set; }
        public string PartitionNumber { get; set; }
        public string Stage { get; set; }
        public Guid ContractId { get; set; }
        public bool Deleted { get; set; }
    }
}
