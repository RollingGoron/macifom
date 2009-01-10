//
//  NESCartridgeEmulator.m
//  Innuendo
//
//  Created by Auston Stewart on 7/27/08.
//  Copyright 2008 Apple, Inc.. All rights reserved.
//

#import "NESCartridgeEmulator.h"

static const char *mapperDescriptions[256] = { "No mapper", "Nintendo MMC1", "UNROM switch", "CNROM switch", "Nintendo MMC3", "Nintendo MMC5", "FFE F4xxx", "AOROM switch",
												"FFE F3xxx", "Nintendo MMC2", "Nintendo MMC4", "ColorDreams", "FFE F6xxx", "CPROM switch", "Unknown Mapper", "100-in-1 switch",
												"Bandai", "FFE F8xxx", "Jaleco SS8806", "Namcot 106", "Nintendo DiskSystem", "Konami VRC4a", "Konami VRC2a (1)", "Konami VRC2a (2)",
												"Konami VRC6", "Konami VRC4b", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Irem G-101", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper",
												"Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper", "Unknown Mapper" };

@implementation NESCartridgeEmulator

@synthesize romFileDidLoad = _romFileDidLoad, hasTrainer = _hasTrainer, usesVerticalMirroring = _usesVerticalMirroring, usesBatteryBackedRAM = _usesBatteryBackedRAM, usesFourScreenVRAMLayout = _usesFourScreenVRAMLayout, isPAL = _isPAL, mapperNumber = _mapperNumber, numberOfPRGROMBanks = _numberOfPRGROMBanks, numberOfCHRROMBanks = _numberOfCHRROMBanks, numberOfRAMBanks = _numberOfRAMBanks;

- (void)_cleanUpPRGROMMemory
{
	uint_fast8_t bank;
	
	if (_prgromBanks == NULL) return;
	
	for (bank = 0; bank < _numberOfPRGROMBanks; bank++) {
	
		free(_prgromBanks[bank]);
	}
	
	free(_prgromBanks);
	_prgromBanks = NULL;
}

- (void)_cleanUpCHRROMMemory
{
	uint_fast8_t bank;
	
	if (_chrromBanks == NULL) return;
	
	for (bank = 0; bank < _numberOfCHRROMBanks; bank++) {
		
		free(_chrromBanks[bank]);
	}
	
	free(_chrromBanks);
	_chrromBanks = NULL;
}

- (void)_cleanUpTrainerMemory
{
	if (_trainer == NULL) return;
	free(_trainer);
}

- (id)init
{
	[super init];
	
	_prgromBanks = NULL;
	_chrromBanks = NULL;
	_prgromBank0 = NULL;
	_prgromBank1 = NULL;
	_patternTable0 = NULL;
	_patternTable1 = NULL;
	_trainer = NULL;
	
	_usesVerticalMirroring = NO;
	_hasTrainer = NO;
	_usesBatteryBackedRAM = NO;
	_usesFourScreenVRAMLayout = NO;
	_isPAL = NO;
	
	_mapperNumber = 0;
	_numberOfPRGROMBanks = 0;
	_numberOfCHRROMBanks = 0;
	_numberOfRAMBanks = 0;
	_romFileDidLoad = NO;
	
	_controllerRead = 0; // FIXME: Controller faking hijinx!
	
	return self;
}

- (void)dealloc
{
	[self _cleanUpPRGROMMemory];
	[self _cleanUpCHRROMMemory];
	[self _cleanUpTrainerMemory];
	
	[super dealloc];
}

- (void)_setROMPointers
{
	if (_numberOfPRGROMBanks == 1) {
	
		_prgromBank0 = _prgromBanks[0];
		_prgromBank1 = _prgromBanks[0];
	}
	else if (_numberOfPRGROMBanks > 1) {
	
		_prgromBank0 = _prgromBanks[0];
		_prgromBank1 = _prgromBanks[1];
	}

	// FIXME: More sophisticated logic will be required for mappers.
	_patternTable0 = _chrromBanks[0];
	_patternTable1 = _chrromBanks[0] + 4096;
}

