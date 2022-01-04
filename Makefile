SIM_DIR := hardware/simulation

corename:
	@echo "DIV"

sim:
	make -C $(SIM_DIR)

sim-frac:
	make -C $(SIM_DIR) divfrac

clean:
	make -C $(SIM_DIR) clean

.PHONY: corename sim clean
