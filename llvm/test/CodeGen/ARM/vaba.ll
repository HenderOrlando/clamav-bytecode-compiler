; RUN: llc < %s -march=arm -mattr=+neon | FileCheck %s

define <8 x i8> @vabas8(<8 x i8>* %A, <8 x i8>* %B, <8 x i8>* %C) nounwind {
;CHECK: vabas8:
;CHECK: vaba.s8
	%tmp1 = load <8 x i8>* %A
	%tmp2 = load <8 x i8>* %B
	%tmp3 = load <8 x i8>* %C
	%tmp4 = call <8 x i8> @llvm.arm.neon.vabas.v8i8(<8 x i8> %tmp1, <8 x i8> %tmp2, <8 x i8> %tmp3)
	ret <8 x i8> %tmp4
}

define <4 x i16> @vabas16(<4 x i16>* %A, <4 x i16>* %B, <4 x i16>* %C) nounwind {
;CHECK: vabas16:
;CHECK: vaba.s16
	%tmp1 = load <4 x i16>* %A
	%tmp2 = load <4 x i16>* %B
	%tmp3 = load <4 x i16>* %C
	%tmp4 = call <4 x i16> @llvm.arm.neon.vabas.v4i16(<4 x i16> %tmp1, <4 x i16> %tmp2, <4 x i16> %tmp3)
	ret <4 x i16> %tmp4
}

define <2 x i32> @vabas32(<2 x i32>* %A, <2 x i32>* %B, <2 x i32>* %C) nounwind {
;CHECK: vabas32:
;CHECK: vaba.s32
	%tmp1 = load <2 x i32>* %A
	%tmp2 = load <2 x i32>* %B
	%tmp3 = load <2 x i32>* %C
	%tmp4 = call <2 x i32> @llvm.arm.neon.vabas.v2i32(<2 x i32> %tmp1, <2 x i32> %tmp2, <2 x i32> %tmp3)
	ret <2 x i32> %tmp4
}

define <8 x i8> @vabau8(<8 x i8>* %A, <8 x i8>* %B, <8 x i8>* %C) nounwind {
;CHECK: vabau8:
;CHECK: vaba.u8
	%tmp1 = load <8 x i8>* %A
	%tmp2 = load <8 x i8>* %B
	%tmp3 = load <8 x i8>* %C
	%tmp4 = call <8 x i8> @llvm.arm.neon.vabau.v8i8(<8 x i8> %tmp1, <8 x i8> %tmp2, <8 x i8> %tmp3)
	ret <8 x i8> %tmp4
}

define <4 x i16> @vabau16(<4 x i16>* %A, <4 x i16>* %B, <4 x i16>* %C) nounwind {
;CHECK: vabau16:
;CHECK: vaba.u16
	%tmp1 = load <4 x i16>* %A
	%tmp2 = load <4 x i16>* %B
	%tmp3 = load <4 x i16>* %C
	%tmp4 = call <4 x i16> @llvm.arm.neon.vabau.v4i16(<4 x i16> %tmp1, <4 x i16> %tmp2, <4 x i16> %tmp3)
	ret <4 x i16> %tmp4
}

define <2 x i32> @vabau32(<2 x i32>* %A, <2 x i32>* %B, <2 x i32>* %C) nounwind {
;CHECK: vabau32:
;CHECK: vaba.u32
	%tmp1 = load <2 x i32>* %A
	%tmp2 = load <2 x i32>* %B
	%tmp3 = load <2 x i32>* %C
	%tmp4 = call <2 x i32> @llvm.arm.neon.vabau.v2i32(<2 x i32> %tmp1, <2 x i32> %tmp2, <2 x i32> %tmp3)
	ret <2 x i32> %tmp4
}

define <16 x i8> @vabaQs8(<16 x i8>* %A, <16 x i8>* %B, <16 x i8>* %C) nounwind {
;CHECK: vabaQs8:
;CHECK: vaba.s8
	%tmp1 = load <16 x i8>* %A
	%tmp2 = load <16 x i8>* %B
	%tmp3 = load <16 x i8>* %C
	%tmp4 = call <16 x i8> @llvm.arm.neon.vabas.v16i8(<16 x i8> %tmp1, <16 x i8> %tmp2, <16 x i8> %tmp3)
	ret <16 x i8> %tmp4
}