- (BOOL)_loadiNESROMOptions:(NSData *)header
{
	if ([header length] < 16) return NO;
	
	uint8_t lowerOptionsByte = *((uint8_t *)[header bytes]+6);
	uint8_t higherOptionsByte = *((uint8_t *)[header bytes]+7);
	uint8_t ramBanksByte = *((uint8_t *)[header bytes]+8);
	uint8_t videoModeByte = *((uint8_t *)[header bytes]+9);
	uint8_t count, highBytesSum = 0;
	
	// Detect headers with junk in bytes 9-15 and zero out bytes 7 and higher, assuming earlier iNES format
	for (count = 10; count < 16; count++) highBytesSum += *((uint8_t *)[header bytes]+count);
	if (highBytesSum != 0) {
	
		higherOptionsByte = 0;
		ramBanksByte = 1; // Let's assume that this is in the earlier iNES format and 1kB of RAM is implied
		videoModeByte = 0;
	}
	
	_numberOfPRGROMBanks = *((uint8_t *)[header bytes]+4);
	_numberOfCHRROMBanks = *((uint8_t *)[header bytes]+5);
	_numberOfRAMBanks = ramBanksByte; // Fayzullin's docs say to assume 1x8kB RAM when zero to account for earlier format
	
	_usesVerticalMirroring = (lowerOptionsByte & 1) ? YES : NO;
	_usesBatteryBackedRAM = (lowerOptionsByte & (1 << 1)) ? YES : NO;
	_hasTrainer = (lowerOptionsByte & (1 << 2)) ? YES : NO;
	_usesFourScreenVRAMLayout = (lowerOptionsByte & (1 << 3)) ? YES : NO;
	_isPAL = videoModeByte ? YES : NO;
	
	_mapperNumber = ((lowerOptionsByte & 0xF0) >> 4) + (higherOptionsByte & 0xF0);
	
	return YES;
}

- (BOOL)_loadiNESFileAtPath:(NSString *)path
{
	uint_fast8_t bank;
	NSData *rom;
	BOOL loadErrorOccurred = NO;
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	
	if (fileHandle == nil) return NO; // Return NO if no file was found
	
	NSData *header = [fileHandle readDataOfLength:16]; // Attempt to load 16 byte iNES Header
	
	// File format validation, must be iNES
	// Should check if the file is 4 chars long, need to figure out fourth char in header format
	if ((*((const char *)[header bytes]) != 'N') || (*((const char *)[header bytes]+1) != 'E') || (*((const char *)[header bytes]+2) != 'S')) return NO;
	
	// Blast existing memory
	[self _cleanUpPRGROMMemory];
	[self _cleanUpCHRROMMemory];
	
	// Load ROM Options
	if (![self _loadiNESROMOptions:header]) return NO;
	
	// Extract Trainer If Present
	if (_hasTrainer) {
	
		if (_trainer == NULL) _trainer = (uint8_t *)malloc(sizeof(uint8_t)*512);
		NSData *trainer = [fileHandle readDataOfLength:512];
		[trainer getBytes:_trainer];
	}
	
	// Extract PRGROM Banks
	_prgromBanks = (uint8_t **)malloc(sizeof(uint8_t*)*_numberOfPRGROMBanks);
	for (bank = 0; bank < _numberOfPRGROMBanks; bank++) {
	
		_prgromBanks[bank] = (uint8_t *)malloc(sizeof(uint8_t)*16384);
		rom = [fileHandle readDataOfLength:16384]; // PRG-ROMs have 16kB banks
		if ([rom length] != 16384) loadErrorOccurred = YES;
		else [rom getBytes:_prgromBanks[bank]];
	}
	
	// Extract CHRROM Banks
	_chrromBanks = (uint8_t **)malloc(sizeof(uint8_t*)*_numberOfCHRROMBanks);
	for (bank = 0; bank < _numberOfCHRROMBanks; bank++) {
		
		_chrromBanks[bank] = (uint8_t *)malloc(sizeof(uint8_t)*8192);
		rom = [fileHandle readDataOfLength:8192]; // CHR-ROMs have 8kB banks
		if ([rom length] != 8192) loadErrorOccurred = YES;
		else [rom getBytes:_chrromBanks[bank]];
	}
	
	// FIXME: Always allocating SRAM, because I'm not sure how to detect it yet
	_sram = (uint8_t *)malloc(sizeof(uint8_t)*8192);
	
	// Close ROM file
	[fileHandle closeFile];
	
	// Set ROM pointers
	[self _setROMPointers];
	
	return !loadErrorOccurred;
}

