/*
Name:  Daryl Ng
Section:  07 | 08
Description:  
    Translates / Parses Assembly Program to Machine Code (Binary).
    Compile Options:    java lab2 file1 v m
        file1: assembly program input
        v: verbose
        m: map info
*/

import java.io.*;
import java.util.*;

public class lab2 //extends Format
{
    public static void printMap(HashMap<String, Integer> map)
    {
        map.forEach((key, value) ->
        {
            System.out.format("key %4s: - value: %2s \n", key, value);
        });
    }

    public static void printAssembly(List<String> assembly, String[] args)
    {
        if(args.length >= 2)
        {
            if(args[1].charAt(0) == 'v')
            {
                System.out.println("\n--- Assembly Code ---");

                for(int i = 0; i < assembly.size(); i++)
                    {   
                        System.out.format("%2d ", i);
                        System.out.println(assembly.get(i));
                    }
            }
        }
    }

    public static void printFMap(HashMap<String, Data> instrMap, String[] args)
    {
        if(args.length >= 3)
        {
            if(args[2].charAt(0) == 'm')
            {
                System.out.println("\n--- Instructions Map ---");
                instrMap.forEach((key, value) -> 
                {
                    System.out.format("key: %4s - ", key);
                    value.printData();
                });
            }
        }
    }

    public static void printIMap(HashMap<String, Integer> regMap, String[] args, Boolean reg)
    {
        if(args.length >= 3)
        {
            if(reg == true)
                System.out.println("\n--- Registers Map ---");
            else
                System.out.println("\n--- Labels Map ---");

            if(args[2].charAt(0) == 'm')
                printMap(regMap);
        }
    }

    public static void printArray(int[] array, int lineNum)
    {
        System.out.format("[%2d] ", lineNum);
        for(int i = 0; i < array.length; i++)
        {
            System.out.format("%3d ", array[i]);
        }
        System.out.println();
    }

    public static void printIntsList(List<int[]> dec, String[] args)
    {
        if(args.length >= 2)
        {
            if(args[1].charAt(0) == 'v')
            {
                System.out.println("\n--- Decimal Output Table ---");
                for(int i = 0; i < dec.size(); i++)
                {
                    int array[] = dec.get(i);

                    for(int element: array)
                    {
                        System.out.format("%3d ", element);
                    }
                    System.out.println();
                }
            }
        }
    }

    public static Scanner openFile(String[] args) throws FileNotFoundException
    {
        File inFile = new File(args[0]);    //args[0] == first argument after program name
        Scanner in = new Scanner(inFile);

        return in;
    }

    public static void initRegMap(HashMap<String, Integer> regMap)
    {
        regMap.put("zero", 0);
        regMap.put("0", 0);

        regMap.put("v0", 2);
        regMap.put("v1", 3);

        regMap.put("a0", 4);
        regMap.put("a1", 5);
        regMap.put("a2", 6);
        regMap.put("a3", 7);

        regMap.put("t0", 8);
        regMap.put("t1", 9);
        regMap.put("t2", 10);
        regMap.put("t3", 11);
        regMap.put("t4", 12);
        regMap.put("t5", 13);
        regMap.put("t6", 14);
        regMap.put("t7", 15);

        regMap.put("s0", 16);
        regMap.put("s1", 17);
        regMap.put("s2", 18);
        regMap.put("s3", 19);
        regMap.put("s4", 20);
        regMap.put("s5", 21);
        regMap.put("s6", 22);
        regMap.put("s7", 23);

        regMap.put("t8", 24);
        regMap.put("t9", 25);

        regMap.put("sp", 29);
        regMap.put("ra", 31);
    } 

