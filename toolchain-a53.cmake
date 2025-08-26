# toolchain-a53.cmake
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CROSS aarch64-none-elf)
set(CMAKE_C_COMPILER   ${CROSS}-gcc)
set(CMAKE_AR           ${CROSS}-ar)
set(CMAKE_RANLIB       ${CROSS}-ranlib)
set(CMAKE_ASM_COMPILER ${CROSS}-gcc)

set(CPU_FLAGS "-mcpu=cortex-a53")
set(CMAKE_C_FLAGS_INIT   "${CPU_FLAGS} -ffunction-sections -fdata-sections -fno-builtin -g -O2")
set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--gc-sections")
