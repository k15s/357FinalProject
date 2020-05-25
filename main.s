// Place static data declarations/directives here
  		.data
// Dot product: (a1,a2,a3,a4,a5,a6)*(b1,b2,b3,b4,b5,b6)=
//              (a1*b1 + a2*b2 + a3*b3 + a4*b4 + a5*b5 + a6*b6

// Place static data declarations/directives here

        .data
mymsg1:  .asciz "Welcome to EE357 Lab1! \n Let's try a dot product example.\n"  // Remember to put and get 
mymsg2:  .asciz "  The dot product is: "  // Remember to put and get
avec:   .dc.w 0,1,2,3,4,5
bvec:   .dc.w 0,1,2,3,4,5
dotprod: .ds.l 1 
  		.text
		.global _main
		.global main
		.global mydat
		.include "../Project_Headers/ee357_asm_lib_hdr.s"

risc_code:             	.long 0x0810000b, 0x04040000, 0x08300000, 0x084000ff
						.long 0x0dd00000,0x12c00008, 0x09200001, 0x20900001
						.long 0x09b00004,0x108fffec,0x81000000 
registers:              .long 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
memory:               	.long 0x0,0xff,0x1,0x2,0xff,0xff,0x0,0xf,0xff,0xa,0xff

_main:
main:	
//------- Template Test: Replace Me ----- //
	  // Prints welcome message
	  
	  //start here
welc: //movea.l #mymsg1, a1
      //jsr ee357_put_str
      //jsr ee357_put_int
      
init: 	movea.l #risc_code,a0 
		//a0 for the PC (Program Counter) 
		movea.l #registers,a1 // a1 for the registers, R0 ~ R7 
		movea.l #memory,a2 // a2 for the (data) memory
		move.l #4, d6
		move.l #0, d4
		move.l #0, d0
		move.l #0, d1
		move.l #0, d2
		move.l #0, d3
		move.l #0, d5

fetch: move.l (a0), d1
	   lsr.l #8, d1
	   lsr.l #8, d1
	   lsr.l #8, d1
	   lsr.l #2, d1
	   cmpi.l #1, d1
	   beq ADD
	   cmpi.l #2, d1
	   beq ADDI
	   cmpi.l #3, d1
	   beq LOAD
	   cmpi.l #4, d1
	   beq BNE
	   cmpi.l #8, d1
	   beq SUBI
	   cmpi.l #32, d1
	   beq DISP
	   

ADD:    move.l (a0), d1
		//andi.l #00000011100000000000000000000000, d1
		andi.l #0x3ffffff, d1
		lsr.l #8, d1 //a
	    lsr.l #8, d1
	    lsr.l #7, d1
		mulu.l d6, d1
		//reset reg's
		//move.l #0, a1
		//add.l d1, a1
		//move.l (a1), d1 //overrwrite d1 with value in memory
		move.l (a1, d1), d1
		
		move.l (a0), d2
		//andi.l #00000000011100000000000000000000, d2
		andi.l #0x7fffff, d2
		//b
		lsr.l #8, d2
	    lsr.l #8, d2
	    lsr.l #4, d2
		mulu.l d6, d2	
		//reset reg's
		//move.l #0, a1
		//add.l d2, a1
		//move.l (a1), d2 //overrwrite d2 with value in memory
		move.l (a1, d2), d2
	
		move.l (a0), d3
		//andi.l #00000000000011100000000000000000, d3
		andi.l #0xfffff, d3
		//c = destination
		lsr.l #8, d3
	    lsr.l #8, d3
	    lsr.l #1, d3
		
		add.l d1, d2
		
		//move.l #0, a1
		//mulu.l d6, d3
		//add.l d3, a1
		//move.l d2, (a1)
		move.l d2, (a1, d3) 
		
		add.l #4, a0	//Increment PC by 4 The instruction size is fixed as 4 bytes. 
	   	bra fetch // Branch always to fetch.
 
