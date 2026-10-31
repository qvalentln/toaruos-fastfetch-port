# fastfetch on ToaruOS: build environment

Helper files for cross-compiling [fastfetch](https://github.com/fastfetch-cli/fastfetch) to
[ToaruOS](https://github.com/klange/toaruos). The port itself is the `toaruos-port` branch of
https://github.com/qvalentln/fastfetch-toaru

Status: fastfetch builds and runs on ToaruOS 3.0 in QEMU. OS, kernel, uptime, shell, terminal,
CPU, memory, swap and locale work. Everything else is stubbed for now.

## Why these files exist

Fastfetch requires C23, but ToaruOS's cross-compiler is GCC 10.3. These files are local
compatibility shims for building anyway. They are not meant for upstream fastfetch or ToaruOS.

| File | Purpose |
|---|---|
| `c23-compat.h` | force-included header: `nullptr`, `auto`, local stand-ins for libc functions ToaruOS lacks (`strnlen`, `strcasestr`, `memmem`, `fnmatch`) |
| `toaru-gaps.h` | more gaps: `DT_*`, `dirfd`, `isblank`, `CLOCK_BOOTTIME`, `SCNx16` |
| `gcc10-compat.sh` | rewrites C23-only syntax in a copy of the source (fixed-type enums, unnamed parameters, `d_type`, the C23 gate) |
| `shim/` | empty or minimal replacement headers (`paths.h`, `fnmatch.h`, `sys/sysinfo.h`, `netinet/tcp.h`) |
| `toaru.cmake` | CMake toolchain file |
| `toaru-env.sh` | `PATH` and `LD_LIBRARY_PATH` for the toolchain |
| `build.sh` | sync, patch, configure, build |

## Reproducing the build

Requirements: Docker with the `toaruos/build-tools:1.99.x` image, the ToaruOS repo bind-mounted
at `/root/misaka`, and QEMU on the host. Inside the container you also need `rsync`, `python3`
and CMake 3.21 or newer (`pip3 install cmake`; the image ships 3.16).

1. Put this repo at `/root/misaka/ports` and clone the port next to it:
   `git clone -b toaruos-port https://github.com/qvalentln/fastfetch-toaru /root/misaka/ports/fastfetch-toaru`
2. `cd /root/misaka/ports && ./build.sh`. The binary is `ff-build/build-toaru/fastfetch`.
3. Copy it to `/root/misaka/base/bin/fastfetch`. First rebuild `util/local/bin/kuroko` inside the
   container (`make util/local/bin/kuroko`), because one built on a newer host won't run against
   the image's older glibc. Then run `make` in `/root/misaka`.
4. Boot `image.iso` in QEMU and run `fastfetch`.

## ToaruOS libc gaps found while porting

Missing functions: `strnlen`, `strcasestr`, `memmem`, `dirfd`, `getloadavg`, `posix_spawn`,
`fnmatch`, `if_nametoindex`, `getifaddrs`, `setmntent`, `inet_ntop`, `pthread_timedjoin_np`.

Missing headers: `utmpx.h`, `wordexp.h`, `spawn.h`, `paths.h`, `mntent.h`, `ifaddrs.h`,
`fnmatch.h`, `features.h`, `sys/sysinfo.h`, `netinet/tcp.h`.

Other: no `d_type` or `DT_*` in `struct dirent`; no `AF_INET6`, `AI_NUMERICSERV`, `SO_RCVBUF`,
`MSG_WAITALL`, `CLOCK_BOOTTIME` or `IF_NAMESIZE`.

## License

Fastfetch is MIT. These files are under the license added to this repository.
