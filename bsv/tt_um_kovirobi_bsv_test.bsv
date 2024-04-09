/*
 * Copyright (c) 2024 Robert Kovacsics
 * SPDX-License-Identifier: Apache-2.0
 */

import FIFOF :: *;

interface TinyTapeout;
  (* always_ready, enable = "ena", prefix = "" *)
  method Action in(Bit#(8) ui_in, Bit#(8) uio_in);

  (* always_enabled, always_ready *)
  method ActionValue#(Bit#(8)) uo_out;

  (* always_enabled, always_ready *)
  method ActionValue#(Bit#(8)) uio_oe;
  (* always_enabled, always_ready *)
  method ActionValue#(Bit#(8)) uio_out;
endinterface: TinyTapeout

(* synthesize, clock_prefix = "clk", reset_prefix = "rst_n" *)
module tt_um_kovirobi_bsv_test (TinyTapeout);

  Wire#(Bit#(8)) ui_in_w <- mkWire;
  Wire#(Bit#(8)) uio_in_w <- mkWire;
  // A DWire (wire with default) will ensure the `uo_out` always has something
  // ready
  Wire#(Bit#(8)) uo_out_w <- mkDWire(0);

  FIFOF#(Bit#(8)) fifo <- mkSizedFIFOF(20); // FIFO 8 bits wide, 20 entries deep

  rule put;
    if (uio_in_w[0] == 1)
      fifo.enq(ui_in_w);
  endrule

  rule get;
    if (uio_in_w[0] == 0) begin
      uo_out_w <= fifo.first;
      fifo.deq;
    end
  endrule

  method Action in(Bit#(8) ui_in, Bit#(8) uio_in);
    ui_in_w <= ui_in;
    uio_in_w <= uio_in;
  endmethod

  method ActionValue#(Bit#(8)) uo_out;
    return uo_out_w;
  endmethod

  method ActionValue#(Bit#(8)) uio_oe;
    return 0;
  endmethod

  method ActionValue#(Bit#(8)) uio_out;
    return 0;
  endmethod

endmodule: tt_um_kovirobi_bsv_test
