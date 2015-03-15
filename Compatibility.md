# Introduction #

The following list details Macifom's compatibility status with various free and commercial programs. Please contribute your own test results.

Last Updated for v0.14

# Details #

(CPU Test Programs)
  * Kevtris' nestest.nes - Passes for all legal opcodes.
  * Blargg's NES CPU Test 5 - Passes for legal opcodes.
  * Blargg's CPU Timing Test 6 - Passes for legal opcodes.
  * Branch Basics (Blargg's Branch Timing Tests) - Passes.
  * Backward Branches (Blargg's Branch Timing Tests) - Passes.
  * Forward Branches (Blargg's Branch Timing Tests) - Passes.
  * Blargg's CLI Latency Test - Fails (#3).

(PPU Test Programs)
  * Palette RAM (Blargg's PPU Tests 2005-09-15b) - Passes.
  * Power-up Palette (Blargg's PPU Tests 2005-09-15b) - Fails (#2) (Palette values are initialized differently).
  * Sprite RAM (Blargg's PPU Tests 2005-09-15b) - Passes.
  * VBL Clear Time (Blargg's PPU Tests 2005-09-15b) - Passes.
  * VRAM Access (Blargg's PPU Tests 2005-09-15b) - Passes.
  * Sprite 0 Hit Basics (Blargg's Sprite Hit Tests 2005-10-05)  - Passes.
  * Sprite 0 Hit Alignment (Blargg's Sprite Hit Tests 2005-10-05) - Passes.
  * Sprite 0 Hit Corners (Blargg's Sprite Hit Tests 2005-10-05) - Passes.
  * Sprite 0 Hit Flip (Blargg's Sprite Hit Tests 2005-10-05) - Passes.
  * Sprite 0 Hit Left Clip (Blargg's Sprite Hit Tests 2005-10-05) - Passes.
  * Sprite 0 Hit Right Edge (Blargg's Sprite Hit Tests 2005-10-05) - Passes.
  * Sprite 0 Hit Screen Bottom (Blargg's Sprite Hit Tests 2005-10-05) - Passes.
  * Sprite 0 Hit Double Height (Blargg's Sprite Hit Tests 2005-10-05) - Passes.
  * Sprite 0 Hit Timing Basics (Blargg's Sprite Hit Tests 2005-10-05) - Fails (#9).
  * Sprite 0 Hit Order (Blargg's Sprite Hit Tests 2005-10-05) - Passes.
  * Sprite 0 Hit Edge Timing (Blargg's Sprite Hit Tests 2005-10-05) - Passes.
  * Blargg's Sprite 0 Hit Timing - Passes.
  * Sprite Overflow Basics (Blargg's Sprite Overflow Tests) - Passes.
  * Sprite Overflow Details (Blargg's Sprite Overflow Tests) - Passes.
  * Sprite Overflow Timing (Blargg's Sprite Overflow Tests) - Fails (#5).
  * Sprite Overflow Obscure (Blargg's Sprite Overflow Tests) - Fails (#2).
  * Sprite Overflow Emulation (Blargg's Sprite Overflow Tests) - Passes.
  * Frame Basics (Blargg's VBL/NMI Tests) - Passes.
  * VBL Timing (Blargg's VBL/NMI Tests) - Passes.
  * Even / Odd Frames (Blargg's VBL/NMI Tests) - Passes.
  * VBL Clear Timing (Blargg's VBL/NMI Tests) - Fails (#4).
  * NMI Suppression (Blargg's VBL/NMI Tests) - Fails (#3).
  * NMI Disable (Blargg's VBL/NMI Tests) - Fails (#2).
  * NMI Timing (Blargg's VBL/NMI Tests) - Fails (#8).
  * scanline.nes - All tests fail due to lack of partial scanline rendering.

(Commercial Programs)
Awaiting User Contributions