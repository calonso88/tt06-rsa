# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_spi(dut):
  dut._log.info("Start")
  
  # Our example module doesn't use clock and reset, but we show how to use them here anyway.
  clock = Clock(dut.clk, 20, units="ns")
  cocotb.start_soon(clock.start())

  # Reset
  dut._log.info("Reset")
  dut.ena.value = 1
  dut.ui_in.value = 0
  dut.uio_in.value = 0
  dut.rst_n.value = 0
  await ClockCycles(dut.clk, 10)
  dut.rst_n.value = 1

  # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Test")
  
  # Assert high SPI_CS
  dut.ui_in.value = (0x1)
  await ClockCycles(dut.clk, 10)




  # Assert low SPI_CS, assert high SPI_MOSI bit 7
  dut.ui_in.value = (0x0 + 0x4)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 7, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 7, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x0)
  await ClockCycles(dut.clk, 10)



  # Assert low SPI_CS, assert low SPI_MOSI bit 6
  dut.ui_in.value = (0x0 + 0x0)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 6, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 6, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x0)
  await ClockCycles(dut.clk, 10)



  # Assert low SPI_CS, assert low SPI_MOSI bit 5
  dut.ui_in.value = (0x0 + 0x0)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 5, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 5, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x0)
  await ClockCycles(dut.clk, 10)



  # Assert low SPI_CS, assert low SPI_MOSI bit 4
  dut.ui_in.value = (0x0 + 0x0)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 4, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 4, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x0)
  await ClockCycles(dut.clk, 10)



  # Assert low SPI_CS, assert low SPI_MOSI bit 3
  dut.ui_in.value = (0x0 + 0x0)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 3, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 3, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x0)
  await ClockCycles(dut.clk, 10)


  # Assert low SPI_CS, assert low SPI_MOSI bit 2
  dut.ui_in.value = (0x0 + 0x0)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 2, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 2, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x0)
  await ClockCycles(dut.clk, 10)



  # Assert low SPI_CS, assert low SPI_MOSI bit 1
  dut.ui_in.value = (0x0 + 0x0)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 1, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 1, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x0)
  await ClockCycles(dut.clk, 10)



  # Assert low SPI_CS, assert low SPI_MOSI bit 0
  dut.ui_in.value = (0x0 + 0x0)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 0, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert low SPI_MOSI bit 0, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x0 + 0x0)
  await ClockCycles(dut.clk, 10)





  # Assert low SPI_CS, assert high SPI_MOSI bit 7
  dut.ui_in.value = (0x0 + 0x4)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 7, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 7, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x0)
  await ClockCycles(dut.clk, 10)



  # Assert low SPI_CS, assert high SPI_MOSI bit 6
  dut.ui_in.value = (0x0 + 0x4)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 6, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 6, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x0)
  await ClockCycles(dut.clk, 10)



  # Assert low SPI_CS, assert high SPI_MOSI bit 5
  dut.ui_in.value = (0x0 + 0x4)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 5, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 5, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x0)
  await ClockCycles(dut.clk, 10)




  # Assert low SPI_CS, assert high SPI_MOSI bit 4
  dut.ui_in.value = (0x0 + 0x4)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 4, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 4, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x0)
  await ClockCycles(dut.clk, 10)



  # Assert low SPI_CS, assert high SPI_MOSI bit 3
  dut.ui_in.value = (0x0 + 0x4)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 3, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 3, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x0)
  await ClockCycles(dut.clk, 10)


  # Assert low SPI_CS, assert high SPI_MOSI bit 2
  dut.ui_in.value = (0x0 + 0x4)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 2, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 2, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x0)
  await ClockCycles(dut.clk, 10)




  # Assert low SPI_CS, assert high SPI_MOSI bit 1
  dut.ui_in.value = (0x0 + 0x4)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 1, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 1, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x0)
  await ClockCycles(dut.clk, 10)




  # Assert low SPI_CS, assert high SPI_MOSI bit 0
  dut.ui_in.value = (0x0 + 0x4)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 0, assert high SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x2)
  await ClockCycles(dut.clk, 10)
  # Assert low SPI_CS, assert high SPI_MOSI bit 0, assert low SPI_CLK
  dut.ui_in.value = (0x0 + 0x4 + 0x0)
  await ClockCycles(dut.clk, 10)



  await ClockCycles(dut.clk, 1000)



#  assert dut.uo_out.value == 50

