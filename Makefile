#
# Copyright (c) 2009 Mark Heily <mark@heily.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#
INSTALL=/usr/bin/install
SOURCES=filter.c kevent.c knote.c kqueue.c
MANS=kqueue.2
HEADERS=private.h
EXTRA_DIST=*.in README
SUBDIRS=os sys test
DISTFILES=Makefile configure
FILTERS=vnode.c timer.c signal.c socket.c user.c

include config.mk

build:
	gcc $(CFLAGS) -c *.c
	ar rcs libkqueue.a *.o
	gcc -shared -Wl,-soname,libkqueue.so -o libkqueue.so *.o

install:
	$(INSTALL) -d -m 755 $(INCLUDEDIR)/kqueue/sys
	$(INSTALL) -m 644 sys/event.h $(INCLUDEDIR)/kqueue/sys/event.h
	$(INSTALL) -m 644 libkqueue.so $(LIBDIR)/libkqueue.so
	$(INSTALL) -d -m 755 $(LIBDIR)/pkgconfig
	$(INSTALL) -m 644 libkqueue.pc $(LIBDIR)/pkgconfig
	$(INSTALL) -d -m 755 $(MANDIR)/man2
	$(INSTALL) -m 644 kqueue.2 $(MANDIR)/man2/kqueue.2
	$(INSTALL) -m 644 kqueue.2 $(MANDIR)/man2/kevent.2

uninstall:
	rm -f $(INCLUDEDIR)/kqueue/sys/event.h
	rm -f $(LIBDIR)/libkqueue.so 
	rm -f $(LIBDIR)/pkgconfig/libkqueue.pc 
	rm -f $(MANDIR)/man2/kqueue.2 
	rm -f $(MANDIR)/man2/kevent.2 
	rmdir $(INCLUDEDIR)/kqueue/sys $(INCLUDEDIR)/kqueue

check:
	cd test && ./configure && make check

dist:
	mkdir $(PROGRAM)-$(VERSION)
	cp  Makefile configure                            \
        $(SOURCES) $(MANS) $(HEADERS) $(EXTRA_DIST)   \
        $(PROGRAM)-$(VERSION)
	cp -R $(SUBDIRS) $(PROGRAM)-$(VERSION)
	rm -rf `find $(PROGRAM)-$(VERSION) -type d -name .svn`
	tar zcf $(PROGRAM)-$(VERSION).tar.gz $(PROGRAM)-$(VERSION)
	rm -rf $(PROGRAM)-$(VERSION)

publish-www:
	rm ~/public_html/libkqueue/*.html ; cp -R www/*.html ~/public_html/libkqueue/

clean:
	rm -f a.out *.a *.o *.so

distclean: clean
	rm -f *.tar.gz config.mk config.h libkqueue.pc $(FILTERS)
