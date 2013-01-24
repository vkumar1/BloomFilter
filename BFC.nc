/***********************************
author: Vimal Kumar
desc: Bloom Filter Module file
***********************************/
#include "BF.h"
#define HASHSIZE 20
module BFC
{
	 //uses interface Timer<TMilli> as Timer0;
	 uses interface Leds;
	 uses interface Boot;
	 uses interface SHA1;
	 //uses interface Receive;
    	 //uses interface AMSend;
	 //uses interface SplitControl as AMControl;
	 //uses interface Packet;
}
implementation
{
	SHA1Context context;
	//uint8_t BFlength = M/8;	
	uint8_t BFilter[BFlength];
	uint8_t input[HASHSIZE];
	uint8_t output[HASHSIZE];
	uint8_t testHash[HASHSIZE];
	void init()
	{
		input[0] = 1;
		input[10] = 10;
	}
	void createHash(uint8_t* ip, uint8_t* op)
	{
		call SHA1.reset(&context);
		call SHA1.update(&context, ip, HASHSIZE);
		call SHA1.digest(&context, op);
	}
	void mapToBF()
	{
		uint8_t byteNum;
		uint8_t bitNum;
		uint8_t mapBit;
		uint8_t i = 0;
		for( i = 0;i < HASHSIZE; i++)
		{
			byteNum = output[i]/8;
			bitNum = output[i]%8;
			mapBit = 0x80;
			mapBit = mapBit >> bitNum;
			BFilter[byteNum] = BFilter[byteNum] | mapBit;
		}
	}
	uint8_t verifyBF()
	{
		uint8_t byteNum;
		uint8_t bitNum;
		uint8_t testBit;
		uint8_t i = 0;
		uint8_t result;
		for( i = 0;i < HASHSIZE; i++)
		{
			byteNum = testHash[i]/8;
			bitNum = testHash[i]%8;
			testBit = 0x80;
			testBit = testBit >> bitNum;
			if (BFilter[byteNum] & testBit)
    				result = 1;
  			else
			{
    				result = 0;
				break;
			}	
		}
		return result;
	}
	void initBF()
	{
		uint8_t i =0;
		for(i = 0; i < BFlength; i++)
		{
			BFilter[i] = 0;
		}
	}
	event void Boot.booted()
	{
		uint8_t res;
		uint8_t i;
		initBF();
		init();
		createHash(input, output);
		mapToBF();
		for(i = 0; i < BFlength; i++)
		{
			dbg("BFC","BF[%d] = %d\n", i, BFilter[i]);
		}
		input[2]= 45;
		createHash(input, testHash);
		res = verifyBF();
		if(res == 1)
		dbg("BFC", "Bloom Filter verification passed\n");
		if(res == 0)
		dbg("BFC", "Bloom Filter verification failed\n");
	}

	
}
