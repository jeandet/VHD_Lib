SUBDIRS := $(shell find ./  -maxdepth 1 -mindepth 1 -type d)

all :

.PHONY: force


%:
	-for d in $(SUBDIRS); do (cd $$d; $(MAKE) $@ ); done

