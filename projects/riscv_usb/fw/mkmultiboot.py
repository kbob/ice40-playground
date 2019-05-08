#!/usr/bin/env python3

import sys

"""
0		0x000000	Multiboot header
4k      0x001000	Bootloader FPGA Image
128k    0x020000	Bootloader Software image

256k    0x040000	Boot 1 FPGA Image
384k    0x060000	Boot 1 Software Image

512k    0x080000	Boot 2 FPGA Image
640k    0x0a0000	Boot 2 Softwar Image

768k    0x0c0000	Boot 3 FPGA Image
896k    0x0e0000	Boot 3 Software Image
"""


def hdr(mode, offset):
	return bytes([
		# Sync header
		0x7e, 0xaa, 0x99, 0x7e,

		# Boot mode
		0x92, 0x00, (0x01 if mode else 0x00),

		# Boot address
		0x44, 0x03,
			(offset >> 16) & 0xff,
			(offset >>  8) & 0xff,
			(offset >>  0) & 0xff,

		# Bank offset
		0x82, 0x00, 0x00,

		# Reboot
		0x01, 0x08,

		# Padding
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	])


offset_map = [
	(True,  0x001000),
	(False, 0x001000),
	(False, 0x040000),
	(False, 0x080000),
	(False, 0x0c0000),
]


if __name__ == '__main__':
	with open(sys.argv[1], 'wb') as fh:
		fh.write( b''.join([hdr(m, o) for m,o in offset_map]) )
