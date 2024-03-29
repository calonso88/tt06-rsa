<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project consists of an 8-bit RSA verilog design that implements the RSA (https://en.wikipedia.org/wiki/RSA_(cryptosystem)) encryption/decryption scheme with an 8-bit private/public key size.

The design implements modular exponentiation (https://en.wikipedia.org/wiki/Modular_exponentiation) through a series of Montgomery modular multiplication (https://en.wikipedia.org/wiki/Montgomery_modular_multiplication) operations to encrypt a message using an 8-bit key.

A SPI interface is used to interface the design due a limited number of I/O availables in the TinyTapeout project.

## How to test

You can test this project with ...

## External hardware

You may need to write SW to insert data through SPI to the design ...
