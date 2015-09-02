# Sources
ASM_SOURCES = $(wildcard *.s)
C_SOURCES   = $(wildcard *.c)

# Targets
OBJS = $(ASM_SOURCES:.s=.o) $(C_SOURCES:.c=.o)
ELF=$(notdir $(CURDIR)).elf                    
HEX=$(notdir $(CURDIR)).hex                    

# Tools
GCC= arm-none-eabi-gcc
CC = $(GCC) -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -DSTM32F401xE
LD = $(CC) -TSTM32_f401re.ld 
CP = arm-none-eabi-objcopy
SZ = arm-none-eabi-size
HX = $(CP) -O ihex

# Libraries
LIBROOT=/home/frank/STM32Cube_FW_F4_V1.7.0
LIBS = -lc -lnosys

# Includes
DEVICE=$(LIBROOT)/Drivers/CMSIS/Device/ST/STM32F4xx
CORE=$(LIBROOT)/Drivers/CMSIS
INC = -I$(DEVICE)/Include -I$(CORE)/Include
                              
# Build executable
%.o: %.c
	$(CC) -g -c $(INC) $< -o $@

%.o: %.s
	$(CC) -g -c $< -o $@

$(HEX): $(ELF)
	$(HX) $< $@

$(ELF) : $(OBJS)
	$(LD) $(LIBS) $(OBJS) -o $@
	$(SZ) $@

clean:
	rm -f $(OBJS) $(ELF) $(HEX)

print-%:
	@echo $* = $($*)