    public static void initInstrMap(HashMap<String, Data> instrMap)
    {
        instrMap.put("add", new Data(0x0, 0x20, 'r'));
        instrMap.put("addi", new Data(0x8, 0x0, 'i'));
        instrMap.put("and", new Data(0x0, 0x24, 'r'));
        instrMap.put("beq", new Data(0x4, 0x0, 'i'));
        instrMap.put("bne", new Data(0x5, 0x0, 'i'));
        instrMap.put("j", new Data(0x2, 0x0, 'j'));
        instrMap.put("jr", new Data(0x0, 0x8, 'r'));
        instrMap.put("jal", new Data(0x3, 0x0, 'j'));
        instrMap.put("or", new Data(0x0, 0x25, 'r'));
        instrMap.put("sll", new Data(0x0, 0x0, 'r'));
        instrMap.put("sub", new Data(0x0, 0x22, 'r'));
        instrMap.put("slt", new Data(0x0, 0x2a, 'r'));
        instrMap.put("lw", new Data(0x23, 0x0, 'i'));
        instrMap.put("sw", new Data(0x2b, 0x0, 'i'));
    }

    public static void findLabels(List<String> assembly, HashMap<String, Integer> labelMap)
    {
        for(int i = 0; i < assembly.size(); i++)
        {
            String code = assembly.get(i);

            if(code.contains(":"))  //isLabel?
            {
                String label = code.substring(0, code.indexOf(":"));

                if(code.indexOf(":") < code.length()-1)
                    assembly.set(i, code.substring(code.indexOf(":")+1, code.length()).trim());
                else
                    assembly.remove(i);

                //System.out.println(i);
                labelMap.put(label, i);
            }
        }

    }

    public static void initAssembly(Scanner in, List<String> assembly)
    {
        String line = "";

        while(in.hasNext())
        {
            line = in.nextLine().trim();

            if(line.contains("#"))
                line = line.substring(0, line.indexOf('#'));

            if(!line.isEmpty())
            {
                assembly.add(line.replace(",", " ").replace("(", " ").replace(")", " ").replace("$", " "));                    
            }
        }
    }