define <8 x i16> @vabaQs16(<8 x i16>* %A, <8 x i16>* %B, <8 x i16>* %C) nounwind {
;CHECK: vabaQs16:
;CHECK: vaba.s16
	%tmp1 = load <8 x i16>* %A
	%tmp2 = load <8 x i16>* %B
	%tmp3 = load <8 x i16>* %C
	%tmp4 = call <8 x i16> @llvm.arm.neon.vabas.v8i16(<8 x i16> %tmp1, <8 x i16> %tmp2, <8 x i16> %tmp3)
	ret <8 x i16> %tmp4
}

define <4 x i32> @vabaQs32(<4 x i32>* %A, <4 x i32>* %B, <4 x i32>* %C) nounwind {
;CHECK: vabaQs32:
;CHECK: vaba.s32
	%tmp1 = load <4 x i32>* %A
	%tmp2 = load <4 x i32>* %B
	%tmp3 = load <4 x i32>* %C
	%tmp4 = call <4 x i32> @llvm.arm.neon.vabas.v4i32(<4 x i32> %tmp1, <4 x i32> %tmp2, <4 x i32> %tmp3)
	ret <4 x i32> %tmp4
}

define <16 x i8> @vabaQu8(<16 x i8>* %A, <16 x i8>* %B, <16 x i8>* %C) nounwind {
;CHECK: vabaQu8:
;CHECK: vaba.u8
	%tmp1 = load <16 x i8>* %A
	%tmp2 = load <16 x i8>* %B
	%tmp3 = load <16 x i8>* %C
	%tmp4 = call <16 x i8> @llvm.arm.neon.vabau.v16i8(<16 x i8> %tmp1, <16 x i8> %tmp2, <16 x i8> %tmp3)
	ret <16 x i8> %tmp4
}

define <8 x i16> @vabaQu16(<8 x i16>* %A, <8 x i16>* %B, <8 x i16>* %C) nounwind {
;CHECK: vabaQu16:
;CHECK: vaba.u16
	%tmp1 = load <8 x i16>* %A
	%tmp2 = load <8 x i16>* %B
	%tmp3 = load <8 x i16>* %C
	%tmp4 = call <8 x i16> @llvm.arm.neon.vabau.v8i16(<8 x i16> %tmp1, <8 x i16> %tmp2, <8 x i16> %tmp3)
	ret <8 x i16> %tmp4
}

define <4 x i32> @vabaQu32(<4 x i32>* %A, <4 x i32>* %B, <4 x i32>* %C) nounwind {
;CHECK: vabaQu32:
;CHECK: vaba.u32
	%tmp1 = load <4 x i32>* %A
	%tmp2 = load <4 x i32>* %B
	%tmp3 = load <4 x i32>* %C
	%tmp4 = call <4 x i32> @llvm.arm.neon.vabau.v4i32(<4 x i32> %tmp1, <4 x i32> %tmp2, <4 x i32> %tmp3)
	ret <4 x i32> %tmp4
}

declare <8 x i8>  @llvm.arm.neon.vabas.v8i8(<8 x i8>, <8 x i8>, <8 x i8>) nounwind readnone
declare <4 x i16> @llvm.arm.neon.vabas.v4i16(<4 x i16>, <4 x i16>, <4 x i16>) nounwind readnone
declare <2 x i32> @llvm.arm.neon.vabas.v2i32(<2 x i32>, <2 x i32>, <2 x i32>) nounwind readnone

declare <8 x i8>  @llvm.arm.neon.vabau.v8i8(<8 x i8>, <8 x i8>, <8 x i8>) nounwind readnone
declare <4 x i16> @llvm.arm.neon.vabau.v4i16(<4 x i16>, <4 x i16>, <4 x i16>) nounwind readnone
declare <2 x i32> @llvm.arm.neon.vabau.v2i32(<2 x i32>, <2 x i32>, <2 x i32>) nounwind readnone

declare <16 x i8> @llvm.arm.neon.vabas.v16i8(<16 x i8>, <16 x i8>, <16 x i8>) nounwind readnone
declare <8 x i16> @llvm.arm.neon.vabas.v8i16(<8 x i16>, <8 x i16>, <8 x i16>) nounwind readnone
declare <4 x i32> @llvm.arm.neon.vabas.v4i32(<4 x i32>, <4 x i32>, <4 x i32>) nounwind readnone

declare <16 x i8> @llvm.arm.neon.vabau.v16i8(<16 x i8>, <16 x i8>, <16 x i8>) nounwind readnone
declare <8 x i16> @llvm.arm.neon.vabau.v8i16(<8 x i16>, <8 x i16>, <8 x i16>) nounwind readnone
declare <4 x i32> @llvm.arm.neon.vabau.v4i32(<4 x i32>, <4 x i32>, <4 x i32>) nounwind readnone

