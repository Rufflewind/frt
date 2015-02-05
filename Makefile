.POSIX:
.SUFFIXES:

PREFIX=/usr/local

ARFLAGS=-cru
CPPFLAGS=-DNDEBUG -D_XOPEN_SOURCE=500
CFLAGS=-g -O3 -mtune=native\
       -Wall -Wconversion -pedantic -std=c99

all: dist/lib/libfrt.a

clean:
	rm -fr dist

doc:
	. tools/conf && doc_init dist/share/doc/frt
	doxygen

doc-upload: doc
	. tools/conf && doc_upload dist/share/doc/frt

.PHONY: all clean doc doc-upload

dist/lib/libfrt.a: dist/tmp/os.o
	mkdir -p `dirname $@`
	$(AR) $(ARFLAGS) $@ dist/tmp/os.o

dist/include/frt/config.h: include/frt/config.h tools/conf
	mkdir -p `dirname $@`
	head >$@.tmp -n 2 include/frt/config.h
	. tools/conf && \
	    cc() { $(CC) $(CPPFLAGS) $(CFLAGS) "$$@"; } && \
	    detect_limits >>$@.tmp signed off_t RF_OFF sys/types.h
	tail >>$@.tmp -n +3 include/frt/config.h
	mv -f $@.tmp $@

dist/include/frt/math.h: include/frt/math.h
	mkdir -p `dirname $@`
	cp -f include/frt/math.h $@

dist/include/frt/os.h: include/frt/os.h
	mkdir -p `dirname $@`
	cp -f include/frt/os.h $@

dist/include/frt/os_posix.inl: include/frt/os_posix.inl
	mkdir -p `dirname $@`
	cp -f include/frt/os_posix.inl $@

dist/tmp/os.o: \
    src/os_posix.c \
    dist/include/frt/config.h \
    dist/include/frt/math.h \
    dist/include/frt/os.h \
    dist/include/frt/os_posix.inl
	mkdir -p `dirname $@`
	$(CC) $(CPPFLAGS) $(CFLAGS) -Idist/include -o $@ -c src/os_posix.c
