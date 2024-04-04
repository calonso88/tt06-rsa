# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

def get_bit(value, bit_index):
  return value & (1 << bit_index)

def set_bit(value, bit_index):
  return value | (1 << bit_index)

def pull_cs_high(dut):
  dut.ui_in.value = dut.ui_in.value | (0x1)

def pull_cs_low(dut):
  dut.ui_in.value = dut.ui_in.value & ~(0x1)

def spi_clk_high(dut):
  dut.ui_in.value = dut.ui_in.value | (0x2)

def spi_clk_low(dut):
  dut.ui_in.value = dut.ui_in.value & ~(0x2)

def spi_mosi_high(dut):
  dut.ui_in.value = dut.ui_in.value | (0x4)

def spi_mosi_low(dut):
  dut.ui_in.value = dut.ui_in.value & ~(0x4)

def spi_miso_read(dut):
  return get_bit (dut.uo_out.value, 3)

async def spi_write (dut, address, data):
  
  pull_cs_low(dut)
  
  # Write command bit - bit 7 - MSBIT in first byte
  spi_mosi_high(dut)
  await ClockCycles(dut.clk, 10)
  spi_clk_high(dut)
  await ClockCycles(dut.clk, 10)
  spi_clk_low(dut)

  iterator = 1
  while iterator < 4:
    # Don't care - bit 6, bit 5, bit 4 and bit 3
    spi_mosi_low(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_low(dut)
    iterator += 1

  iterator = 2
  while iterator >= 0:
    # Address[iterator] - bit 2, bit 1 and bit 0
    address_bit = get_bit(address, iterator)
    if (address_bit == 0):
      spi_mosi_low(dut)
    else:
      spi_mosi_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_low(dut)
    iterator -= 1

  iterator = 7
  while iterator >= 0:
    # Data[iterator]
    data_bit = get_bit(data, iterator)
    if (data_bit == 0):
      spi_mosi_low(dut)
    else:
      spi_mosi_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_low(dut)
    iterator -= 1

  await ClockCycles(dut.clk, 10)
  pull_cs_high(dut)
  


async def spi_read (dut, address, data):
  
  pull_cs_low(dut)
  
  # Read command bit - bit 7 - MSBIT in first byte
  spi_mosi_low(dut)
  await ClockCycles(dut.clk, 10)
  spi_clk_high(dut)
  await ClockCycles(dut.clk, 10)
  spi_clk_low(dut)

  iterator = 1
  while iterator < 4:
    # Don't care - bit 6, bit 5, bit 4 and bit 3
    spi_mosi_low(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_low(dut)
    iterator += 1
  
  iterator = 2
  while iterator >= 0:
    # Address[iterator] - bit 2, bit 1 and bit 0
    address_bit = get_bit(address, iterator)
    if (address_bit == 0):
      spi_mosi_low(dut)
    else:
      spi_mosi_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_low(dut)
    iterator -= 1

  miso_byte = 0
  miso_bit = 0

  iterator = 7
  while iterator >= 0:
    # Data[iterator]
    data_bit = get_bit(data, iterator)
    if (data_bit == 0):
      spi_mosi_low(dut)
    else:
      spi_mosi_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_high(dut)
    miso_bit = spi_miso_read(dut)
    miso_byte = miso_byte | set_bit (miso_bit, iterator)
    await ClockCycles(dut.clk, 10)
    spi_clk_low(dut)
    iterator -= 1

  await ClockCycles(dut.clk, 10)
  pull_cs_high(dut)

  return miso_byte


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

  # Write reg[0] = 0xDE
  spi_write (dut, 0, 0xF0)
  # Write reg[1] = 0xDE
  spi_write (dut, 1, 0xDE)
  # Write reg[2] = 0xAD
  spi_write (dut, 2, 0xAD)
  # Write reg[3] = 0xBE
  spi_write (dut, 3, 0xBE)
  # Write reg[4] = 0xEF
  spi_write (dut, 4, 0xEF)
  # Write reg[5] = 0x55
  spi_write (dut, 5, 0x55)
  # Write reg[6] = 0xAA
  spi_write (dut, 6, 0xAA)
  # Write reg[7] = 0x55
  spi_write (dut, 7, 0x0F)
  
  # Read reg[0]
  reg0 = spi_read (dut, 0, 0x00)
  # Read reg[1]
  reg1 = spi_read (dut, 1, 0x00)
  # Read reg[2]
  reg2 = spi_read (dut, 2, 0x00)
  # Read reg[3]
  reg3 = spi_read (dut, 3, 0x00)
  # Read reg[4]
  reg4 = spi_read (dut, 4, 0x00)
  # Read reg[5]
  reg5 = spi_read (dut, 5, 0x00)
  # Read reg[6]
  reg6 = spi_read (dut, 6, 0x00)
  # Read reg[7]
  reg7 = spi_read (dut, 7, 0x00)

  await ClockCycles(dut.clk, 100)

  assert reg0 == 0xF0
  assert reg1 == 0xDE
  assert reg2 == 0xAD
  assert reg3 == 0xBE
  assert reg4 == 0xEF
  assert reg5 == 0x55
  assert reg6 == 0xAA
  assert reg7 == 0x0F

  await ClockCycles(dut.clk, 10)