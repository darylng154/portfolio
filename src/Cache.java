public class Cache
{
    int cachesize;      //cache size = 2KB - 4KB (max array size)
    int assoc;          //associativity = 1 - 4 ways (max array size)
    int blksize;        //# of words in data
    int indices;       //elements in cache = 5 - 10 elements

    CacheTable table[];

    int hit;
    int access;

    int indexbits;
    int blkbits;
    int bytebits;

    public Cache(int cachesize, int assoc, int blksize)
    {
        this.cachesize = cachesize;
        this.assoc = assoc;
        this.blksize = blksize;
        this.indices = (cachesize/(blksize*4)/this.assoc);            //4Bytes = 1Word

        this.table = new CacheTable[assoc];
        for (int i = 0; i < this.table.length; i++)
        {
            table[i] = new CacheTable(this.indices);
        }
//        Arrays.fill(table, new CacheTable(this.indices));     //all 2 to 4-Ways Table will hold the same Object
//        this.table[0].tag[0] = 100;
//        this.table[0].line[0] = 100;

        this.hit = 0;
        this.access = 0;

        this.indexbits = log2(this.indices);   //4Bytes = 1Word
        this.blkbits = log2(blksize);
        this.bytebits = 2;
    }

    public void printCacheVar()
    {
        System.out.println("cachesize = " + this.cachesize);
        System.out.println("assoc = " + this.assoc);
        System.out.println("blksize = " + this.blksize);
        System.out.println("indices = " + this.indices);
        System.out.println("");

        System.out.println("table length = " + this.table.length);
        printCacheTables();

        System.out.println("hit = " + this.hit);
        System.out.println("access = " + this.access);
        System.out.format("hit rate = %.2f\n\n", ((float)hit/access));

        System.out.println("tagbits = " + (32-this.indexbits-this.blkbits-this.bytebits));
        System.out.println("indexbits = " + this.indexbits);
        System.out.println("blkbits = " + this.blkbits);
        System.out.println("bytebits = " + this.bytebits);

        System.out.println("-------------------------------------");
    }

    public void printCache()
    {
        System.out.format("Cache size: %-4dB \t Associativity: %-2d\t Block size: %-2d\n", this.cachesize, this.assoc, this.blksize);
        System.out.format("Hits: %-2d \t Hit Rate: %.2f", this.hit, ((float)this.hit/this.access*100));
        System.out.println("%\n---------------------------");
    }


    public void printCacheTables()
    {
        int i = 0;
        for (CacheTable element:this.table)
        {
            System.out.println("CacheTable #" + i++);
            element.printCacheTableVar();
        }
    }

    public static int log2(int num)     //index bits
    {
        int indices = 0;

        if(num == 3)            //would be able to round up
            return 2;           // if we could shift floats or divide (slow)

        while(num > 1)
        {
            num = num >>> 1;    //num = num / 2;
            indices++;
        }

        return indices;
    }

    public boolean isInCacheTable(int[] addrResults)        //broken
    {
        for (int n = 0; n < this.table.length; n++)        //for each Cache Table in the Cache (== Associativity | #-ways)
        {
            CacheTable curTable = this.table[n];
            //check if Hit | Miss
            if (curTable.valid[addrResults[lab6.INDEX]] && (addrResults[lab6.TAG] == curTable.tag[addrResults[lab6.INDEX]]))
            //if [Cache line == valid && (comptued tag == tag in CacheTable)] => Hit; else => Miss
            {
                return true;
            }
        }

        return false;
    }

    public CacheTable getEmptyCacheTable(int index)
    {
        CacheTable result = new CacheTable(this.indices);

        for (int i = 0; i < this.table.length; i++)
        {
            if(this.table[i].isEmpty(index))
            {
                result = this.table[i];
                return result;
            }
        }

        //getLRU
        result = this.table[0];
        for (int i = 0; i < this.table.length; i++)
        {
            if(this.table[i].line[index] < result.line[index])
            {
                result = this.table[i];
            }
        }

        return result;
    }
}
