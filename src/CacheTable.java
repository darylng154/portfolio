import java.util.Arrays;

public class CacheTable
{
    boolean valid[];
    int tag[];
    int line[];

    public CacheTable(int indices)
    {
        this.valid = new boolean[indices];
        Arrays.fill(this.valid, false);
        this.tag = new int[indices];
        Arrays.fill(this.tag, -1);
        this.line = new int[indices];
        Arrays.fill(this.line, -1);
    }

    public void printCacheTableVar()
    {
        for (int i = 0; i < this.valid.length; i++)
        {
            System.out.format("%-4d \t", i);
        }

        System.out.println("valid length = " + this.valid.length);
        for (boolean b : this.valid)
        {
            System.out.format("%-4b \t", b);
        }

        System.out.println("\ntag length   = " + this.tag.length);
        for (int i : this.tag)
        {
            System.out.format("%-4d \t", i);
        }

        System.out.println("\nline length   = " + this.line.length);
        for (int i : this.line)
        {
            System.out.format("%-4d \t", i);
        }

        System.out.println("");
    }

    public boolean isEmpty(int index)
    {
        if(this.valid[index] == false)
            return true;

        return (this.tag[index] == -1);
    }

}
