export CORE_ROOT=/home/muhammad/Desktop/PROCESSOR
all: icarus

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/main.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/main.output

clean:
	rm -rf temp
	