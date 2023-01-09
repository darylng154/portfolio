/*
Name:  Daryl Ng
Section:  07 | 08
Description:
    Cache Simulator: Models 7 different cache configs and prints: # of hits & hit rate & etc.
    Compile Options:    java lab6 file1 c v
         file1: assembly program file input
             c: print caches
             v: verbose

             ex: java lab6 mem_stream.1 - -

Comments:
    Only missing input data & it's calculations (not part of lab)
 */

import java.io.*;
import java.util.*;


public class lab6
{

    public static void printCachesVar(Cache caches[])
    {
        int i = 1;
        for (Cache element: caches)
        {
            System.out.println("Cache #" + i++);
            element.printCacheVar();
        }
    }

    public static void printCaches(Cache caches[])
    {
        for (int i = 0; i < caches.length; i++)
        {
            System.out.println("Cache #" + (i+1));
            caches[i].printCache();
        }
    }

    public static Scanner openFile(String[] args) throws FileNotFoundException
    {
        File inFile = new File(args[0]);    //args[0] == first argument after program name
        Scanner in = new Scanner(inFile);

        return in;
    }

    public static int srl1(int shiftAmt)     //shifts right once (<< 1) & +1
    {
        int result = 1;

        for(int i = 0; i < shiftAmt-1; i++)
        {
            result = result << 1;
            result++;
        }

        return result;
    }

    public static int[] addrCalc(String[] args, Cache cache, int addr)
    {
        int tag = 0;
        int index = 0;
        int blkoffset = 0;
        int byteoffset = 0;
        int mask = 0;

        byteoffset = (addr & 0x03);
        mask = srl1(cache.blkbits);                                             //if(blkbits & bytebits == 2)
        blkoffset = (addr >>> cache.bytebits) & mask;                           //blkoffset = (addr >>> 2) & 0x03;

        mask = srl1(cache.indexbits);
        index = (addr >>> (cache.bytebits + cache.blkbits)) & mask;             //index = (addr >>> 4) & 0x0FFF;

        tag = addr >>> (cache.indexbits + cache.bytebits + cache.blkbits);      //tag = addr >>> 16;

        int[] addrResults = new int[]{tag, index, blkoffset, byteoffset};       //32-bit address: [tag | index | blk offset | byte offset]
        return addrResults;
    }

    public static final int VARG = 1;
    public static final int FILE = 0;
    public static final int HEX = 16;
    public static final int READ = 714;

    //32-bit address: [tag | index | blk offset | byte offset]
    public static final int TAG = 0;
    public static final int INDEX = 1;

    public static void main(String[] args) throws FileNotFoundException
    {

        Cache caches[] = new Cache[]
        {
            new Cache(2048, 1, 1),      //2KB, direct mapped, 1-word blocks
            new Cache(2048, 1, 2),      //2KB, direct mapped, 2-word blocks
            new Cache(2048, 1, 4),      //2KB, direct mapped, 4-word blocks
            new Cache(2048, 2, 1),      //2KB, 2-way set associative, 1-word blocks
            new Cache(2048, 4, 1),      //2KB, 4-way set associative, 1-word blocks
            new Cache(2048, 4, 4),      //2KB, 4-way set associative, 4-word blocks
            new Cache(4096, 1, 1)       //4KB, direct mapped, 1-word blocks
        };

        Scanner inFile = openFile(args);
        int addr = 0;

        for(int line = 0; inFile.hasNextInt(); line++)
        {
            inFile.nextInt();
            addr = inFile.nextInt(HEX);

            int[] addrResults;      //32-bit address: [tag | index | blk offset | byte offset]

            for(int i = 0; i < caches.length; i++)              //for each Cache in caches[7] (7 different caches)
            {
                //int i = 3;
                Cache curCache = caches[i];

                addrResults = addrCalc(args, curCache, addr);
                curCache.access++;

                boolean hit = curCache.isInCacheTable(addrResults);

                if(hit)   //Hit
                {
                    curCache.hit++;

                    for (CacheTable table: curCache.table)
                    {
                        if(addrResults[TAG] == table.tag[addrResults[INDEX]])
                            table.line[addrResults[INDEX]] = line;
                    }
                }
                else                                       //Miss => update CacheTable
                {

                    CacheTable curTable = curCache.getEmptyCacheTable(addrResults[INDEX]);

                    curTable.valid[addrResults[INDEX]] = true;
                    curTable.tag[addrResults[INDEX]] = addrResults[TAG];
                    curTable.line[addrResults[INDEX]] = line;
                }
            }
        }

        //prompt
        printCaches(caches);
    }
}
