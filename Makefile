SIM_DIR := hardware/simulation

sim:
	make -C $(SIM_DIR)

sim-frac:
	make -C $(SIM_DIR) divfrac

clean:
	make -C $(SIM_DIR) clean

.PHONY: sim clean
