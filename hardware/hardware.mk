#add itself to MODULES list
MODULES+=$(shell make -C $(DIV_DIR) corename | grep -v make)
