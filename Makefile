#Minimal makefile for Wlink
SHELL=/bin/bash

CONFIG		?= wav.wlink.Wlink1LaneAXI32bitConfig
OUTPUTDIR	?= $(CONFIG)
TEST_CONFIG	?= wav.wlink.AXI32bit1LaneWlinkTestConfig
TEST_OUTPUTDIR	?= $(TEST_CONFIG)



help:
	@echo "Wlink Generator Makefile"
	@echo ""
	@echo "CONFIG    = <package.Config> # Configuration used to generate make wlink"
	@echo "OUTPUTDIR = <outputdir/>     # Directory for output files of make wlink"
	@echo ""
	@echo "# To generate a single Wlink instance for design integration"
	@echo "make wlink CONFIG=<config> OUTPUTDIR=<outputdir>"

.PHONY: help 

wlink: 	
	@echo "Making Wlink with CONFIG: $(CONFIG) and saving to $(OUTPUTDIR)"
	sbt 'runMain wav.wlink.WlinkGen -o $(OUTPUTDIR) -c $(CONFIG)'

