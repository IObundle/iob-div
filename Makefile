SIM_DIR := simulation/icarus

sim:
	make -C $(SIM_DIR)

clean:
	make -C $(SIM_DIR) clean

.PHONY: sim clean
