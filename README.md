# DDR-BRAM Interface Design

## Overview

Achieving the most basic communication between DDR and BRAM with systemverilog. (Warning: only test with behavioral simulation)

## State Description

| State Index | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| ①           | Write data to DDR4 from outside & Fulfill DDR4 data initialization |
| ②           | Read just written data from DDR4 & Write them to BRAM0       |
| ③           | Read just written data from BRAM0 & Validate                 |
| ④           | Write new data to BRAM1                                      |
| ⑤           | Read just written data from BRAM1 & Write them to DDR4       |
| ⑥           | Read just written data from DDR4 & Validate                  |

## Module Description

| Module                    | Description                                                  |
| ------------------------- | ------------------------------------------------------------ |
| fm_add_top.sv             | Top module of the project. Module enable and done control    |
| ddr4_model.sv             | Simulation model of DDR4                                     |
| fm_add_BRAM_x.sv          | BRAM function description                                    |
| fm_add_bram_wr_rd.sv      | BRAM instantiation, including BRAM0 and BRAM1 with same configuration |
| fm_add_ddr_wrapper.sv     | Interface between MIG ip and ddr4_model                      |
| fm_add_ddr_wrapper_top.sv | DDR4 top instantiation                                       |
| fm_add_ddr_to_out.sv      | Interface between DDR4 and Outside. Responsible for state 1 and 6 |
| fm_add_ddr_to_bram.sv     | Interface between DDR4 and BRAM. Responsible for state 2 and 5 |
| fm_add_bram_to_out.sv     | Interface between BRAM and Outside. Responsible for state 3 and 4 |
| fm_add_p2s_x.sv           | parallel to sequential conversion module, used in state 5    |
| fm_add_s2p_x.sv           | sequential to parallel conversion module, used in state 2    |

## Details

Please refer to blog: [Vivado DDR4和BRAM交互调试经验分享 - George2024 - 博客园 (cnblogs.com)](https://www.cnblogs.com/georgelin/p/18013655)