    public static void main(String[] args) throws FileNotFoundException
    {
        Scanner in = openFile(args);
        List<String> assembly = new ArrayList<>();

        initAssembly(in, assembly);
        in.close();

        //Stage 1: Clean Line Read
        printAssembly(assembly, args);

        //Maps
        HashMap<String, Integer> regMap = new HashMap<>();
        initRegMap(regMap);
        printIMap(regMap, args, true);

        HashMap<String, Data> instrMap = new HashMap<>();
        initInstrMap(instrMap);
        printFMap(instrMap, args);

        HashMap<String, Integer> labelMap = new HashMap<>();
        findLabels(assembly, labelMap);

        //Stage 2: Labels Taken Out
        printIMap(labelMap, args, false);
        printAssembly(assembly, args);

        //Stage 3: Add shamt, imm, address 
        List<int[]> dec = new ArrayList<>();
        List<String[]> bin = new ArrayList<>();
        int invalidLine = -1;
        String invalidStr = null;

        for(int lineNum = 0; lineNum < assembly.size(); lineNum++)
        {
            String code = assembly.get(lineNum);
            Scanner inLine = new Scanner(code);
            String word = "";
            Data curData = null;
            int binary[] = new int[6];                  //[     0,  1,  2,    3,         4,    5 ]
                                                        //[opcode, rs, rt, rd | imm, shamt, funct]
            String[] str = new String[6];
            
            for(int i = 0; inLine.hasNext(); i++)
            {
                word = inLine.next();

                if(i == 0)
                {
                    if(instrMap.get(word) != null)          //it's an opcode
                    {
                        curData = instrMap.get(word);
                        binary[i] = curData.opcode;
                    }
                    else
                    {
                        invalidLine = lineNum;
                        invalidStr = word;
                        break;
                    }
                }
                else
                {
                    switch (curData.format) 
                    {
                        case 'r':
                            binary[5] = curData.funct;                  //funct

                            if(regMap.get(word) != null)
                            {
                                if(i == 1)
                                {
                                    if(curData.type == "jr")            //1st reg is rs
                                        binary[1] = regMap.get(word);
                                    else
                                        binary[3] = regMap.get(word);       //rd
                                }
                                //check if shift instr r-type
                                else if(i == 2)
                                {
                                    if(curData.type == "shift")
                                    {
                                        binary[2] = regMap.get(word);   //2nd reg is rt (not rs)
                                    } 
                                    else
                                        binary[1] = regMap.get(word);   //rs
                                }
                                else
                                {
                                    binary[2] = regMap.get(word);   //rt
                                }
                            }
                            else    //it's immediate (int)
                            {
                                if(curData.type == "shift")
                                {
                                    binary[4] = Integer.parseInt(word);    //4th reg is shamt
                                }
                            }
                            break;

                        case 'i':
                            if(regMap.get(word) != null)
                            {
                                if(i == 1)
                                    if(curData.type == "branch")
                                        binary[1] = regMap.get(word);       //1st reg is rs (not rt)
                                    else
                                        binary[2] = regMap.get(word);       //rt

                                //check if store / load instr (i-type)
                                else if(i == 2)
                                {
                                    if(curData.type == "store" || curData.type == "load" || curData.type == "branch")
                                        binary[2] = regMap.get(word);   //2nd reg is  (not rs)
                                    else
                                        binary[1] = regMap.get(word);   //rs
                                }
                                else
                                {
                                    if(curData.type == "store" || curData.type == "load")
                                        binary[1] = regMap.get(word);    //3rd reg is rs (not imm)
                                }
                            }
                            else if(labelMap.get(word) != null)     //it's a label for branch
                            {
                                int tNum = lineNum + 1;
                                binary[i] = labelMap.get(word) - tNum;
                            }
                            else    //it's immediate (int)
                            {
                                binary[3] = Integer.parseInt(word);     //any imm goes into rd | imm
                            }
                            break;

                        case 'j':
                            if(labelMap.get(word) != null)     //it's a label for branch
                            {
                                binary[3] = labelMap.get(word);
                            }
                            break;
                    
                        default:
                            break;
                    }

                    
                    for(int j = 0; j < binary.length; j++)
                    {
                        if(curData.format == 'r')
                        {
                            if(j == 0 || j == binary.length-1)
                            {
                                str[j] = String.format("%6s", Integer.toBinaryString(binary[j])).replace(' ', '0');
                            }
                            else
                                str[j] = String.format("%5s", Integer.toBinaryString(binary[j])).replace(' ', '0');
                        }
                        else if(curData.format == 'i')
                        {
                            switch (j) 
                            {
                                case 0:
                                    str[j] = String.format("%6s", Integer.toBinaryString(binary[0])).replace(' ', '0');
                                    break;
                                case 1:
                                case 2:
                                    str[j] = String.format("%5s", Integer.toBinaryString(binary[j])).replace(' ', '0');
                                    break;

                                case 3:
                                    str[j] = String.format("%16s", Integer.toBinaryString(binary[3])).replace(' ', '0');
                                    str[j] = str[j].substring((str[j].length()-16));
                                    break;
                            
                                default:
                                    break;
                            }

                        }
                        else if(curData.format == 'j')
                        {
                            if(j == 0)
                                str[j] = String.format("%6s", Integer.toBinaryString(binary[0])).replace(' ', '0');
                            else if(j == 1)
                                str[j] = String.format("%26s", Integer.toBinaryString(binary[3])).replace(' ', '0');
                        }
                    }

                }
            }

            bin.add(str);

            dec.add(binary);
            inLine.close();
        }

        printIntsList(dec, args);

        //List<String[]> bin = new ArrayList<>();
        //intToBinary(dec, bin);

        if(args.length >= 2)
        {
            if(args[1].charAt(0) == 'v')
            {
                System.out.println("\n--- Binary Output Table ---");
            }
        }

        //Print Binary Output
        for(int i = 0; i < bin.size(); i++)
        {
            if(i != -1 && invalidStr != null)
            {
                if(i == invalidLine)
                {
                    System.out.println("invalid instruction: " + invalidStr);
                    System.exit(1);
                }
            }

            String[] array = bin.get(i);

            for(String element: array)
            {
                if(element != null)
                    System.out.print(element + " ");
            }
            System.out.println();
        }
        
    }
}