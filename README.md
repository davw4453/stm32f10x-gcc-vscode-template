# STM32F10X-GCC-VSCODE-TEMPLATE
Provides a starting point to write and debug C and assembly programs for the STM32F10E-EVAL board in Microsoft VSCode. Tested with the STM3210E-EVAL board using the Segger J-link debugger on Fedora linux 42.


# Requirements
- OpenOCD installed
- arm-none-eabi GCC toolchain
- STM32F10x standard peripheral library from https://www.st.com/en/embedded-software/stsw-stm32054.html

# Building
Write your code as needed in the asm, src, and include folders. You can compile by issuing "make" or "make debug" for the debug target in a terminal in the project dirctory. Flash to your device by issuing "make flash". If you flash the debug target, it can be debugged by clicking the "start debugging" button in vscode. Issue "-exec memdump [address]" to examine memory in the debug console.
  

NOTE: This project is under development and not functional yet!

