hdlroot
=======

hdlroot is my root directory for the Verilog/VHDL code that I write. I decided to host it on git since that makes
things more convenient. This README will describe the general directory structure I've used (which will change as
I learn more about managing code more effectively) and will list current projects contained in this repository.

Directory Structure
===================


    |hdlroot---|  Root Directory
               |lib|  Contains HDL modules (IP) that would be used in multiple projects.
               |buffers-------|  Buffers/Memory models.
               |interfaceLogic|  Hardware Interface Logic.
               |clkgen--------|  Clock generators and dividers.
               |modules-------|  IP modules.
                              |<module name>| Contains the IP <module name>
                                            |design| Contains the design files
                                            |test--| Contains the testbench
                    

IP:
   1. UART: UART TX and RX modules wrapped into a single UART controller.

