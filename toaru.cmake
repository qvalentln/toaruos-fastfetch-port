set(CMAKE_SYSTEM_NAME ToaruOS)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_C_COMPILER /root/gcc_local/bin/x86_64-pc-toaru-gcc)
set(CMAKE_SYSROOT /root/misaka/base)


set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_C_FLAGS_INIT "-I/root/misaka/ports/shim -include /root/misaka/ports/c23-compat.h -include /root/misaka/ports/toaru-gaps.h -fshort-enums")