ADDI:   move.l (a0), d1

		andi.l #0x3ffffff, d1
		//a
		lsr.l #8, d1
	    lsr.l #8, d1
	    lsr.l #7, d1
		mulu.l d6, d1
		//move.l #0, a1
		//add.l d1, a1
		//move.l (a1), d1 //overrite d1 with value pulled from memory
		move.l (a1, d1), d1
		
		move.l (a0), d2
		//andi.l #00000000011100000000000000000000, d2 //dont touch, store here
		andi.l #0x7fffff, d2
		//b
		lsr.l #8, d2
	    lsr.l #8, d2
	    lsr.l #4, d2
		
		move.l (a0), d3	
		//andi.l #00000000000011111111111111111111, d3
		andi.l #0xfffff, d3
		
		add.l d1, d3
		move.l d3, d4 //sum of addition d4
		
		//middle rt has answer
		//move.l #0, a1
		//add.l d2, a1	
		//move.l d4, (a1)  
		mulu.l d6, d2 //prep d2 for virtual reg insertion
		move.l d4, (a1, d2) //place answer into R"d2"
		
		add.l #4, a0	//Increment PC by 4 The instruction size is fixed as 4 bytes. 
	   	bra fetch; // Branch always to fetch.
 
LOAD:	move.l (a0), d1
		//andi.l #00000011100000000000000000000000, d1
		andi.l #0x3ffffff, d1 //get the first reg
		//a
		lsr.l #8, d1
	    lsr.l #8, d1
	    lsr.l #7, d1 //rs in d1
	    
		move.l (a0), d2
		//andi.l #00000000011100000000000000000000, d2
		andi.l #0x7fffff, d2
		//b
		lsr.l #8, d2
	    lsr.l #8, d2
	    lsr.l #4, d2 //rt in d2
	    
		move.l (a0), d3	
		//andi.l #00000000000011111111111111111111, d3
		andi.l #0xfffff, d3 //get intermed. in d3
		
		mulu.l d6, d1 //prepare to get the actual value from rs
		move.l (a1, d1), d7 //get RS's value and place in d7, get data from virtual register that d1 points to
		//d7 now contains RS
		
		add.l d3, d7 //d7 = immediate + RS value
		
		//get data from memory 
		//(a2, d7) =  starting address of mem + (imm. + RS value)
		move.l (a2, d7), d7  //Mem [ starting address of mem + (imm. + RS value) ]
		
		//place retrieved data into RT
		mulu.l d6, d2 //prepare for indexing against memory
		move.l d7, (a1, d2)
		
		//OUR FINAL HOPE ENDS HERE
		
		//mulu.l d6, d7
		
		//mulu.l d6, d1 //get ready for psuedo memory access by multiplying by 4
		//move.l (a2, d1), d7 //get from memory and store in d1, d1 = Mem[sum]
		//move.l (a2, d7), d3 //get from memory and store in d3, d3 = Mem[sum] FREEEEEZE
		
		//mulu.l d6, d2 //get the right register to store into
		//move.l d7, (a1, d2) //store retrieved value in rt/store d1 in d2 psuedo register index
		//move.l d3, (a1, d2) //store retrieved value in rt/store d1 in d2 psuedo register index
		
		add.l #4, a0	//Increment PC by 4 The instruction size is fixed as 4 bytes. 
	   	bra fetch; // Branch always to fetch.
 
BNE:   	move.l (a0), d1
		//andi.l #00000011100000000000000000000000, d1
		andi.l #0x3ffffff, d1
		//a
		lsr.l #8, d1
	    lsr.l #8, d1
	    lsr.l #7, d1 //d1 is rs
	    
	    //move.l #5, d5
	    //mulu.l d6, d5
	    //move.l (a1, d5), d5 //d5 holds R5
	    
		mulu.l d6, d1 //prepare for virtual reg. retrieval
		//move.l #0, a1
		//add.l d1, a1
		//move.l (a1), d1 //overrite d1 with value pulled from memory
		move.l (a1, d1), d7 //d7 now contains the virtual register value
		
		move.l (a0), d2
		//andi.l #00000000011100000000000000000000, d2 
		andi.l #0x7fffff, d2
		//b
		lsr.l #8, d2
	    lsr.l #8, d2
	    lsr.l #4, d2 //d2 is rt
		mulu.l d6, d2  //prepare for virtual reg. retrieval
		//move.l #0, a1
		//add.l d2, a1
		//move.l (a1), d2 //overrite d2 with value pulled from memory
		move.l (a1, d2), d2 //d2 now contains the virtual reg. value
		
		//compare rs and rt
		cmp.l d7, d2
		bne BNEOP //branch if not equal
		add.l #4, a0	//Increment PC by 4 The instruction size is fixed as 4 bytes. 
	   	bra fetch; // Branch always to fetch.

