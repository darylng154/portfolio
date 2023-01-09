public class Pipeline
{
    public String instr;
    public int pc;    //maybe easier than calculating PC-3

    public Pipeline()
    {
        this.instr = "empty";
        this.pc = 0;
    }

    public Pipeline(String instr, int pc)
    {
        this.instr = instr;
        this.pc = pc;
    }

    public boolean isEmpty()
    {
        return (this.instr.equals("empty") || this.instr.equals("stall") || this.instr.equals("squash") || this.instr.equals(null));
    }

    public void remove()
    {
        this.instr = "empty";
        this.pc = 0;
    }

    public void squash()
    {
        this.instr = "squash";
    }

    public boolean isBranch()
    {
        boolean is = false;

        if(this.instr.equals("bne") || this.instr.equals("beq"))
            return true;

        return is;
    }
}