#makefile

PKG		= ../MASTER_AGENT/AHB_UVC_master_package.sv ../SLAVE_AGENT/AHB_UVC_slave_package.sv ../ENV/AHB_UVC_env_package.sv ../SEQ/AHB_UVC_seq_package.sv ../TEST/AHB_UVC_test_package.sv  ../TB/AHB_UVC_package.sv  
INCLUDE = +incdir+../INCLUDE +incdir+../SRC +incdir+../MASTER_AGENT +incdir+../SLAVE_AGENT +incdir+../ENV +incdir+../SEQ +incdir+../TEST +incdir+../TB
TOP 	= ../TB/AHB_UVC_top.sv
TOP_N 	= AHB_UVC_top

ifndef TEST
TEST:=AHB_UVC_sanity_test
endif

#To make a work file
lib:
	vlib work

#To compile the code
comp:
	vlog $(PKG) $(TOP) $(INCLUDE)

#To run the simulation in questasim
sim: comp 
	vsim -novopt -assertdebug  $(TOP_N) -do "do runsim.do" +UVM_TESTNAME=$(TEST)
	
#To run the simulation in command prompt
sim_c:comp
	vsim -novopt $(TOP_N) -c -do "do runsim.do" +UVM_TESTNAME=$(TEST) 
	
#+uvm_set_verbosity=uvm_test_top.ahb_main_env_h.ahb_env_h[0].ahb_master_agent_h.ahb_master_drv_h,UVM_HIGH
	