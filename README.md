# Daryl Ng's Portfolio


## Description

This repository showcases projects that I am proud of. I organized it by the language and then how interesting it was.
You can find the links to the source code under each projects' programming language.

<br>

My personal favorites are Google Maps and AWS Frontend Login and Sign-Up as they display my passion and skills to learn a new language (Dart)
and framework (Flutter) to work with my clients by providing them with neat and well-documented code to continue on with the next team.

## Table of Contents

Flutter / Dart:

[1. Google Maps (Recommend)](#google-maps)

[2. Frontend AWS Login & Sign-Up (Recommend)](#frontend-aws-login--sign-up)

[3. Scrollable List (buttonlist)](#buttonlist)
<p>
<br>
</p>

React:

[1. Pokemon Wiki (poke_wiki) (Recommend)](#poke_wiki)
<p>
<br>
</p>

C:

[1. Remote File Copy (rcopy) (Recommend)](#rcopy)

[2. Operating System Virtual Memory Simulator (mem_sim) (Recommend)](#mem_sim)

[3. Lightweight Process Library (lwp)](#lwp)

[4. Operating System Scheduler Simulator (sched_sim)](#sched_sim)

[5. Network Protocol Header Parser (trace)](#trace)

[6. TCP Chat Program (tcp_chat)](#tcp_chat)
<p>
<br>
</p>

Java:

[1. Object Oriented Zombie Game (Recommend)](#zombie_game)

[2. Cache Simulator (cache_sim)](#cache_sim)

[3. MIPS Emulator with Pipelines (mips_emu_pipeline)](#mips_emu_pipeline)

[4. MIPS Emulator (mips_emu)](#mips_emu)

[5. Assembly to Machine Code (assembly_parser)](#assembly_parser)
<p>
<br>
</p>

Verilog:

[1. FPGA RISC-V Microcontroller Unit](#risc-v_mcu)
<p>
<br><br>
</p>


### Google Maps
<p>
Description: 
  <br>
The main goal of this project is to incorporate Google Maps features into a clickable Button widget
with the Google Maps icon on it and provide routing information for my clients’ delivery management
system. The objectives of the Google Maps features include:
  <br>
1) Creating repositories and models for the Google Maps HTTP API calls. Specifically, the Geocoding
and Directions API.
  <br>
2) Displaying markers, routes, live GPS of the Transporter on an embedded Google Maps widget.
  <br>
3) Creating an interface for the Frontend that utilizes my project.
  <br>
4) Provide my clients with documented code to continue the project.
  <br>
  <br>
Date: Mar 2023 - June 2023
  <br>
Language: Flutter / Dart
  <br>

[Source Code](https://github.com/darylng154/package_system/tree/main/features/google_maps)
  <br>
Video Links:
  <br>
</p>

[Senior Project Integration](https://youtu.be/KrYpAGAOGGo)

[Testing Screen](https://youtu.be/0bY0WnmrB9Q)


<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/google_maps/transporter_home.png?raw=true" width=30% height=30%>
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/google_maps/testing_screen.png?raw=true" width=30% height=30%>
  <br>
Google Maps Button for Transporter Home & Testing Screen
  <br>
  <br>

<img src = "https://github.com/darylng154/Projects/blob/main/README_files/google_maps/slo_to_san_diego_form.png?raw=true" width=30% height=30%>
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/google_maps/slo_to_san_diego_map.png?raw=true" width=30% height=30%>
  <br>
Shipment From San Luis Obispo to San Diego
  <br>
  <br>

<img src = "https://github.com/darylng154/Projects/blob/main/README_files/google_maps/testing_1.png?raw=true" width=30% height=30%>
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/google_maps/testing_2.png?raw=true" width=30% height=30%>
  <br>
Markers & Route of All Packages in a Route
  <br>
  <br>

<img src = "https://github.com/darylng154/Projects/blob/main/README_files/google_maps/testing_1_pickup.png?raw=true" width=30% height=30%>
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/google_maps/testing_1_dest.png?raw=true" width=30% height=30%>
  <br>
Origin & Destination of the Rotue
  <br>
  <br>

<img src = "https://github.com/darylng154/Projects/blob/main/README_files/google_maps/testing_3.1.png?raw=true" width=30% height=30%>
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/google_maps/testing_3.2.png?raw=true" width=30% height=30%>
  <br>
Live GPS tracking of Transporter's Current Location
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### Frontend AWS Login & Sign-Up
<p>
Description: 
  <br>
Users can login or create an account that will be stored in the backend. When creating a new account, users can select their desired account type so they will be routed to the correct page upon logging in. After submitting all fields, the user will be sent a verification code in their email to verify their account. Once a verified account logs in, they are routed to a page based on account type (shipper, transporter, dispatcher, or admin). From there, each actor (account type) has certain actions and pages available to them.
  <br>
  <br>
Date: Jan 2023 - Mar 2023
  <br>
Language: Flutter / Dart
  <br>
    
[Source Code](https://github.com/darylng154/package_system/tree/main/features)
  <br>
Video Links:
  <br>
</p>

[Login & Sign-Up Demo](https://youtu.be/BlXclX1P92Q)
<br>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/aws_login_signup/login.png?raw=true" width=30% height=30%>
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/aws_login_signup/account.png?raw=true" width=30% height=30%>
  <br>
Login/Sign-up screen with screen to enter Account details.
  <br>
  <br>

<img src = "https://github.com/darylng154/Projects/blob/main/README_files/aws_login_signup/auth.png?raw=true" width=80% height=80%>
  <br>
Authentication code in the user's email after clicking "Create an Account" button.
  <br>
  <br>
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/aws_login_signup/code.png?raw=true" width=30% height=30%>
  <br>
User entering the recieved Authentication code to finalize Account creation.
  <br>
  <br>

<img src = "https://github.com/darylng154/Projects/blob/main/README_files/aws_login_signup/logging_shipper.png?raw=true" width=30% height=30%>
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/aws_login_signup/shipper.png?raw=true" width=30% height=30%>
  <br>
Logging into a Shipper Account.
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### buttonlist
<p>
Description: 
  <br>
Client requested an infinite scrollable package list for Android & IOS in 10 weeks using Flutter.
  <br>
  <br>
Date: Sept 2023 - Dec 2023
  <br>
Language: Flutter / Dart
  <br>
    
[Source Code](https://github.com/darylng154/package_system/tree/main/widget/non_feature_widgets/button)
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/buttonlist/buttonlist_classes.png?raw=true" width=50% height=50%>
  <br>
List of key features of buttonlist
  <br>
  <br>
<img src = "https://github.com/darylng154/Projects/blob/main//README_files/buttonlist/buttonlist_features.png?raw=true" width=50% height=50%>
  <br>
List of classes used in buttonlist
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### poke_wiki
<p>
Description: 
  <br>
Want to view all your favorite pokemons? Come to PokeWiki, to see Pokemon's details from it's number, name, description, types, abilities, height, weight, and background. Select your favorite Pokemons with the heart after logging in. Filter by it's name or types (up to many). Use the "Add Pokemon" Form to add your favorite Pokemons from Numbers 1 to 807! Come join us today at PokeWiki!
  <br>
  <br>
Date: Jan 2022 - Mar 2022
  <br>
Language: React
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/poke_wiki)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/poke_wiki/home.png?raw=true" width=75% height=75%>
  <br>
Pokemone Wiki Home page.
  <br>
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/poke_wiki/table.png?raw=true" width=75% height=75%>
  <br>
Table of Pokemon page.
  <br>
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/poke_wiki/filter_name.png?raw=true" width=75% height=75%>
  <br>
Table of Pokemon filtered by name.
  <br>
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/poke_wiki/filter_types.png?raw=true" width=75% height=75%>
  <br>
Table of Pokemon filtered by one or more types.
  <br>
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/poke_wiki/pokemon.png?raw=true" width=75% height=75%>
  <br>
Individual page for each Pokemon.
  <br>
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/poke_wiki/add_pokemon.png?raw=true" width=75% height=75%>
  <br>
Page to add Pokemons into the Table and Database.
  <br>
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/poke_wiki/login.png?raw=true" width=75% height=75%>
  <br>
Login Page to favorite Pokemons.
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### rcopy
<p>
Description: 
  <br>
Remote file copy using UDP with sliding window flow control that uses selective-reject ARQ. There are 2 programs: one for the server and the other for the client (rcopy).
Supports error recovery when packets are lost or corrupted on server and client side. Also supports multiple clients coping different files at once.
  <br>
  <br>
Date: Feb 2023
  <br>
Language: C
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/rcopy)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/rcopy/small_no_drops.png?raw=true" width=75% height=75%>
  <br>
Small file (279 Bytes) transfer with 0% (0.0) error percent.
  <br>
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/rcopy/big50_drops.png?raw=true" width=75% height=75%>
  <br>
Big file (424,232 Bytes) transfer with 1% (0.1) error percent.
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### mem_sim
<p>
Description: 
  <br>
Operating System Virtual Memory simulator, which translates virtual memory addresses (like those that come from a process) to physical memory addresses (as managed by
the operating system). Only focuses on read operations using a Translation Lookaside Buffer (TLB), Page Table, Backing store, and Simulated Physical memory.
  <br>
  <br>
Date: May 2023
  <br>
Language: C
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/mem_sim)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/mem_sim/demo.png?raw=true" width=75% height=75%>
  <br>
Terminal output of the Virtual memory simulator using FIFO.
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### lwp
<p>
Description: 
  <br>
Creates an independent thread to control a sequence of executed instructions that is executing in the same address space of another lightweight process.
Modifies the process' stack registers/pointers to jump and execute a different function that was not in the original context.
  <br>
  <br>
Date: Apr 2023
  <br>
Language: C
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/lwp)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/lwp/demo.png?raw=true" width=75% height=75%>
  <br>
Creating and using a LWP thread in numbermain's stack.
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### sched_sim
<p>
Description: 
  <br>
Operating System Scheduler simulator that supports multiple scheduling algorithms, and computes the turnaround and wait times for each job submitted to the simulator.
Job file contains a list of jobs' burst and arrival times in any order.
  <br>
  <br>
Date: May 2023
  <br>
Language: C
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/sched_sim)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/sched_sim/demo.png?raw=true" width=50% height=50%>
  <br>
Terminal output of the Schedule Simulator for all supported algorithms.
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### trace
<p>
Description: 
  <br>
Parses Ethernet, ARP, IP: ICMP, TCP, UDP Header information from Wire Shark Pcap files to an outputted file.
  <br>
  <br>
Date: Jan 2023
  <br>
Language: C
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/trace)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/trace/trace-1.png?raw=true" width=50% height=50%>
  <br>
Packet #22's Ethernet, IP, TCP Header information parsed.
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### tcp_chat
<p>
Description: 
  <br>
TCP Chat program. There are 2 programs: one for the server and the other for the client(s). You can check who is logged and send messages to users in real time. 
Uses my own Handle/Client Table that is a dynamically allocated array to keep track of the users logged in. The supported commands are described in the README.
  <br>
  <br>
Date: Feb 2023
  <br>
Language: C
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/tcp_chat)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/tcp_chat/demo.png?raw=true" width=75% height=75%>
  <br>
Multiple users talking to each other on the server.
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### zombie_game
<p>
Description: 
  <br>
•	Developed entities that interact with each other and their PImage grid environment
  <br>
•	Implemented A* Search Algorithm to improve entities' pathing strategy from Depth First Search
  <br>
•	Employed Object Oriented Programming inheritance and polymorphism to manage and simplify dynamic entities' interactions while maintaining its hierarchy
  <br>
•	Utilized Streams to filter and map grid Points our entities can actually move to in our A* Algorithm
  <br>
  <br>
Date: Nov 2020
  <br>
Language: Java
  <br>

[Source Code](https://github.com/darylng154/Project-5)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/zombie_game/game.png?raw=true" width=80% height=80%>
  <br>
Zombies chasing after Fish who can turn into other entities.
  <br>
  <br>
<img src = "https://github.com/darylng154/Projects/blob/main//README_files/zombie_game/entity.png?raw=true" width=80% height=80%>
  <br>
XML Graph of the Entity Hierarchy.
  <br>
  <br>
<img src = "https://github.com/darylng154/Projects/blob/main//README_files/zombie_game/world.png?raw=true" width=80% height=80%>
  <br>
XML Graph of the World Hierarchy.
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### cache_sim
<p>
Description: 
  <br>
Cache Simulator: Models 7 different cache configs and prints: # of hits & hit rate & etc.
  <br>
  <br>
Date: Jan 2022 - Mar 2022
  <br>
Language: Java
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/cache_sim)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/cache_sim/cache_sim-1.png?raw=true" width=50% height=50%>
  <br>
Terminal Output of Cache Simulator (1)
  <br>
  <br>
<img src = "https://github.com/darylng154/Projects/blob/main//README_files/cache_sim/cache_sim-2.png?raw=true" width=50% height=50%>
  <br>
Terminal Output of Cache Simulator (2)
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### mips_emu_pipeline
<p>
Description: 
  <br>
MIPS Emulator with Pipelines. Runs basic MIPS assembly program while passing instr to pipelines.
  <br>
  <br>
Date: Jan 2022 - Mar 2022
  <br>
Language: Java
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/mips_emu_pipeline)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/mips_emu_pipeline/mips_emu_pipeline-1.png?raw=true" width=50% height=50%>
  <br>
Terminal Output of MIPS Emulator with Pipelines (1)
  <br>
  <br>
<img src = "https://github.com/darylng154/Projects/blob/main//README_files/mips_emu_pipeline/mips_emu_pipeline-2.png?raw=true" width=50% height=50%>
  <br>
Terminal Output of MIPS Emulator with Pipelines (2)
  <br>
  <br>
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/mips_emu_pipeline/mips_emu_pipeline-3.png?raw=true" width=50% height=50%>
  <br>
Terminal Output of MIPS Emulator with Pipelines (3)
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### mips_emu
<p>
Description: 
  <br>
MIPS Emulator. Runs basic MIPS assembly program.
  <br>
  <br>
Date: Jan 2022 - Mar 2022
  <br>
Language: Java
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/mips_emu)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/mips_emu/mips_emu-1.png?raw=true" width=50% height=50%>
  <br>
Terminal Output of MIPS Emulator (1)
  <br>
  <br>
<img src = "https://github.com/darylng154/Projects/blob/main//README_files/mips_emu/mips_emu-2.png?raw=true" width=50% height=50%>
  <br>
Terminal Output of MIPS Emulator (2)
  <br>
  <br>
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/mips_emu/mips_emu-3.png?raw=true" width=50% height=50%>
  <br>
erminal Output of MIPS Emulator (3)
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### assembly_parser
<p>
Description: 
  <br>
Translates / Parses Assembly Program to Machine Code (Binary).
  <br>
  <br>
Date: Jan 2022 - Mar 2022
  <br>
Language: Java
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/assembly_parser)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/assembly_parser/assembly_parser-1.png?raw=true" width=50% height=50%>
  <br>
Output File after Assembly Code is parsed into Machine Code.
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>

### risc-v_mcu
<p>
Description: 
  <br>
Engineered a microcontroller on a Basys 3 FPGA board using Verilog in Vivado to parse and run assembly as RISC-V instructions.
  <br>
• Created a Program Counter, Branch Address Generator, Decoder, etc to translate, step, and jump through machine code instructions in Memory
  <br>
•	Built a Register File and Arithmetic Logic Unit to manipulate data and differentiate what the current instruction is based on its opcode
  <br>
•	Implemented interrupt service routines by adding a Control and Status Register to give the system more flexibility in the program flow
  <br>
•	Utilized Vivado's test bench simulator to test and ensure accurate data, behavior, and clock cycle timing  
  <br>
  <br>
Date: Apr 2021 - May 2021
  <br>
Language: Verilog
  <br>

[Source Code](https://github.com/darylng154/portfolio/tree/risc-v_mcu)
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/risc-v_mcu/schematic.png?raw=true" width=80% height=80%>
  <br>
Schematic of the complete RISC-V Microcontroller developed.
  <br>
  <br>
</p>

<p align = "center">
<img src = "https://github.com/darylng154/Projects/blob/main/README_files/risc-v_mcu/isr_sim.png?raw=true" width=80% height=80%>
  <br>
Simulation result of the interruption service routine test bench.
  <br>
  <br>
</p>

[Back to Table of Contents](#table-of-contents)

<br>