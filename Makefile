SRC = div_slice.v div.v div_tb.v

all : pipediv
	./pipediv

pipediv : $(SRC)
	iverilog -W all -o pipediv $(SRC)

clean: 
	rm pipediv *~ *.vcd

.PHONY: clean