- (id)initWithiNESFileAtPath:(NSString *)path
{
	[super init];
	
	_prgromBanks = NULL;
	_chrromBanks = NULL;
	_prgromBank0 = NULL;
	_prgromBank1 = NULL;
	_patternTable0 = NULL;
	_patternTable1 = NULL;
	_trainer = NULL;
	
	_usesVerticalMirroring = NO;
	_hasTrainer = NO;
	_usesBatteryBackedRAM = NO;
	_usesFourScreenVRAMLayout = NO;
	_isPAL = NO;
	
	_mapperNumber = 0;
	_numberOfPRGROMBanks = 0;
	_numberOfCHRROMBanks = 0;
	_numberOfRAMBanks = 0;
	_romFileDidLoad = [self _loadiNESFileAtPath:path];
	
	return self;
}

- (BOOL)loadROMFileAtPath:(NSString *)path
{
	return (_romFileDidLoad = [self _loadiNESFileAtPath:path]);
}

- (uint8_t)readByteFromPRGROM:(uint16_t)offset
{	
	if (offset < 0xC000) return _prgromBank0[offset-0x8000];
	return _prgromBank1[offset-0xC000];
}

- (uint16_t)readAddressFromPRGROM:(uint16_t)offset
{
	uint16_t address = [self readByteFromPRGROM:offset] + ((uint16_t)[self readByteFromPRGROM:offset+1] * 256); // Think little endian
	return address;
}

- (uint8_t)readByteFromCHRROM:(uint16_t)offset
{	
	if (offset < 0x1000) return _patternTable0[offset];
	return _patternTable1[offset-0x1000];
}

- (uint8_t)readByteFromSRAM:(uint16_t)address 
{
	return _sram[address & 0x1FFF];
}

- (uint8_t)readByteFromControlRegister:(uint16_t)address
{
	if (address == 0x4016) {
		// FIXME: Controller faking hijinx!
		// NSLog(@"Attempting to Read from Controller 1.");
		/*
		if (_controllerRead++ == 11) {
		
			NSLog(@"Returning 1!");
			return 1;
		 
		}
		 */
	}	
	
	return 0;
}

- (void)writeByte:(uint8_t)byte toSRAMwithCPUAddress:(uint16_t)address
{
	_sram[address & 0x1FFF] = byte;
	// NSLog(@"Writing byte to SRAM address 0x%4.4x",address);
}

- (NSString *)mapperDescription
{
	return [NSString stringWithCString:mapperDescriptions[_mapperNumber] encoding:NSASCIIStringEncoding];
}

- (uint8_t *)pointerToPRGROMBank0 
{
	return _prgromBank0;
}

- (uint8_t *)pointerToPRGROMBank1
{
	return _prgromBank1;
}

- (uint8_t *)pointerToCHRROMBank0
{
	return _patternTable0;
}

- (uint8_t *)pointerToCHRROMBank1
{
	return _patternTable1;
}

- (uint8_t *)pointerToSRAM
{
	return _sram;
}

@end