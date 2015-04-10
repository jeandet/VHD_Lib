#GRLIB=../../..
CC=gcc
XCC=sparc-elf-gcc -I$(GRLIB)/software/leon3 $(BOPT)
XAS=sparc-elf-gcc -c -I. -I$(GRLIB)/software/leon3 $(BOPT)

bootrom.o: bootrom.S bootrom.h
	$(XAS) $<
bootrom.exe: bootrom.o
	$(XCC) -nostdlib -Tlinkprom -N -L./ -Ttext=0 -nostartfiles -o bootrom.exe $<


make_bootrom : $(GRLIB)/bin/ahbrom.c
	@if test -r "/mingw/bin/gcc.exe"; then \
	  $(CC) $(GRLIB)/bin/ahbrom.c -o make_bootrom -lwsock32; \
	else \
	  $(CC) $(GRLIB)/bin/ahbrom.c -o make_bootrom; \
	fi;

bootrom.vhd: bootrom.exe
	make make_bootrom
	sparc-elf-objcopy -O binary bootrom.exe bootrom.bin
	./make_bootrom bootrom.bin bootrom.vhd