BNEOP:  move.l (a0), d3	
		//andi.l #00000000000011111111111111111111, d3
		andi.l #0xfffff, d3 //get immediate 
		move.l d3, d4 //d4 now has d3 immediate
		//isolate MSB
		lsr.l #8, d4
	    lsr.l #8, d4
	    lsr.l #3, d4 //d4 has been shifted to the MSB
	    move.l #1, d7 //mirror the negative bit check
		cmp.l d4, d7 //neg, do more work
		beq BNENEG
		add.l d3, a0 //pc = pc + immediate
	   	bra fetch; // Branch always to fetch.
		
BNENEG: //d3 has the immediate
		//ori.l #11111111111100000000000000000000, d3
		ori.l #0xfff00000, d3 //extend sign
		add.l d3, a0 //now add to PC
	   	bra fetch; // Branch always to fetch.
 
SUBI:  	move.l (a0), d1
		//andi.l #00000011100000000000000000000000, d1
		andi.l #0x3ffffff, d1
		//a
		lsr.l #8, d1
	    lsr.l #8, d1
	    lsr.l #7, d1 //d1 is now rs
		mulu.l d6, d1 //prepare for getting register values
		//move.l #0, a1
		//add.l d1, a1
		//move.l (a1), d1 //overrite d1 with value pulled from memory
		move.l (a1, d1), d7 //store pulled d1 from virtual reg. in d7
		
		move.l (a0), d2
		//andi.l #00000000011100000000000000000000, d2 //dont touch, store here
		andi.l #0x7fffff, d2
		//b
		lsr.l #8, d2
	    lsr.l #8, d2
	    lsr.l #4, d2 //d2 is now rt
		
		move.l (a0), d3	
		//andi.l #00000000000011111111111111111111, d3
		andi.l #0xfffff, d3 //d3 is immediate
		
		sub.l d3, d7 //d7 = d7 - d3
		
		//move.l d3, d4 //sum of addition d4
		//middle rt has answer
		//move.l #0, a1
		//add.l d2, a1	
		//move.l d4, (a1)
		mulu.l d6, d2 //d2 is preparing for the virtual reg address
		move.l d7, (a1, d2) //store subtraction result in d2 psuedo register index

		add.l #4, a0	//Increment PC by 4 The instruction size is fixed as 4 bytes. 
	   	bra fetch; // Branch always to fetch.
 
DISP:  	move.l (a0), d1
		//andi.l #00000011100000000000000000000000, d1
		andi.l #0x3ffffff, d1
		lsr.l #8, d1
	    lsr.l #8, d1
	    lsr.l #7, d1 //d1 is rs
		mulu.l d6, d1 //prep for  virtual reg extract
		//move.l #0, a1
		//add.l d1, a1
		//move.l (a1), d1 //overrite d1 with R2 value
		move.l (a1, d1), d1 //d1 now contains value stored in formerly reg d1 aka R2
		
		andi.l #0x0000000f, d1 //d1 contains the byte
		
		/* Initialize the LED's. */
		move.l #0x0,d0
		move.b d0,0x4010006F // Set pins to be used GPIO.
		move.l #0xFFFFFFFF,d0
		move.b d0,0x40100027 // Set LED's as output.

		// Initial value 0000 for the LED's:
		//move.l #0x3,d1
		//move.l d1,0x4010000F
		move.b d1,0x4010000F
		
		add.l #4, a0	//Increment PC by 4 The instruction size is fixed as 4 bytes. 
	   	//bra.s fetch; // Branch always to fetch.
 
ptrst:	movea.l #mymsg2, a1
      	//jsr ee357_put_str   //a1 messages
	  	//jsr ee357_put_int   //Print the dot product to the console
	  
//======= Let the following few lines always end your main routing ===//		
//------- No OS to return to so loop ---- //
//------- infinitely...Never hits rts --- //		
inflp:	bra.s	inflp
		rts
