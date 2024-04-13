# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-License-Identifier: MIT
import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

def is_prime(num):
  if (num < 2) :
    return 0;
  else :
    # Iterate from 2 to n // 2
    for i in range(2, ((num // 2) + 1)) :
      # If num is divisible by any number between
      # 2 and n / 2, it is not prime
      if (num % i) == 0:
        #print(num, "is not a prime number")
        return 0
    
    return 1


def get_bit(value, bit_index):
  #cocotb.log.info(f"Into get_bit function")
  #cocotb.log.info(f"Value: {value}, Bit index: {bit_index}")
  temp = value & (1 << bit_index)
  #cocotb.log.info(f"Temp: {temp}")
  return temp

def set_bit(value, bit_index):
  #cocotb.log.info(f"Into set_bit function")
  #cocotb.log.info(f"Value: {value}, Bit index: {bit_index}")
  temp = value | (1 << bit_index)
  #cocotb.log.info(f"Temp: {temp}")
  return temp

def clear_bit(value, bit_index):
  #cocotb.log.info(f"Into clear_bit function")
  #cocotb.log.info(f"Value: {value}, Bit index: {bit_index}")
  temp = value & ~(1 << bit_index)
  #cocotb.log.info(f"Temp: {temp}")
  return temp

def pull_cs_high(dut):
  #dut.ui_in.value = 0x1
  #dut.ui_in.value = dut.ui_in.value | (0x1)
  #cocotb.log.info(f"Into pull_cs_high function")
  temp = set_bit(dut.ui_in.value, 0)
  #cocotb.log.info(f"Temp: {temp}")
  dut.ui_in.value = temp

def pull_cs_low(dut):
  #dut.ui_in.value = 0x0
  #dut.ui_in.value = dut.ui_in.value & ~(0x1)
  #cocotb.log.info(f"Into pull_cs_low function")
  temp = clear_bit(dut.ui_in.value, 0)
  #cocotb.log.info(f"Temp: {temp}")
  dut.ui_in.value = temp

def spi_clk_high(dut):
  #dut.ui_in.value = 0x2
  #dut.ui_in.value = dut.ui_in.value | (0x2)
  #cocotb.log.info(f"Into spi_clk_high function")
  temp = set_bit(dut.ui_in.value, 1)
  #cocotb.log.info(f"Temp: {temp}")
  dut.ui_in.value = temp

def spi_clk_low(dut):
  #dut.ui_in.value = 0x0
  #dut.ui_in.value = dut.ui_in.value & ~(0x2)
  #cocotb.log.info(f"Into spi_clk_low function")
  temp = clear_bit(dut.ui_in.value, 1)
  #cocotb.log.info(f"Temp: {temp}")
  dut.ui_in.value = temp

def spi_mosi_high(dut):
  #dut.ui_in.value = 0x4
  #dut.ui_in.value = dut.ui_in.value | (0x4)
  #cocotb.log.info(f"Into spi_mosi_high function")
  #cocotb.log.info(f"Input value: {dut.ui_in.value}")
  temp = set_bit(dut.ui_in.value, 2)
  #cocotb.log.info(f"Temp: {temp}")
  dut.ui_in.value = temp

def spi_mosi_low(dut):
  #dut.ui_in.value = 0x0
  #dut.ui_in.value = dut.ui_in.value & ~(0x4)
  #cocotb.log.info(f"Into spi_mosi_low function")
  temp = clear_bit(dut.ui_in.value, 2)
  #cocotb.log.info(f"Temp: {temp}")
  dut.ui_in.value = temp

def spi_miso_read(dut):
  #cocotb.log.info(f"Into spi_miso_read function")
  #cocotb.log.info(f"MISO VALUE: {dut.uo_out.value}")
  #cocotb.log.info(f"OUTPUT of function VALUE: { (get_bit (dut.uo_out.value, 3) >> 3)  }")
  return (get_bit (dut.uo_out.value, 3) >> 3)

async def spi_write (dut, address, data):
  
  await ClockCycles(dut.clk, 10)
  pull_cs_high(dut)
  await ClockCycles(dut.clk, 10)
  pull_cs_low(dut)
  await ClockCycles(dut.clk, 10)
  
  # Write command bit - bit 7 - MSBIT in first byte
  spi_mosi_high(dut)
  await ClockCycles(dut.clk, 10)
  spi_clk_high(dut)
  await ClockCycles(dut.clk, 10)
  spi_clk_low(dut)
  
  iterator = 0
  while iterator < 4:
    # Don't care - bit 6, bit 5, bit 4 and bit 3
    await ClockCycles(dut.clk, 10)
    spi_mosi_low(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_low(dut)
    iterator += 1

  iterator = 2
  while iterator >= 0:
    # Address[iterator] - bit 2, bit 1 and bit 0
    await ClockCycles(dut.clk, 10)
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
    await ClockCycles(dut.clk, 10)
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
  await ClockCycles(dut.clk, 10)  


async def spi_read (dut, address, data):
  
  await ClockCycles(dut.clk, 10)
  pull_cs_high(dut)
  await ClockCycles(dut.clk, 10)
  pull_cs_low(dut)
  await ClockCycles(dut.clk, 10)
  
  # Read command bit - bit 7 - MSBIT in first byte
  spi_mosi_low(dut)
  await ClockCycles(dut.clk, 10)
  spi_clk_high(dut)
  await ClockCycles(dut.clk, 10)
  spi_clk_low(dut)

  iterator = 0
  while iterator < 4:
    # Don't care - bit 6, bit 5, bit 4 and bit 3
    await ClockCycles(dut.clk, 10)
    spi_mosi_low(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_low(dut)
    iterator += 1
  
  iterator = 2
  while iterator >= 0:
    # Address[iterator] - bit 2, bit 1 and bit 0
    await ClockCycles(dut.clk, 10)
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
    await ClockCycles(dut.clk, 10)
    data_bit = get_bit(data, iterator)
    if (data_bit == 0):
      spi_mosi_low(dut)
    else:
      spi_mosi_high(dut)
    await ClockCycles(dut.clk, 10)
    spi_clk_high(dut)
    miso_bit = spi_miso_read(dut)
    miso_byte = miso_byte | (miso_bit << iterator)
    await ClockCycles(dut.clk, 10)
    spi_clk_low(dut)
    iterator -= 1

  await ClockCycles(dut.clk, 10)
  pull_cs_high(dut)
  await ClockCycles(dut.clk, 10)

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


  # Number of bits in implementation
  bits = 8
  max_value = (2 ** bits) - 1
  min_prime = 3
  max_upper_boundary = max_value // min_prime

  
  # ITERATIONS 
  iterations = 0
  
  while iterations < 4:

    while True:
      p = random.randint(min_prime, max_upper_boundary)
      p_is_prime = is_prime(p)
      q = random.randint(min_prime, max_upper_boundary)
      q_is_prime = is_prime(q)
      m = p * q
      #cocotb.log.info(f"RSA RANDOM, P: {p}, Q: {q}, M: {m}")
      if ( ( m <= max_value ) and ( p != q ) and ( p_is_prime == 1 ) and ( q_is_prime == 1 ) ):
        break

    phi_m = (p-1) * (q-1)
    #cocotb.log.info(f"RSA, P: {p}, Q: {q}, M: {m}, PHI(M): {phi_m}")
    
    while True:
      e = random.randint(min_prime, phi_m)
      e_is_prime = is_prime(e)
      if ( ( e < phi_m ) and ( e_is_prime == 1 ) ):
        break

    # DEBUG
    #p = 3
    #q = 11
    #m = p * q
    #phi_m = (p-1) * (q-1)
    #e = 7
    # DEBUG

    #d = invmod(e, phi_m)  ->  d*e == 1 mod phi_m
    d = pow(e, -1, phi_m)
    
    # Number of bits for RSA implementation
    hwbits = bits + 2
    # DEBUG
    #hwbits = 8 + 2
    # DEBUG
    
    # Montgomery constant
    const = (2 ** (2 * hwbits)) % m

    while True:
      plain_text = random.randint(0, m-1)
      if (plain_text != 0):
        break
    
    # DEBUG
    #plain_text = 0x1
    #plain_text = 0x2
    #plain_text = 0x58
    # DEBUG
    
    cocotb.log.info(f"RSA, P: {p}, Q: {q}, M: {m}, PHI(M): {phi_m}")
    cocotb.log.info(f"Public key: ( {e}, {m} )")
    cocotb.log.info(f"Private key: ( {d}, {m} )")
    cocotb.log.info(f"Montgomery constant: {const}")
    cocotb.log.info(f"Plain text: {plain_text}")

    # Write reg[2] ( plain_text )
    await spi_write (dut, 2, plain_text)
    # Write reg[3] ( e )
    await spi_write (dut, 3, e)
    # Write reg[4] ( M )
    await spi_write (dut, 4, m)
    # Write reg[5] ( const )
    await spi_write (dut, 5, const)

    # Write reg[1] (Start)
    await spi_write (dut, 1, 1)

    encrypted_text = ( plain_text ** e ) % m
    cocotb.log.info(f"Encrypted text: {encrypted_text}")

    decrypted_text = ( encrypted_text ** d ) % m
    cocotb.log.info(f"Decrypted text: {decrypted_text}")

    await ClockCycles(dut.clk, 500)

    # Read reg[6] ( encrypted_text_design )
    encrypted_text_design = await spi_read (dut, 6, 0x00)
    cocotb.log.info(f"Encrypted text design: {encrypted_text_design}")

    assert plain_text == decrypted_text
    # DEBUG
    assert encrypted_text_design == encrypted_text 
    # DEBUG

    # Write reg[0] = 0xF0
    await spi_write (dut, 0, 0xF0)
    # Write reg[1] = 0xDE
    await spi_write (dut, 1, 0xDE)
    # Write reg[2] = 0xAD
    await spi_write (dut, 2, 0xAD)
    # Write reg[3] = 0xBE
    await spi_write (dut, 3, 0xBE)
    # Write reg[4] = 0xEF
    await spi_write (dut, 4, 0xEF)
    # Write reg[5] = 0x55
    await spi_write (dut, 5, 0x55)
    # Write reg[6] = 0xAA
    await spi_write (dut, 6, 0xAA)
    # Write reg[7] = 0x0F
    await spi_write (dut, 7, 0x0F)
  
    # Read reg[0]
    reg0 = await spi_read (dut, 0, 0x00)
    # Read reg[1]
    reg1 = await spi_read (dut, 1, 0x00)
    # Read reg[2]
    reg2 = await spi_read (dut, 2, 0x00)
    # Read reg[3]
    reg3 = await spi_read (dut, 3, 0x00)
    # Read reg[4]
    reg4 = await spi_read (dut, 4, 0x00)
    # Read reg[5]
    reg5 = await spi_read (dut, 5, 0x00)
    # Read reg[6]
    reg6 = await spi_read (dut, 6, 0x00)
    # Read reg[7]
    reg7 = await spi_read (dut, 7, 0x00)

    await ClockCycles(dut.clk, 10)

    #assert reg0 == 0xF0
    assert reg1 == 0xDE
    assert reg2 == 0xAD
    assert reg3 == 0xBE
    assert reg4 == 0xEF
    assert reg5 == 0x55
    #assert reg6 == 0xAA
    assert reg7 == 0x0F


    iterations = iterations + 1

  await ClockCycles(dut.clk, 10)

  await ClockCycles(dut.clk, 10)