define <8 x i16> @vabals8(<8 x i16>* %A, <8 x i8>* %B, <8 x i8>* %C) nounwind {
;CHECK: vabals8:
;CHECK: vabal.s8
	%tmp1 = load <8 x i16>* %A
	%tmp2 = load <8 x i8>* %B
	%tmp3 = load <8 x i8>* %C
	%tmp4 = call <8 x i16> @llvm.arm.neon.vabals.v8i16(<8 x i16> %tmp1, <8 x i8> %tmp2, <8 x i8> %tmp3)
	ret <8 x i16> %tmp4
}

define <4 x i32> @vabals16(<4 x i32>* %A, <4 x i16>* %B, <4 x i16>* %C) nounwind {
;CHECK: vabals16:
;CHECK: vabal.s16
	%tmp1 = load <4 x i32>* %A
	%tmp2 = load <4 x i16>* %B
	%tmp3 = load <4 x i16>* %C
	%tmp4 = call <4 x i32> @llvm.arm.neon.vabals.v4i32(<4 x i32> %tmp1, <4 x i16> %tmp2, <4 x i16> %tmp3)
	ret <4 x i32> %tmp4
}

define <2 x i64> @vabals32(<2 x i64>* %A, <2 x i32>* %B, <2 x i32>* %C) nounwind {
;CHECK: vabals32:
;CHECK: vabal.s32
	%tmp1 = load <2 x i64>* %A
	%tmp2 = load <2 x i32>* %B
	%tmp3 = load <2 x i32>* %C
	%tmp4 = call <2 x i64> @llvm.arm.neon.vabals.v2i64(<2 x i64> %tmp1, <2 x i32> %tmp2, <2 x i32> %tmp3)
	ret <2 x i64> %tmp4
}

define <8 x i16> @vabalu8(<8 x i16>* %A, <8 x i8>* %B, <8 x i8>* %C) nounwind {
;CHECK: vabalu8:
;CHECK: vabal.u8
	%tmp1 = load <8 x i16>* %A
	%tmp2 = load <8 x i8>* %B
	%tmp3 = load <8 x i8>* %C
	%tmp4 = call <8 x i16> @llvm.arm.neon.vabalu.v8i16(<8 x i16> %tmp1, <8 x i8> %tmp2, <8 x i8> %tmp3)
	ret <8 x i16> %tmp4
}

define <4 x i32> @vabalu16(<4 x i32>* %A, <4 x i16>* %B, <4 x i16>* %C) nounwind {
;CHECK: vabalu16:
;CHECK: vabal.u16
	%tmp1 = load <4 x i32>* %A
	%tmp2 = load <4 x i16>* %B
	%tmp3 = load <4 x i16>* %C
	%tmp4 = call <4 x i32> @llvm.arm.neon.vabalu.v4i32(<4 x i32> %tmp1, <4 x i16> %tmp2, <4 x i16> %tmp3)
	ret <4 x i32> %tmp4
}

define <2 x i64> @vabalu32(<2 x i64>* %A, <2 x i32>* %B, <2 x i32>* %C) nounwind {
;CHECK: vabalu32:
;CHECK: vabal.u32
	%tmp1 = load <2 x i64>* %A
	%tmp2 = load <2 x i32>* %B
	%tmp3 = load <2 x i32>* %C
	%tmp4 = call <2 x i64> @llvm.arm.neon.vabalu.v2i64(<2 x i64> %tmp1, <2 x i32> %tmp2, <2 x i32> %tmp3)
	ret <2 x i64> %tmp4
}

declare <8 x i16> @llvm.arm.neon.vabals.v8i16(<8 x i16>, <8 x i8>, <8 x i8>) nounwind readnone
declare <4 x i32> @llvm.arm.neon.vabals.v4i32(<4 x i32>, <4 x i16>, <4 x i16>) nounwind readnone
declare <2 x i64> @llvm.arm.neon.vabals.v2i64(<2 x i64>, <2 x i32>, <2 x i32>) nounwind readnone

declare <8 x i16> @llvm.arm.neon.vabalu.v8i16(<8 x i16>, <8 x i8>, <8 x i8>) nounwind readnone
declare <4 x i32> @llvm.arm.neon.vabalu.v4i32(<4 x i32>, <4 x i16>, <4 x i16>) nounwind readnone
declare <2 x i64> @llvm.arm.neon.vabalu.v2i64(<2 x i64>, <2 x i32>, <2 x i32>) nounwind readnone
