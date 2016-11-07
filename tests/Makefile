SUBDIRS=Validation_IIR_f0_LFR \
    Validation_IIR_f1_LFR \
    Validation_LFR_Filters

SUBDIRS_distclean:=$(SUBDIRS)
SUBDIRS_test:=$(SUBDIRS)

.PHONY: distclean test $(SUBDIRS)

all:
	echo ""

test: $(SUBDIRS_test)

distclean: $(SUBDIRS_distclean)

$(SUBDIRS_distclean):
	$(MAKE) -C $@ distclean

$(SUBDIRS_test):
	$(MAKE) -C $@ test


