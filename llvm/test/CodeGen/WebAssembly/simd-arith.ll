; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -wasm-keep-registers -wasm-enable-unimplemented-simd -mattr=+simd128 | FileCheck %s --check-prefixes CHECK,SIMD128
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -wasm-keep-registers -wasm-enable-unimplemented-simd -mattr=+simd128 -fast-isel | FileCheck %s --check-prefixes CHECK,SIMD128
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -wasm-keep-registers -mattr=+simd128 | FileCheck %s --check-prefixes CHECK,SIMD128-VM
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -wasm-keep-registers -mattr=+simd128 -fast-isel | FileCheck %s --check-prefixes CHECK,SIMD128-VM
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -wasm-keep-registers -mattr=-simd128 | FileCheck %s --check-prefixes CHECK,NO-SIMD128
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -wasm-keep-registers -mattr=-simd128 -fast-isel | FileCheck %s --check-prefixes CHECK,NO-SIMD128

; Test that basic SIMD128 arithmetic operations assemble as expected.

target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

; ==============================================================================
; 16 x i8
; ==============================================================================
; CHECK-LABEL: add_v16i8:
; NO-SIMD128-NOT: i8x16
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i8x16.add $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <16 x i8> @add_v16i8(<16 x i8> %x, <16 x i8> %y) {
  %a = add <16 x i8> %x, %y
  ret <16 x i8> %a
}

; CHECK-LABEL: sub_v16i8:
; NO-SIMD128-NOT: i8x16
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i8x16.sub $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <16 x i8> @sub_v16i8(<16 x i8> %x, <16 x i8> %y) {
  %a = sub <16 x i8> %x, %y
  ret <16 x i8> %a
}

; CHECK-LABEL: mul_v16i8:
; NO-SIMD128-NOT: i8x16
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i8x16.mul $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <16 x i8> @mul_v16i8(<16 x i8> %x, <16 x i8> %y) {
  %a = mul <16 x i8> %x, %y
  ret <16 x i8> %a
}

