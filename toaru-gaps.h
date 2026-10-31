/* More ToaruOS libc gaps, local build only. */
#ifndef FF_TOARU_GAPS_H
#define FF_TOARU_GAPS_H
#ifndef DT_UNKNOWN
#define DT_UNKNOWN 0
#define DT_DIR     4
#define DT_REG     8
#define DT_LNK     10
#endif
#ifndef SCNx16
#define SCNx16 "hx"
#endif
static inline int isblank(int c) { return c == ' ' || c == '\t'; }
#include <time.h>
#include <dirent.h>
#ifndef CLOCK_BOOTTIME
/* Only used by fastfetch's fallback when /proc/uptime is unreadable; value is not boot-relative. */
#define CLOCK_BOOTTIME CLOCK_REALTIME
#endif
/* ToaruOS libc has no dirfd(); -1 makes fstatat()/openat() fail, so callers take their "not found" path. */
static inline int dirfd(DIR* d) { (void) d; return -1; }
#endif
