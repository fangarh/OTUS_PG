namespace TestDataInsert.Objects
{
    public class ProjectPartitionsTemplate
    {
        public Guid RowId { get; set; }
        
        public Guid? ParentRowId { get; set; }
        public string Name { get; set; }
        public int TypeId { get; set; }
        public string ElementNumber { get; set; }
        public string ElementCode{ get; set; }

        public bool Deleted { get; set; }
    }
}
