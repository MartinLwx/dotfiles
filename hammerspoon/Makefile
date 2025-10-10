%.lua: %.fnl
	fennel --compile $< > $@

SRC := $(wildcard *.fnl)
OUT := $(patsubst %.fnl,%.lua,$(SRC))
all: $(OUT)