; CHECK-LABEL: neg_v16i8:
; NO-SIMD128-NOT: i8x16
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i8x16.neg $push0=, $0{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <16 x i8> @neg_v16i8(<16 x i8> %x) {
  %a = sub <16 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0,
                      i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>,
                     %x
  ret <16 x i8> %a
}

; CHECK-LABEL: and_v16i8:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.and $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <16 x i8> @and_v16i8(<16 x i8> %x, <16 x i8> %y) {
  %a = and <16 x i8> %x, %y
  ret <16 x i8> %a
}

; CHECK-LABEL: or_v16i8:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.or $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <16 x i8> @or_v16i8(<16 x i8> %x, <16 x i8> %y) {
  %a = or <16 x i8> %x, %y
  ret <16 x i8> %a
}

; CHECK-LABEL: xor_v16i8:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.xor $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <16 x i8> @xor_v16i8(<16 x i8> %x, <16 x i8> %y) {
  %a = xor <16 x i8> %x, %y
  ret <16 x i8> %a
}

; CHECK-LABEL: not_v16i8:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.not $push0=, $0{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <16 x i8> @not_v16i8(<16 x i8> %x) {
  %a = xor <16 x i8> %x, <i8 -1, i8 -1, i8 -1, i8 -1,
                          i8 -1, i8 -1, i8 -1, i8 -1,
                          i8 -1, i8 -1, i8 -1, i8 -1,
                          i8 -1, i8 -1, i8 -1, i8 -1>
  ret <16 x i8> %a
}

; ==============================================================================
; 8 x i16
; ==============================================================================
; CHECK-LABEL: add_v8i16:
; NO-SIMD128-NOT: i16x8
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i16x8.add $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <8 x i16> @add_v8i16(<8 x i16> %x, <8 x i16> %y) {
  %a = add <8 x i16> %x, %y
  ret <8 x i16> %a
}

; CHECK-LABEL: sub_v8i16:
; NO-SIMD128-NOT: i16x8
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i16x8.sub $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <8 x i16> @sub_v8i16(<8 x i16> %x, <8 x i16> %y) {
  %a = sub <8 x i16> %x, %y
  ret <8 x i16> %a
}

; CHECK-LABEL: mul_v8i16:
; NO-SIMD128-NOT: i16x8
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i16x8.mul $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <8 x i16> @mul_v8i16(<8 x i16> %x, <8 x i16> %y) {
  %a = mul <8 x i16> %x, %y
  ret <8 x i16> %a
}

; CHECK-LABEL: neg_v8i16:
; NO-SIMD128-NOT: i16x8
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i16x8.neg $push0=, $0{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <8 x i16> @neg_v8i16(<8 x i16> %x) {
  %a = sub <8 x i16> <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>,
                     %x
  ret <8 x i16> %a
}

; CHECK-LABEL: and_v8i16:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.and $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <8 x i16> @and_v8i16(<8 x i16> %x, <8 x i16> %y) {
  %a = and <8 x i16> %x, %y
  ret <8 x i16> %a
}

; CHECK-LABEL: or_v8i16:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.or $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <8 x i16> @or_v8i16(<8 x i16> %x, <8 x i16> %y) {
  %a = or <8 x i16> %x, %y
  ret <8 x i16> %a
}

; CHECK-LABEL: xor_v8i16:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.xor $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <8 x i16> @xor_v8i16(<8 x i16> %x, <8 x i16> %y) {
  %a = xor <8 x i16> %x, %y
  ret <8 x i16> %a
}

; CHECK-LABEL: not_v8i16:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.not $push0=, $0{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <8 x i16> @not_v8i16(<8 x i16> %x) {
  %a = xor <8 x i16> %x, <i16 -1, i16 -1, i16 -1, i16 -1,
                          i16 -1, i16 -1, i16 -1, i16 -1>
  ret <8 x i16> %a
}

; ==============================================================================
; 4 x i32
; ==============================================================================
; CHECK-LABEL: add_v4i32:
; NO-SIMD128-NOT: i32x4
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i32x4.add $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x i32> @add_v4i32(<4 x i32> %x, <4 x i32> %y) {
  %a = add <4 x i32> %x, %y
  ret <4 x i32> %a
}

; CHECK-LABEL: sub_v4i32:
; NO-SIMD128-NOT: i32x4
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i32x4.sub $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x i32> @sub_v4i32(<4 x i32> %x, <4 x i32> %y) {
  %a = sub <4 x i32> %x, %y
  ret <4 x i32> %a
}

; CHECK-LABEL: mul_v4i32:
; NO-SIMD128-NOT: i32x4
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i32x4.mul $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x i32> @mul_v4i32(<4 x i32> %x, <4 x i32> %y) {
  %a = mul <4 x i32> %x, %y
  ret <4 x i32> %a
}

; CHECK-LABEL: neg_v4i32:
; NO-SIMD128-NOT: i32x4
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i32x4.neg $push0=, $0{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x i32> @neg_v4i32(<4 x i32> %x) {
  %a = sub <4 x i32> <i32 0, i32 0, i32 0, i32 0>, %x
  ret <4 x i32> %a
}

; CHECK-LABEL: and_v4i32:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.and $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x i32> @and_v4i32(<4 x i32> %x, <4 x i32> %y) {
  %a = and <4 x i32> %x, %y
  ret <4 x i32> %a
}

; CHECK-LABEL: or_v4i32:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.or $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x i32> @or_v4i32(<4 x i32> %x, <4 x i32> %y) {
  %a = or <4 x i32> %x, %y
  ret <4 x i32> %a
}

; CHECK-LABEL: xor_v4i32:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.xor $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x i32> @xor_v4i32(<4 x i32> %x, <4 x i32> %y) {
  %a = xor <4 x i32> %x, %y
  ret <4 x i32> %a
}

; CHECK-LABEL: not_v4i32:
; NO-SIMD128-NOT: v128
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.not $push0=, $0{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x i32> @not_v4i32(<4 x i32> %x) {
  %a = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %a
}

; ==============================================================================
; 2 x i64
; ==============================================================================
; CHECK-LABEL: add_v2i64:
; NO-SIMD128-NOT: i64x2
; SIMD128-VM-NOT: i64x2
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i64x2.add $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x i64> @add_v2i64(<2 x i64> %x, <2 x i64> %y) {
  %a = add <2 x i64> %x, %y
  ret <2 x i64> %a
}

; CHECK-LABEL: sub_v2i64:
; NO-SIMD128-NOT: i64x2
; SIMD128-VM-NOT: i64x2
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i64x2.sub $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x i64> @sub_v2i64(<2 x i64> %x, <2 x i64> %y) {
  %a = sub <2 x i64> %x, %y
  ret <2 x i64> %a
}

; v2i64.mul is not in spec
; CHECK-LABEL: mul_v2i64:
; NO-SIMD128-NOT: i64x2
; SIMD128-VM-NOT: i64x2
; SIMD128-NOT: i64x2.mul
; SIMD128: i64x2.extract_lane
; SIMD128: i64.mul
define <2 x i64> @mul_v2i64(<2 x i64> %x, <2 x i64> %y) {
  %a = mul <2 x i64> %x, %y
  ret <2 x i64> %a
}

; CHECK-LABEL: neg_v2i64:
; NO-SIMD128-NOT: i64x2
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i64x2.neg $push0=, $0{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x i64> @neg_v2i64(<2 x i64> %x) {
  %a = sub <2 x i64> <i64 0, i64 0>, %x
  ret <2 x i64> %a
}

; CHECK-LABEL: and_v2i64:
; NO-SIMD128-NOT: v128
; SIMD128-VM-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.and $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x i64> @and_v2i64(<2 x i64> %x, <2 x i64> %y) {
  %a = and <2 x i64> %x, %y
  ret <2 x i64> %a
}

; CHECK-LABEL: or_v2i64:
; NO-SIMD128-NOT: v128
; SIMD128-VM-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.or $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x i64> @or_v2i64(<2 x i64> %x, <2 x i64> %y) {
  %a = or <2 x i64> %x, %y
  ret <2 x i64> %a
}

; CHECK-LABEL: xor_v2i64:
; NO-SIMD128-NOT: v128
; SIMD128-VM-NOT: v128
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.xor $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x i64> @xor_v2i64(<2 x i64> %x, <2 x i64> %y) {
  %a = xor <2 x i64> %x, %y
  ret <2 x i64> %a
}

; CHECK-LABEL: not_v2i64:
; NO-SIMD128-NOT: v128
; SIMD128-VM-NOT: v128
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: v128.not $push0=, $0{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x i64> @not_v2i64(<2 x i64> %x) {
  %a = xor <2 x i64> %x, <i64 -1, i64 -1>
  ret <2 x i64> %a
}

; ==============================================================================
; 4 x float
; ==============================================================================
; CHECK-LABEL: neg_v4f32:
; NO-SIMD128-NOT: f32x4
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f32x4.neg $push0=, $0{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x float> @neg_v4f32(<4 x float> %x) {
  %a = fsub <4 x float> <float 0., float 0., float 0., float 0.>, %x
  ret <4 x float> %a
}

; CHECK-LABEL: add_v4f32:
; NO-SIMD128-NOT: f32x4
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f32x4.add $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x float> @add_v4f32(<4 x float> %x, <4 x float> %y) {
  %a = fadd <4 x float> %x, %y
  ret <4 x float> %a
}

; CHECK-LABEL: sub_v4f32:
; NO-SIMD128-NOT: f32x4
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f32x4.sub $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x float> @sub_v4f32(<4 x float> %x, <4 x float> %y) {
  %a = fsub <4 x float> %x, %y
  ret <4 x float> %a
}

; CHECK-LABEL: div_v4f32:
; NO-SIMD128-NOT: f32x4
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f32x4.div $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x float> @div_v4f32(<4 x float> %x, <4 x float> %y) {
  %a = fdiv <4 x float> %x, %y
  ret <4 x float> %a
}

; CHECK-LABEL: mul_v4f32:
; NO-SIMD128-NOT: f32x4
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f32x4.mul $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <4 x float> @mul_v4f32(<4 x float> %x, <4 x float> %y) {
  %a = fmul <4 x float> %x, %y
  ret <4 x float> %a
}

; ==============================================================================
; 2 x double
; ==============================================================================
; CHECK-LABEL: neg_v2f64:
; NO-SIMD128-NOT: f64x2
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f64x2.neg $push0=, $0{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x double> @neg_v2f64(<2 x double> %x) {
  %a = fsub <2 x double> <double 0., double 0.>, %x
  ret <2 x double> %a
}

; CHECK-LABEL: add_v2f64:
; NO-SIMD128-NOT: f64x2
; SIMD128-VM-NOT: f62x2
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f64x2.add $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x double> @add_v2f64(<2 x double> %x, <2 x double> %y) {
  %a = fadd <2 x double> %x, %y
  ret <2 x double> %a
}

; CHECK-LABEL: sub_v2f64:
; NO-SIMD128-NOT: f64x2
; SIMD128-VM-NOT: f62x2
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f64x2.sub $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x double> @sub_v2f64(<2 x double> %x, <2 x double> %y) {
  %a = fsub <2 x double> %x, %y
  ret <2 x double> %a
}

; CHECK-LABEL: div_v2f64:
; NO-SIMD128-NOT: f64x2
; SIMD128-VM-NOT: f62x2
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f64x2.div $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x double> @div_v2f64(<2 x double> %x, <2 x double> %y) {
  %a = fdiv <2 x double> %x, %y
  ret <2 x double> %a
}

; CHECK-LABEL: mul_v2f64:
; NO-SIMD128-NOT: f64x2
; SIMD128-VM-NOT: f62x2
; SIMD128-NEXT: .param v128, v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f64x2.mul $push0=, $0, $1{{$}}
; SIMD128-NEXT: return $pop0{{$}}
define <2 x double> @mul_v2f64(<2 x double> %x, <2 x double> %y) {
  %a = fmul <2 x double> %x, %y
  ret <2 x double> %a
}
