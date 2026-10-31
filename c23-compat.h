/* Local shims for building fastfetch with GCC 10.3 against the ToaruOS libc.
   Not for upstream. */
#ifndef FF_TOARU_C23_COMPAT_H
#define FF_TOARU_C23_COMPAT_H

#include <stddef.h>
#include <stdalign.h>
#include <ctype.h>
#include <string.h>

#define nullptr ((void*)0)
#define auto __auto_type

/* --- ToaruOS libc gaps (missing from libc.so and headers) --- */
static inline size_t strnlen(const char *s, size_t maxlen) {
    size_t i = 0;
    while (i < maxlen && s[i]) i++;
    return i;
}

static inline char *strcasestr(const char *haystack, const char *needle) {
    if (!*needle) return (char *)haystack;
    for (; *haystack; haystack++) {
        const char *h = haystack, *n = needle;
        while (*h && *n && tolower((unsigned char)*h) == tolower((unsigned char)*n)) { h++; n++; }
        if (!*n) return (char *)haystack;
    }
    return NULL;
}


static inline void *memmem(const void* h, size_t hl, const void *n, size_t nl) {
	if(!nl) return (void*) h;
	for(const char* p = h; hl >= nl; p++, hl--) {
		if(!memcmp(p,n,nl)) return (void*) p;
		
	}
	return NULL;
}


#ifndef IF_NAMESIZE
#define IF_NAMESIZE 16
#endif

static inline int fnmatch(const char *p, const char *s, int flags) {
    (void)flags;
    if (!*p) return *s ? 1 : 0;
    if (*p == '*') {
        for (;; s++) { if (!fnmatch(p + 1, s, 0)) return 0; if (!*s) return 1; }
    }
    if (*s && (*p == '?' || *p == *s)) return fnmatch(p + 1, s + 1, 0);
    return 1;
}

#endif
