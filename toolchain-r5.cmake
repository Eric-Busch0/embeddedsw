# toolchain-r5.cmake
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CROSS arm-none-eabi)
set(CMAKE_C_COMPILER   ${CROSS}-gcc)
set(CMAKE_AR           ${CROSS}-ar)
set(CMAKE_RANLIB       ${CROSS}-ranlib)
set(CMAKE_ASM_COMPILER ${CROSS}-gcc)

# Tune for Cortex-R5; adjust FPU/ABI to match your BSP
set(CPU_FLAGS "-mcpu=cortex-r5 -mthumb -mfpu=vfpv3-d16 -mfloat-abi=hard")

set(CMAKE_C_FLAGS_INIT   "${CPU_FLAGS} -ffunction-sections -fdata-sections -fno-builtin -g -O2")
set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--gc-sections")
