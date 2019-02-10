/*
 * delay.v
 *
 * Generates a delay line/bus
 *
 * Copyright (C) 2019  Sylvain Munaut <tnt@246tNt.com>
 * All rights reserved.
 *
 * BSD 3-clause, see LICENSE.bsd
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the <organization> nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * vim: ts=4 sw=4
 */

`ifdef SIM
`default_nettype none
`endif

// ---------------------------------------------------------------------------
// Single line delay
// ---------------------------------------------------------------------------

module delay_bit #(
	parameter integer DELAY = 1
)(
	input  wire d,
	output wire q,
	input  wire clk
);

	reg [DELAY-1:0] dl;

	always @(posedge clk)
		dl <= { dl[DELAY-2:0], d };

	assign q = dl[DELAY-1];

endmodule // delay_bit


// ---------------------------------------------------------------------------
// Bus delay
// ---------------------------------------------------------------------------

module delay_bus #(
	parameter integer DELAY = 1,
	parameter integer WIDTH = 1
)(
	input  wire [WIDTH-1:0] d,
	output wire [WIDTH-1:0] q,
	input  wire clk
);

	genvar i;
	reg [WIDTH-1:0] dl[0:DELAY-1];

	always @(posedge clk)
		dl[0] <= d;

	generate
		for (i=1; i<DELAY; i=i+1)
			always @(posedge clk)
				dl[i] <= dl[i-1];
	endgenerate

	assign q = dl[DELAY-1];

endmodule // delay_bus


// ---------------------------------------------------------------------------
// Toggle delay
// ---------------------------------------------------------------------------

module delay_toggle #(
	parameter integer DELAY = 1
)(
	input  wire d,
	output wire q,
	input  wire clk
);

	// FIXME: TODO

endmodule // delay_toggle
