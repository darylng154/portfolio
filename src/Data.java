public class Data
{
    public int opcode;
    public int funct;
    public char format;
    public String type;

    //public int rs1;
    //public int rs2;
    //public int rd;
    //public int shamt;
    //public int lineNum;

    public Data(int opcode, int funct, char format)
    {
        //this.rs1 = this.rs2 = this.rd = this.shamt = 0;
        this.opcode = opcode;
        this.funct = funct;
        this.format = format;

        this.type = "";

        //shift
        if(this.opcode == 0 && this.funct == 0 && this.format == 'r')
        {
            this.type = "shift";
        }

        //load
        if(this.opcode == 0x23 && this.funct == 0 && this.format == 'i')
        {
            this.type = "load";
        }

        //store
        if(this.opcode == 0x2b && this.funct == 0 && this.format == 'i')
        {
            this.type = "store";
        }

        //jr
        if(this.opcode == 0x0 && this.funct == 0x8 && this.format == 'r')
        {
            this.type = "jr";
        }

        //branch
        if((this.opcode == 0x4 || this.opcode == 0x5) && this.funct == 0x0 && this.format == 'i')
        {
            this.type = "branch";
        }
    }

    public void printData()
    {
        System.out.format("format: %1s; type: %6s opcode: %2s; funct: %2s \n", this.format, this.type, this.opcode, this.funct);
        //System.out.format("format: %1s; opcode: %2s; funct: %2s \n", this.format, this.opcode, this.funct);
    }
}
