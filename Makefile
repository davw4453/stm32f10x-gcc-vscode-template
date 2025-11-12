#######################################################
# Important:
# Modify the lines below defining: TOOLROOT and LIBROOT
#  to match their locations on your own computer!
#######################################################

#Comments start with '#'

# compilation flags for gcc and gas:
CFLAGS  = -O1 -g
ASFLAGS = -g 

# Build directory
BUILD_DIR=build

# Files used in the processor startup.
# They are executed before control is passed over to main:
STARTUP= $(BUILD_DIR)/startup_stm32f10x.o $(BUILD_DIR)/system_stm32f10x.o 

# Object files which contain the funcions that are required by the final binary:
# They are in no specific order.
OBJS=  $(STARTUP) $(BUILD_DIR)/main.o
OBJS += $(BUILD_DIR)/stm32f10x_gpio.o $(BUILD_DIR)/stm32f10x_rcc.o

# Names of output binary files. ELF is the default type output:
# (The file name is the name of the current directory.)
ELF=$(BUILD_DIR)/$(notdir $(CURDIR)).elf
# Map file shows where each function and variable are allocated in memory:
MAP_FILE=$(BUILD_DIR)/$(notdir $(CURDIR)).map
# The '.bin' file will be burned into the processor:
BIN_FILE=$(BUILD_DIR)/$(notdir $(CURDIR)).bin  

# Tool path. Where GCC executables (arm-none-eabi-gcc and others) are located.
# It can be explicitly specified as shown below:
#TOOLROOT=/home/onat/elektronik/ARM/Compiler/gcc-arm-none-eabi-4_9-2015q2/bin/
# OR it can be added to system PATH variable, like any other program. 
#  In this example it was added to the system PATH variable.

# GCC tools to be used to compile the code.
# If GCC directory is explicitly specified above, then uncomment the following:
#CC=$(TOOLROOT)/arm-none-eabi-gcc
#LD=$(TOOLROOT)/arm-none-eabi-gcc
#AR=$(TOOLROOT)/arm-none-eabi-ar
#AS=$(TOOLROOT)/arm-none-eabi-as
#OBJCOPY=$(TOOLROOT)/arm-none-eabi-objcopy

# OR, if added to the environment PATH variable, uncomment the following:
CC=arm-none-eabi-gcc
LD=arm-none-eabi-gcc
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
OBJCOPY=arm-none-eabi-objcopy

# Library path
# The STM supplied peripheral functions and definitions can be reached from the library directory root:
# (Please look around in the library directories to see what is there to use.
LIBROOT=/home/david/STM32F10x_Std

# Paths of various components in the library specified here:
DEVICE=$(LIBROOT)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x
CORE=$(LIBROOT)/Libraries/CMSIS/CM3/CoreSupport
PERIPH=$(LIBROOT)/Libraries/STM32F10x_StdPeriph_Driver
STARTUP_PATH=$(DEVICE)/startup/arm

# Search path for standard files
vpath %.c .
vpath %.s $(STARTUP_PATH)

# Search path for perpheral library
vpath %.c $(CORE)
vpath %.c $(PERIPH)/src
vpath %.c $(DEVICE)

# Uncomment for the specific processor. STM32F103 is a Medium Density 'MD' device.
# This defines the Proc. clock definition in file:
# STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/system_stm32f10x.c, which is eventually included.
PTYPE = STM32F10X_MD
# OR uncomment the next line if a Value Line device is used 'VL':
#PTYPE = STM32F10X_MD_VL  

# Similarly, the linker script for the processor used must be specified. 
LDSCRIPT = ./stm32f103.ld
#LDSCRIPT = ./stm32f100.ld

# Compilation Flags
FULLASSERT = -DUSE_FULL_ASSERT 

#LDFLAGS+= -T$(LDSCRIPT) -mthumb -mcpu=cortex-m3 
# Modify linker flags to include a map file:
LDFLAGS+= -T$(LDSCRIPT) -mthumb -mcpu=cortex-m3 -Wl,-Map=$(MAP_FILE)
CFLAGS+= -mcpu=cortex-m3 -mthumb 
CFLAGS+= -I$(DEVICE) -I$(CORE) -I$(PERIPH)/inc -I.
CFLAGS+= -D$(PTYPE) -DUSE_STDPERIPH_DRIVER $(FULLASSERT)

# Prepare the .bin binary file:
OBJCOPYFLAGS = -O binary

# Build executable 
$(BIN_FILE) : $(ELF)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

$(ELF) : $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS) $(LDFLAGS_POST)


# compile and generate dependency info

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) $< -o $@
	$(CC) -MM $(CFLAGS) $< > $(@:.o=.d)

$(BUILD_DIR)/%.o: %.s | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) $< -o $@

clean:
#rm -f $(OBJS) $(OBJS:.o=.d) $(ELF) $(MAP_FILE) startup_stm32f* $(CLEANOTHER)
	rm -rf $(BUILD_DIR)
	rm -f $(OBJS) $(OBJS:.o=.d) $(STARTUP) $(CLEANOTHER)

debug: $(ELF)
	arm-none-eabi-gdb $(ELF)


# pull in dependencies

-include $(OBJS:$(BUILD_DIR)/%.o=$(BUILD_DIR)/%.d)