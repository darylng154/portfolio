/*
Name:  Daryl Ng
Section:  07 | 08
Description:  
    MIPS Emulator. Runs basic MIPS assembly program.
    Compile Options:    java lab3 file1 [script] [v] [m]
         file1: assembly program file input
        script: mips program file input
             v: verbose
             m: map info

     To see commands => "mips> h". Arguments are index specific.

     ex. sum_10.asm sum_10.script - -
*/

import java.io.*;
import java.util.*;

public class lab3
{
    public static final int vArg = 3;
    public static final int mArg = 4;

    public static void printMap(HashMap<String, Integer> map)
    {
        map.forEach((key, value) ->
        {
            System.out.format("key %5s: - value: %2s \n", key, value);
        });
    }

    public static void printAssembly(List<String> assembly, String[] args)
    {
        if(args.length >= vArg)
        {
            if(args[vArg-1].charAt(0) == 'v')
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
        if(args.length >= mArg)
        {
            if(args[mArg-1].charAt(0) == 'm')
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
        if(args.length >= mArg)
        {
            if(args[mArg-1].charAt(0) == 'm')
            {
                if(reg == true)
                    System.out.println("\n--- Registers Map ---");
                else
                    System.out.println("\n--- Labels Map ---");

                printMap(regMap);
            }
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
        if(args.length >= vArg)
        {
            if(args[vArg-1].charAt(0) == 'v')
            {
                System.out.println("\n--- Decimal Output Table ---");
                for(int i = 0; i < dec.size(); i++)
                {
                    int array[] = dec.get(i);

                    System.out.format("%2d ", i);
                    for(int element: array)
                    {
                        System.out.format("%3d ", element);
                    }
                    System.out.println();
                }
            }
        }
    }

    public static void printBinary(List<String[]> bin, String invalidStr, int invalidLine, String[] args)
    {
        if(args.length >= vArg)
        {
            if(args[vArg-1].charAt(0) == 'v')
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

    /*reads assembly file and parses them into List<String> assembly 
        - element == instr. w/o symbols and separated by whitespace
        - use scanner to parse each element in String line
    */
    public static void parseAssembly(List<int[]> dec, List<String[]> bin, List<String> assembly, HashMap<String, Integer> regMap, HashMap<String, Data> instrMap, HashMap<String, Integer> labelMap, String invalidStr, int invalidLine)
    {
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
                                {
                                    if (curData.type.equals("branch"))
                                        binary[1] = regMap.get(word);       //1st reg is rs (not rt)
                                    else
                                        binary[2] = regMap.get(word);       //rt
                                }

                                //check if store / load instr (i-type)
                                else if(i == 2)
                                {
                                    if(curData.type.equals("branch"))
                                        binary[2] = regMap.get(word);   //2nd reg is  (not rs)
                                    else if(curData.type.equals("store") || curData.type.equals("load"))
                                    {
                                        binary[3] = regMap.get(word);
                                    }
                                    else
                                        binary[1] = regMap.get(word);   //rs
                                }
                                else
                                {
                                    if(curData.type.equals("store") || curData.type.equals("load"))
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
    }


    //--------------------------  [End of Lab 2] --------------------------


    public static final int scriptArg = 2;
    public static final int emArgNum = 2;
    public static boolean run = true;
    public static int pc = 0;     //line #

    public static void emulate(String[] args, HashMap<String, Integer> regMap, HashMap<String, Data> instrMap, HashMap<String, Integer> labelMap, List<String> assembly, List<int[]> dec, int[] dataMem, int[] regData)
    {
        Scanner user = null;
        char command = '\0';
        int[] argNum = new int[emArgNum];
        String userIn = null;

        if(args.length >= scriptArg && !args[scriptArg-1].equals("v") && !args[scriptArg-1].equals("m") && !args[scriptArg-1].equals("-"))
        {
            try
            {
                File inFile = new File(args[scriptArg-1]);    //args[1] == script argument
                user = new Scanner(inFile);
            } catch (FileNotFoundException e)
            {
                System.out.println("File Not Found!");
                System.exit(1);
            }
        }
        else
        {
            user = new Scanner(System.in);
        }

        while(run == true)
        {
            System.out.print("mips> ");
            userIn = user.nextLine();
            reset(argNum);

            if(args.length >= scriptArg && !args[scriptArg-1].equals("v") && !args[scriptArg-1].equals("m") && !args[scriptArg-1].equals("-"))
            {
                System.out.println(userIn);
            }

            if(!userIn.isEmpty())
            {
                Scanner code = new Scanner(userIn);

                if(code.hasNext())
                    command = code.next().charAt(0);

                for(int i = 0; code.hasNextInt(); i++)
                {
                    argNum[i] = code.nextInt();
                }

                if(args.length >= vArg)
                {
                    if(args[vArg-1].charAt(0) == 'v')
                    {
                        System.out.println("\n--- User Input ---");
                        System.out.format("command: %c; num1: %-4d; num2: %-4d \n", command, argNum[0], argNum[1]);
                    }
                }

                code.close();

                //mips command parsed to command & argNum[emArgNum == 2]
                aCommand(args, regMap, instrMap, labelMap, assembly, dec, dataMem, regData, command, argNum);
            }
        }
    }

    public static void aCommand(String[] args, HashMap<String, Integer> regMap, HashMap<String, Data> instrMap, HashMap<String, Integer> labelMap,
                                List<String> assembly, List<int[]> dec, int[] dataMem, int[] regData, char command, int[] argNum)
    {
        switch (command)
        {
            case 'h':   //display help
                displayH();
                break;

            case 'd':   //dump registers
                dumpRegs(args, regMap, regData);
                break;

            case 's':   //step thru mips
                if(argNum[0] == 0 && argNum[1] == 0)    //single step
                {
                    aStep(args, instrMap, assembly, dec, dataMem, regData, argNum);
                    System.out.println("\t\t1 instruction(s) executed");
                }
                else    //multi step argNum[0] times
                {
                    for(int i = 0; i < argNum[0]; i++)
                    {
                        aStep(args, instrMap, assembly, dec, dataMem, regData, argNum);
                    }
                    System.out.println("\t\t" + argNum[0] +" instruction(s) executed");
                }
                break;

            case 'r':   //run all assembly
                while(pc < assembly.size())
                {
                    aStep(args, instrMap, assembly, dec, dataMem, regData, argNum);
                }
                break;

            case 'm':   //display dataMem from argNum[0] to argNum[1] (inclusive of num1 & num2)
                System.out.println();
                for(int i = argNum[0]; i <= argNum[1]; i++)
                {
                    System.out.format("[%4d] = %-3d\n", i, dataMem[i]);
                }
                System.out.println();
                break;

            case 'c':   //clear all reg, dataMem, pc
                reset(regData);
                reset(dataMem);
                pc = 0;
                System.out.println("\t\tSimulator reset");
                break;

            case 'q':   //quit
                run = false;
                break;

            default:
                break;
        }
    }

    public static void aStep(String[] args, HashMap<String, Data> instrMap, List<String> assembly, List<int[]> dec, int[] dataMem, int[] regData, int[] argNum)
    {
        if(pc < assembly.size())    //not out of bounds
        {
            String instr = null;
            Scanner line = new Scanner(assembly.get(pc));
            Data curData = null;
            int[] curDec = null;
            int rs = 1;
            int rt = 2;
            int rd = 3;     //also imm
            int shamt = 4;
            int funct = 5;
            int ra = 31;

            instr = line.next();

            if(args.length >= vArg)
            {
                if(args[vArg-1].charAt(0) == 'v')
                {
                    System.out.println(pc + " " + assembly.get(pc));
                }
            }


            if ((curData = instrMap.get(instr)) != null)
            {
                curDec = dec.get(pc++);

                switch (curData.format)
                {
                    case 'r':
                        if (instr.equals("add"))    //R[rd] = R[rs] + R[rt]
                        {
                            regData[curDec[rd]] = regData[curDec[rs]] + regData[curDec[rt]];
                        }
                        else if (instr.equals("sub"))
                        {
                            regData[curDec[rd]] = regData[curDec[rs]] - regData[curDec[rt]];
                        }
                        else if (instr.equals("or"))
                        {
                            regData[curDec[rd]] = regData[curDec[rs]] | regData[curDec[rt]];
                        }
                        else if (instr.equals("and"))
                        {
                            regData[curDec[rd]] = regData[curDec[rs]] & regData[curDec[rt]];
                        }
                        else if (instr.equals("jr"))
                        {
                            pc = regData[curDec[rs]];
                        }
                        else if (instr.equals("sll"))
                        {
                            regData[curDec[rd]] = regData[curDec[rt]] << regData[curDec[shamt]];
                        }
                        else if (instr.equals("slt"))
                        {
                            if (regData[curDec[rs]] < regData[curDec[rt]])
                                regData[curDec[rd]] = 1;
                            else
                                regData[curDec[rd]] = 0;
                        }
                        break;

                    case 'i':
                        if(instr.equals("addi"))
                        {
                            regData[curDec[rt]] = regData[curDec[rs]] + curDec[rd];
                        }
                        else if (instr.equals("lw"))
                        {
                            regData[curDec[rt]] = dataMem[regData[curDec[rs]] + curDec[rd]];
                        }
                        else if (instr.equals("sw"))
                        {
                            dataMem[regData[curDec[rs]] + curDec[rd]] = regData[curDec[rt]];
                        }
                        else if (instr.equals("beq"))
                        {
                            if(regData[curDec[rs]] == regData[curDec[rt]])
                                pc += curDec[rd];
                        }
                        else if (instr.equals("bne"))
                        {
                            if(regData[curDec[rs]] != regData[curDec[rt]])
                                pc += curDec[rd];
                        }
                        break;

                    case 'j':
                        if(instr.equals("j"))
                        {
                            pc = curDec[rd];
                        }
                        else if(instr.equals("jal"))
                        {
                            regData[ra] = pc;
                            pc = curDec[rd];
                        }
                        break;

                    default:
                        break;
                }
            }
        }
    }

    public static void reset(int[] regData)
    {
        for(int i = 0; i < regData.length; i++)
        {
            regData[i] = 0;
        }
    }

    public static void dumpRegs(String[] args, HashMap<String, Integer> regMap, int[] regData)
    {
        //sorts regMap by value
        List< Map.Entry<String, Integer> > regIndex = new LinkedList<Map.Entry<String,Integer> >(regMap.entrySet());
        /*
        if(args.length >= vArg)
        {
            if(args[vArg-1].charAt(0) == 'v')
            {
                System.out.println("\n--- List of Reg Map ---");
                System.out.println(regIndex);
            }
        }
         */

        Collections.sort(regIndex, new Comparator< Map.Entry<String, Integer> >()
        {
            public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2)
            {
                return (o1.getValue()).compareTo(o2.getValue());
            }
        });

        regIndex.remove(0);

        if(args.length >= vArg)
        {
            if(args[vArg-1].charAt(0) == 'v')
            {
                //System.out.println("\n--- Sorted List of Reg Map ---");
                //System.out.println(regIndex);
                System.out.println("\n--- Register Dump ---");
            }
        }

        System.out.print("\n pc = " + pc);
        for(int i = 0; i < regIndex.size(); i++)
        {
            if(i % 4 == 0)
            {
                System.out.println();
            }

            System.out.format("$%-2s = %-4d     ", regIndex.get(i).getKey(), regData[regIndex.get(i).getValue()]);
        }
        for (int element:regData)
        {
            //System.out.print(element + ", ");
        }
        System.out.println("\n");
    }

    public static void displayH()
    {
        System.out.println("\n" +
                "h = show help\n" +
                "d = dump register state\n" +
                "s = single step through the program (i.e. execute 1 instruction and stop)\n" +
                "s num = step through num instructions of the program\n" +
                "r = run until the program ends\n" +
                "m num1 num2 = display data memory from location num1 to num2\n" +
                "c = clear all registers, memory, and the program counter to 0\n" +
                "q = exit the program\n");
    }


    //--------------------------  [End of Lab 3] --------------------------



    public static void main(String[] args) throws FileNotFoundException
    {
        Scanner in = openFile(args);
        List<String> assembly = new ArrayList<>();      //element == assembly code in order

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
        List<int[]> dec = new ArrayList<>();        //element == instr. int data    //[     0,  1,  2,    3,         4,    5 ]
                                                                                    //[opcode, rs, rt, rd | imm, shamt, funct]
        List<String[]> bin = new ArrayList<>();     //element == instr. binary str
        int invalidLine = -1;
        String invalidStr = null;

        parseAssembly(dec, bin, assembly, regMap, instrMap, labelMap, invalidStr, invalidLine);

        printIntsList(dec, args);
        //Binary Output (Lab 1)
        //printBinary(bin, invalidStr, invalidLine, args);

        
        //--------------------------  [End of Lab 2] --------------------------

        
        int[] dataMem = new int[8192];
        int[] regData = new int[32];        //element[regMap value] == register data holder

        emulate(args, regMap, instrMap, labelMap, assembly, dec, dataMem, regData);


        //--------------------------  [End of Lab 3] --------------------------



    }
}