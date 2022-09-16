
; =============== S U B	R O U T	I N E =======================================

; Knuckles object

ObjXX:						  ; ...

; FUNCTION CHUNK AT 0033A066 SIZE 0000000E BYTES

		tst.w	($FFFFFE08).w
		beq.s	ObjXX_Normal
		jmp	DebugMode
; ---------------------------------------------------------------------------

ObjXX_Normal:					  ; ...
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	ObjXX_Index(pc,d0.w),d1
		jmp	ObjXX_Index(pc,d1.w)
; End of function ObjXX-

; ---------------------------------------------------------------------------
ObjXX_Index:	dc.w ObjXX_Init-ObjXX_Index	  ; 0 ;	...
		dc.w ObjXX_Control-ObjXX_Index	  ; 1
		dc.w ObjXX_Hurt-ObjXX_Index	  ; 2
		dc.w ObjXX_Dead-ObjXX_Index	  ; 3
		dc.w ObjXX_Gone-ObjXX_Index	  ; 4
		dc.w ObjXX_Respawning-ObjXX_Index ; 5
; ---------------------------------------------------------------------------

ObjXX_Init:					  ; ...
		addq.b	#2,$24(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		move.l	#SK_Map_Knuckles,4(a0)	  ; SK_Map_Knuckles
		move.b	#2,$18(a0)
		move.b	#$18,$19(a0)
		move.b	#4,1(a0)
		move.w	#$600,($FFFFF760).w
		move.w	#$C,($FFFFF762).w
		move.w	#$80,($FFFFF764).w
		tst.b	($FFFFFE30).w
		bne.s	ObjXX_Init_Continued
		move.w	#$780,2(a0)
		jsr	Adjust2PArtPointer
		move.b	#$C,$3E(a0)
		move.b	#$D,$3F(a0)
		move.w	8(a0),($FFFFFE32).w
		move.w	$C(a0),($FFFFFE34).w
		move.w	2(a0),($FFFFFE3C).w
		move.w	$3E(a0),($FFFFFE3E).w

ObjXX_Init_Continued:				  ; ...
		move.b	#0,$2C(a0)
		move.b	#4,$2D(a0)
		move.b	#0,($FFFFFE19).w
		move.b	#$1E,$28(a0)
		sub.w	#$20,8(a0)
		add.w	#4,$C(a0)
		move.w	#0,($FFFFEED2).w
		move.w	#$3F,d2

loc_3153EC:					  ; ...
		bsr.w	Knuckles_RecordPositions
		subq.w	#4,a1
		move.l	#0,(a1)
		dbf	d2,loc_3153EC
		add.w	#$20,8(a0)
		sub.w	#4,$C(a0)

ObjXX_Control:					  ; ...
		tst.w	($FFFFFFDA).w
		beq.s	loc_315422
		btst	#4,($FFFFF605).w
		beq.s	loc_315422
		move.w	#1,($FFFFFE08).w
		clr.b	($FFFFF7CC).w
		rts
; ---------------------------------------------------------------------------

loc_315422:					  ; ...
		tst.b	($FFFFF7CC).w
		bne.s	loc_31542E
		move.w	($FFFFF604).w,($FFFFF602).w

loc_31542E:					  ; ...
		btst	#0,$2A(a0)
		beq.s	loc_31543E
		move.b	#0,$21(a0)
		bra.s	loc_315450
; ---------------------------------------------------------------------------

loc_31543E:					  ; ...
		moveq	#0,d0
		move.b	$22(a0),d0
		and.w	#6,d0
		move.w	ObjXX_Modes(pc,d0.w),d1
		jsr	ObjXX-_Modes(pc,d1.w)

loc_315450:					  ; ...
		cmp.w	#$FF00,($FFFFEECC).w
		bne.s	loc_31545E
		and.w	#$7FF,$C(a0)

loc_31545E:					  ; ...
		bsr.s	Knuckles_Display
		bsr.w	Knuckles_Super
		bsr.w	Knuckles_RecordPositions
		bsr.w	Knuckles_Water
		move.b	($FFFFF768).w,$36(a0)
		move.b	($FFFFF76A).w,$37(a0)
		tst.b	($FFFFF7C7).w
		beq.s	loc_31548A
		tst.b	$1C(a0)
		bne.s	loc_31548A
		move.b	$1D(a0),$1C(a0)

loc_31548A:					  ; ...
		bsr.w	Knuckles_Animate
		tst.b	$2A(a0)
		bmi.s	loc_31549A
		jsr	TouchResponse

loc_31549A:					  ; ...
		bra.w	LoadKnucklesDynPLC
; ---------------------------------------------------------------------------
ObjXX_Modes:	dc.w ObjXX_MdNormal-ObjXX_Modes	  ; 0 ;	...
		dc.w ObjXX_MdAir-ObjXX_Modes	  ; 1
		dc.w ObjXX_MdRoll-ObjXX_Modes	  ; 2
		dc.w ObjXX_MdJump-ObjXX_Modes	  ; 3

; =============== S U B	R O U T	I N E =======================================


Knuckles_Display:				  ; ...
		move.w	$30(a0),d0
		beq.s	ObjXX_Display
		subq.w	#1,$30(a0)
		lsr.w	#3,d0
		bcc.s	ObjXX_CheckInvincibility

ObjXX_Display:					  ; ...
		jsr	DisplaySprite

ObjXX_CheckInvincibility:			  ; ...
		btst	#1,$2B(a0)
		beq.s	ObjXX_CheckSpeedShoes
		tst.w	$32(a0)
		beq.s	ObjXX_CheckSpeedShoes
		subq.w	#1,$32(a0)
		bne.s	ObjXX_CheckSpeedShoes
		tst.b	($FFFFF7AA).w
		bne.s	ObjXX_RemoveInvincibility
		cmp.b	#$C,$28(a0)
		bcs.s	ObjXX_RemoveInvincibility
		move.w	($FFFFFF90).w,d0
		jsr	PlayMusic

ObjXX_RemoveInvincibility:			  ; ...
		bclr	#1,$2B(a0)

ObjXX_CheckSpeedShoes:				  ; ...
		btst	#2,$2B(a0)
		beq.s	ObjXX_ExitCheck
		tst.w	$34(a0)
		beq.s	ObjXX_ExitCheck
		subq.w	#1,$34(a0)
		bne.s	ObjXX_ExitCheck
		move.w	#$600,($FFFFF760).w
		move.w	#$C,($FFFFF762).w
		move.w	#$80,($FFFFF764).w
		tst.b	($FFFFFE19).w
		beq.s	ObjXX_RemoveSpeedShoes
		move.w	#$800,($FFFFF760).w
		move.w	#$18,($FFFFF762).w
		move.w	#$C0,($FFFFF764).w

ObjXX_RemoveSpeedShoes:				  ; ...
		bclr	#2,$2B(a0)
		move.w	#$FC,d0
		jmp	PlayMusic
; ---------------------------------------------------------------------------

ObjXX_ExitCheck:				  ; ...
		rts
; End of function Knuckles_Display


; =============== S U B	R O U T	I N E =======================================


Knuckles_RecordPositions:			  ; ...
		move.w	($FFFFEED2).w,d0
		lea	($FFFFE500).w,a1
		lea	(a1,d0.w),a1
		move.w	8(a0),(a1)+
		move.w	$C(a0),(a1)+
		addq.b	#4,($FFFFEED3).w
		lea	($FFFFE400).w,a1
		lea	(a1,d0.w),a1
		move.w	($FFFFF602).w,(a1)+
		move.w	$22(a0),(a1)+
		rts
; End of function Knuckles_RecordPositions


; =============== S U B	R O U T	I N E =======================================


Knuckles_Water:					  ; ...
		tst.b	($FFFFF730).w
		bne.s	ObjXX_InWater

return_31556C:					  ; ...
		rts
; ---------------------------------------------------------------------------

ObjXX_InWater:					  ; ...
		move.w	($FFFFF646).w,d0
		cmp.w	$C(a0),d0
		bge.s	ObjXX_OutWater
		bset	#6,$22(a0)
		bne.s	return_31556C
		move.l	a0,a1
		bsr.w	ResumeMusic
		move.b	#$A,($FFFFD080).w
		move.b	#$81,($FFFFD0A8).w
		move.l	a0,($FFFFD0BC).w
		move.w	#$300,($FFFFF760).w
		move.w	#6,($FFFFF762).w
		move.w	#$40,($FFFFF764).w
		tst.b	($FFFFFE19).w
		beq.s	loc_3155C0
		move.w	#$400,($FFFFF760).w
		move.w	#$C,($FFFFF762).w
		move.w	#$60,($FFFFF764).w

loc_3155C0:					  ; ...
		asr	$10(a0)
		asr	$12(a0)
		asr	$12(a0)
		beq.s	return_31556C
		move.w	#$100,($FFFFD11C).w
		move.w	#$AA,d0
		jmp	PlaySound
; ---------------------------------------------------------------------------

ObjXX_OutWater:					  ; ...
		bclr	#6,$22(a0)
		beq.s	return_31556C
		move.l	a0,a1
		bsr.w	ResumeMusic
		move.w	#$600,($FFFFF760).w
		move.w	#$C,($FFFFF762).w
		move.w	#$80,($FFFFF764).w
		tst.b	($FFFFFE19).w
		beq.s	loc_315616
		move.w	#$800,($FFFFF760).w
		move.w	#$18,($FFFFF762).w
		move.w	#$C0,($FFFFF764).w

loc_315616:					  ; ...
		cmp.b	#4,$24(a0)
		beq.s	loc_315622
		asl	$12(a0)

loc_315622:					  ; ...
		tst.w	$12(a0)
		beq.w	return_31556C
		move.w	#$100,($FFFFD11C).w
		move.l	a0,a1
		bsr.w	ResumeMusic
		cmp.w	#$F000,$12(a0)
		bgt.s	loc_315644
		move.w	#$F000,$12(a0)

loc_315644:					  ; ...
		move.w	#$AA,d0
		jmp	PlaySound
; End of function Knuckles_Water


; =============== S U B	R O U T	I N E =======================================


ObjXX_MdNormal:					  ; ...
		bsr.w	Knuckles_Spindash
		bsr.w	Knuckles_Jump
		bsr.w	Knuckles_SlopeResist
		bsr.w	Knuckles_Move
		bsr.w	Knuckles_Roll
		bsr.w	Knuckles_LevelBoundaries
		jsr	ObjectMove		  ; AKA	SpeedToPos in Sonic 1
		bsr.w	AnglePos
		bsr.w	Knuckles_SlopeRepel
		rts
; End of function ObjXX_MdNormal


; =============== S U B	R O U T	I N E =======================================


ObjXX_MdAir:					  ; ...
		tst.b	$21(a0)
		bne.s	ObjXX_MdAir_Gliding
		bsr.w	Knuckles_JumpHeight
		bsr.w	Knuckles_ChgJumpDir
		bsr.w	Knuckles_LevelBoundaries
		jsr	ObjectMoveAndFall
		btst	#6,$22(a0)
		beq.s	loc_31569C
		sub.w	#$28,$12(a0)

loc_31569C:					  ; ...
		bsr.w	Knuckles_JumpAngle
		bsr.w	Knuckles_DoLevelCollision
		rts
; ---------------------------------------------------------------------------

ObjXX_MdAir_Gliding:				  ; ...
		bsr.w	Knuckles_GlideSpeedControl
		bsr.w	Knuckles_LevelBoundaries
		jsr	ObjectMove		  ; AKA	SpeedToPos in Sonic 1
		bsr.w	Knuckles_GlideControl

return_3156B8:					  ; ...
		rts
; End of function ObjXX_MdAir


; =============== S U B	R O U T	I N E =======================================


Knuckles_GlideControl:				  ; ...

; FUNCTION CHUNK AT 00315C40 SIZE 0000003C BYTES

		move.b	$21(a0),d0
		beq.s	return_3156B8
		cmp.b	#2,d0
		beq.w	Knuckles_FallingFromGlide
		cmp.b	#3,d0
		beq.w	Knuckles_Sliding
		cmp.b	#4,d0
		beq.w	Knuckles_Climbing_Wall
		cmp.b	#5,d0
		beq.w	Knuckles_Climbing_Up

Knuckles_NormalGlide:
		move.b	#$A,$16(a0)
		move.b	#$A,$17(a0)
		bsr.w	Knuckles_DoLevelCollision2
		btst	#5,($FFFFF7AC).w
		bne.w	Knuckles_BeginClimb
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		btst	#1,($FFFFF7AC).w
		beq.s	Knuckles_BeginSlide
		move.b	($FFFFF602).w,d0
		and.b	#$70,d0
		bne.s	loc_31574C
		move.b	#2,$21(a0)
		move.b	#$21,$1C(a0)
		bclr	#0,$22(a0)
		tst.w	$10(a0)
		bpl.s	loc_315736
		bset	#0,$22(a0)

loc_315736:					  ; ...
		asr	$10(a0)
		asr	$10(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		rts
; ---------------------------------------------------------------------------

loc_31574C:					  ; ...
		bra.w	sub_315C7C
; ---------------------------------------------------------------------------

Knuckles_BeginSlide:				  ; ...
		bclr	#0,$22(a0)
		tst.w	$10(a0)
		bpl.s	loc_315762
		bset	#0,$22(a0)

loc_315762:					  ; ...
		move.b	$26(a0),d0
		add.b	#$20,d0
		and.b	#$C0,d0
		beq.s	loc_315780
		move.w	$14(a0),$10(a0)
		move.w	#0,$12(a0)
		bra.w	Knuckles_ResetOnFloor_Part2
; ---------------------------------------------------------------------------

loc_315780:					  ; ...
		move.b	#3,$21(a0)
		move.b	#$CC,$1A(a0)
		move.b	#$7F,$1E(a0)
		move.b	#0,$1B(a0)
		cmp.b	#$C,$28(a0)
		bcs.s	return_3157AC
		move.b	#6,($FFFFD124).w
		move.b	#$15,($FFFFD11A).w

return_3157AC:					  ; ...
		rts
; ---------------------------------------------------------------------------

Knuckles_BeginClimb:				  ; ...
		tst.b	($FFFFF7AD).w
		bmi.w	loc_31587A
		move.b	$3F(a0),d5
		move.b	$1F(a0),d0
		add.b	#$40,d0
		bpl.s	loc_3157D8
		bset	#0,$22(a0)
		bsr.w	CheckLeftCeilingDist
		or.w	d0,d1
		bne.s	Knuckles_FallFromGlide
		addq.w	#1,8(a0)
		bra.s	loc_3157E8
; ---------------------------------------------------------------------------

loc_3157D8:					  ; ...
		bclr	#0,$22(a0)
		bsr.w	CheckRightCeilingDist
		or.w	d0,d1
		bne.w	loc_31586A

loc_3157E8:					  ; ...
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		tst.b	($FFFFFE19).w
		beq.s	loc_315804
		cmp.w	#$480,$14(a0)
		bcs.s	loc_315804
		nop

loc_315804:					  ; ...
		move.w	#0,$14(a0)
		move.w	#0,$10(a0)
		move.w	#0,$12(a0)
		move.b	#4,$21(a0)
		move.b	#$B7,$1A(a0)
		move.b	#$7F,$1E(a0)
		move.b	#0,$1B(a0)
		move.b	#3,$1F(a0)
		move.w	8(a0),$A(a0)
		rts
; ---------------------------------------------------------------------------

Knuckles_FallFromGlide:				  ; ...
		move.w	8(a0),d3
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d3
		subq.w	#1,d3

loc_31584A:					  ; ...
		move.w	$C(a0),d2
		sub.w	#$B,d2
		jsr	ChkFloorEdge_Part2
		tst.w	d1
		bmi.s	loc_31587A
		cmp.w	#$C,d1
		bcc.s	loc_31587A
		add.w	d1,$C(a0)
		bra.w	loc_3157E8
; ---------------------------------------------------------------------------

loc_31586A:					  ; ...
		move.w	8(a0),d3
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d3
		addq.w	#1,d3
		bra.s	loc_31584A
; ---------------------------------------------------------------------------

loc_31587A:					  ; ...
		move.b	#2,$21(a0)
		move.b	#$21,$1C(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		bset	#1,($FFFFF7AC).w
		rts
; ---------------------------------------------------------------------------

Knuckles_FallingFromGlide:			  ; ...
		bsr.w	Knuckles_ChgJumpDir
		add.w	#$38,$12(a0)
		btst	#6,$22(a0)
		beq.s	loc_3158B2
		sub.w	#$28,$12(a0)

loc_3158B2:					  ; ...
		bsr.w	Knuckles_DoLevelCollision2
		btst	#1,($FFFFF7AC).w
		bne.s	return_315900
		move.w	#0,$14(a0)
		move.w	#0,$10(a0)
		move.w	#0,$12(a0)
		move.b	$16(a0),d0
		sub.b	#$13,d0
		ext.w	d0
		add.w	d0,$C(a0)
		move.b	$26(a0),d0
		add.b	#$20,d0
		and.b	#$C0,d0
		beq.s	loc_3158F0
		bra.w	Knuckles_ResetOnFloor_Part2
; ---------------------------------------------------------------------------

loc_3158F0:					  ; ...
		bsr.w	Knuckles_ResetOnFloor_Part2
		move.w	#$F,$2E(a0)
		move.b	#$23,$1C(a0)

return_315900:					  ; ...
		rts
; ---------------------------------------------------------------------------

Knuckles_Sliding:				  ; ...
		move.b	($FFFFF602).w,d0
		and.b	#$70,d0
		beq.s	loc_315926
		tst.w	$10(a0)
		bpl.s	loc_31591E
		add.w	#$20,$10(a0)
		bmi.s	loc_31591C
		bra.s	loc_315926
; ---------------------------------------------------------------------------

loc_31591C:					  ; ...
		bra.s	loc_315958
; ---------------------------------------------------------------------------

loc_31591E:					  ; ...
		sub.w	#$20,$10(a0)
		bpl.s	loc_315958

loc_315926:					  ; ...
		move.w	#0,$14(a0)
		move.w	#0,$10(a0)
		move.w	#0,$12(a0)
		move.b	$16(a0),d0
		sub.b	#$13,d0
		ext.w	d0
		add.w	d0,$C(a0)
		bsr.w	Knuckles_ResetOnFloor_Part2
		move.w	#$F,$2E(a0)
		move.b	#$22,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_315958:					  ; ...
		move.b	#$A,$16(a0)
		move.b	#$A,$17(a0)
		bsr.w	Knuckles_DoLevelCollision2
		bsr.w	Sonic_CheckFloor
		cmp.w	#$E,d1
		bge.s	loc_315988
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		rts
; ---------------------------------------------------------------------------

loc_315988:					  ; ...
		move.b	#2,$21(a0)
		move.b	#$21,$1C(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		bset	#1,($FFFFF7AC).w
		rts
; ---------------------------------------------------------------------------

Knuckles_Climbing_Wall:				  ; ...
		tst.b	($FFFFF7AD).w
		bmi.w	loc_315BAE
		move.w	8(a0),d0
		cmp.w	$A(a0),d0
		bne.w	loc_315BAE
		btst	#3,$22(a0)
		bne.w	loc_315BAE
		move.w	#0,$14(a0)
		move.w	#0,$10(a0)
		move.w	#0,$12(a0)
		move.l	#$FFFFD600,($FFFFF796).w
		cmp.b	#$D,$3F(a0)
		beq.s	loc_3159F0
		move.l	#$FFFFD900,($FFFFF796).w

loc_3159F0:					  ; ...
		move.b	$3F(a0),d5
		move.b	#$A,$16(a0)
		move.b	#$A,$17(a0)
		moveq	#0,d1
		btst	#0,($FFFFF602).w
		beq.w	loc_315A76
		move.w	$C(a0),d2
		sub.w	#$B,d2
		bsr.w	sub_315C22
		cmp.w	#4,d1
		bge.w	Knuckles_ClimbUp	  ; Climb onto the floor above you
		tst.w	d1
		bne.w	loc_315B30
		move.b	$3F(a0),d5
		move.w	$C(a0),d2
		subq.w	#8,d2
		move.w	8(a0),d3
		bsr.w	sub_3192E6		  ; Doesn't exist in S2
		tst.w	d1
		bpl.s	loc_315A46
		sub.w	d1,$C(a0)
		moveq	#1,d1
		bra.w	loc_315B04
; ---------------------------------------------------------------------------

loc_315A46:					  ; ...
		subq.w	#1,$C(a0)
		tst.b	($FFFFFE19).w
		beq.s	loc_315A54
		subq.w	#1,$C(a0)

loc_315A54:					  ; ...
		moveq	#1,d1
		move.w	($FFFFEECC).w,d0
		cmp.w	#-$100,d0
		beq.w	loc_315B04
		add.w	#$10,d0
		cmp.w	$C(a0),d0
		ble.w	loc_315B04
		move.w	d0,$C(a0)
		bra.w	loc_315B04
; ---------------------------------------------------------------------------

loc_315A76:					  ; ...
		btst	#1,($FFFFF602).w
		beq.w	loc_315B04
		cmp.b	#$BD,$1A(a0)
		bne.s	loc_315AA2
		move.b	#$B7,$1A(a0)
		addq.w	#3,$C(a0)
		subq.w	#3,8(a0)
		btst	#0,$22(a0)
		beq.s	loc_315AA2
		addq.w	#6,8(a0)

loc_315AA2:					  ; ...
		move.w	$C(a0),d2
		add.w	#$B,d2
		bsr.w	sub_315C22
		tst.w	d1
		bne.w	loc_315BAE
		move.b	$3E(a0),d5
		move.w	$C(a0),d2
		add.w	#9,d2
		move.w	8(a0),d3
		bsr.w	sub_318FF6
		tst.w	d1
		bpl.s	loc_315AF4
		add.w	d1,$C(a0)
		move.b	($FFFFF768).w,$26(a0)
		move.w	#0,$14(a0)
		move.w	#0,$10(a0)
		move.w	#0,$12(a0)
		bsr.w	Knuckles_ResetOnFloor_Part2
		move.b	#5,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_315AF4:					  ; ...
		addq.w	#1,$C(a0)
		tst.b	($FFFFFE19).w
		beq.s	loc_315B02
		addq.w	#1,$C(a0)

loc_315B02:					  ; ...
		moveq	#-1,d1

loc_315B04:					  ; ...
		tst.w	d1
		beq.s	loc_315B30
		subq.b	#1,$1F(a0)
		bpl.s	loc_315B30
		move.b	#3,$1F(a0)
		add.b	$1A(a0),d1
		cmp.b	#$B7,d1
		bcc.s	loc_315B22
		move.b	#$BC,d1

loc_315B22:					  ; ...
		cmp.b	#$BC,d1
		bls.s	loc_315B2C
		move.b	#$B7,d1

loc_315B2C:					  ; ...
		move.b	d1,$1A(a0)

loc_315B30:					  ; ...
		move.b	#$20,$1E(a0)
		move.b	#0,$1B(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		move.w	($FFFFF602).w,d0
		and.w	#$70,d0
		beq.s	return_315B94
		move.w	#$FC80,$12(a0)
		move.w	#$400,$10(a0)
		bchg	#0,$22(a0)
		bne.s	loc_315B6A
		neg.w	$10(a0)

loc_315B6A:					  ; ...
		bset	#1,$22(a0)
		move.b	#1,$3C(a0)
		move.b	#$E,$16(a0)
		move.b	#7,$17(a0)
		move.b	#2,$1C(a0)
		bset	#2,$22(a0)
		move.b	#0,$21(a0)

return_315B94:					  ; ...
		rts
; ---------------------------------------------------------------------------

Knuckles_ClimbUp:				  ; ...
		move.b	#5,$21(a0)		  ; Climb up to	the floor above	you
		cmp.b	#$BD,$1A(a0)
		beq.s	return_315BAC
		move.b	#0,$1F(a0)
		bsr.s	sub_315BDA

return_315BAC:					  ; ...
		rts
; ---------------------------------------------------------------------------

loc_315BAE:					  ; ...
		move.b	#2,$21(a0)
		move.w	#$2121,$1C(a0)
		move.b	#$CB,$1A(a0)
		move.b	#7,$1E(a0)
		move.b	#1,$1B(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		rts
; End of function Knuckles_GlideControl


; =============== S U B	R O U T	I N E =======================================


sub_315BDA:					  ; ...
		moveq	#0,d0
		move.b	$1F(a0),d0
		lea	word_315C12(pc,d0.w),a1
		move.b	(a1)+,$1A(a0)
		move.b	(a1)+,d0
		ext.w	d0
		btst	#0,$22(a0)
		beq.s	loc_315BF6
		neg.w	d0

loc_315BF6:					  ; ...
		add.w	d0,8(a0)
		move.b	(a1)+,d1
		ext.w	d1
		add.w	d1,$C(a0)
		move.b	(a1)+,$1E(a0)
		addq.b	#4,$1F(a0)
		move.b	#0,$1B(a0)
		rts
; End of function sub_315BDA

; ---------------------------------------------------------------------------
word_315C12:	dc.w $BD03,$FD06,$BE08,$F606,$BFF8,$F406,$D208,$FB06; 0	; ...

; =============== S U B	R O U T	I N E =======================================


sub_315C22:					  ; ...

; FUNCTION CHUNK AT 00319208 SIZE 00000020 BYTES
; FUNCTION CHUNK AT 003193D2 SIZE 00000024 BYTES

		move.b	$3F(a0),d5
		btst	#0,$22(a0)
		bne.s	loc_315C36
		move.w	8(a0),d3
		bra.w	loc_319208
; ---------------------------------------------------------------------------

loc_315C36:					  ; ...
		move.w	8(a0),d3
		subq.w	#1,d3
		bra.w	loc_3193D2
; End of function sub_315C22

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR Knuckles_GlideControl

Knuckles_Climbing_Up:				  ; ...
		tst.b	$1E(a0)
		bne.s	return_315C7A
		bsr.w	sub_315BDA
		cmp.b	#$10,$1F(a0)
		bne.s	return_315C7A
		move.w	#0,$14(a0)
		move.w	#0,$10(a0)
		move.w	#0,$12(a0)
		btst	#0,$22(a0)
		beq.s	loc_315C70
		subq.w	#1,8(a0)

loc_315C70:					  ; ...
		bsr.w	Knuckles_ResetOnFloor_Part2
		move.b	#5,$1C(a0)

return_315C7A:					  ; ...
		rts
; END OF FUNCTION CHUNK	FOR Knuckles_GlideControl

; =============== S U B	R O U T	I N E =======================================


sub_315C7C:					  ; ...
		move.b	#$20,$1E(a0)
		move.b	#0,$1B(a0)
		move.w	#$2020,$1C(a0)
		bclr	#5,$22(a0)
		bclr	#0,$22(a0)
		moveq	#0,d0
		move.b	$1F(a0),d0
		add.b	#$10,d0
		lsr.w	#5,d0
		move.b	byte_315CC2(pc,d0.w),d1
		move.b	d1,$1A(a0)
		cmp.b	#$C4,d1
		bne.s	return_315CC0
		bset	#0,$22(a0)
		move.b	#$C0,$1A(a0)

return_315CC0:					  ; ...
		rts
; End of function sub_315C7C

; ---------------------------------------------------------------------------
byte_315CC2:	dc.b $C0,$C1,$C2,$C3,$C4,$C3,$C2,$C1; 0	; ...

; =============== S U B	R O U T	I N E =======================================


Knuckles_GlideSpeedControl:			  ; ...
		cmp.b	#1,$21(a0)
		bne.w	loc_315D88
		move.w	$14(a0),d0
		cmp.w	#$400,d0
		bcc.s	loc_315CE2
		addq.w	#8,d0
		bra.s	loc_315CFC
; ---------------------------------------------------------------------------

loc_315CE2:					  ; ...
		cmp.w	#$1800,d0
		bcc.s	loc_315CFC
		move.b	$1F(a0),d1
		and.b	#$7F,d1
		bne.s	loc_315CFC
		addq.w	#4,d0
		tst.b	($FFFFFE19).w
		beq.s	loc_315CFC
		addq.w	#8,d0

loc_315CFC:					  ; ...
		move.w	d0,$14(a0)
		move.b	$1F(a0),d0
		btst	#2,($FFFFF602).w
		beq.s	loc_315D1C
		cmp.b	#$80,d0
		beq.s	loc_315D1C
		tst.b	d0
		bpl.s	loc_315D18
		neg.b	d0

loc_315D18:					  ; ...
		addq.b	#2,d0
		bra.s	loc_315D3A
; ---------------------------------------------------------------------------

loc_315D1C:					  ; ...
		btst	#3,($FFFFF602).w
		beq.s	loc_315D30
		tst.b	d0
		beq.s	loc_315D30
		bmi.s	loc_315D2C
		neg.b	d0

loc_315D2C:					  ; ...
		addq.b	#2,d0
		bra.s	loc_315D3A
; ---------------------------------------------------------------------------

loc_315D30:					  ; ...
		move.b	d0,d1
		and.b	#$7F,d1
		beq.s	loc_315D3A
		addq.b	#2,d0

loc_315D3A:					  ; ...
		move.b	d0,$1F(a0)
		move.b	$1F(a0),d0
		jsr	CalcSine
		muls.w	$14(a0),d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		cmp.w	#$80,$12(a0)
		blt.s	loc_315D62
		sub.w	#$20,$12(a0)
		bra.s	loc_315D68
; ---------------------------------------------------------------------------

loc_315D62:					  ; ...
		add.w	#$20,$12(a0)

loc_315D68:					  ; ...
		move.w	($FFFFEECC).w,d0
		cmp.w	#$FF00,d0
		beq.w	loc_315D88
		add.w	#$10,d0
		cmp.w	$C(a0),d0
		ble.w	loc_315D88
		asr	$10(a0)
		asr	$14(a0)

loc_315D88:					  ; ...
		cmp.w	#$60,($FFFFEED8).w
		beq.s	return_315D9A
		bcc.s	loc_315D96
		addq.w	#4,($FFFFEED8).w

loc_315D96:					  ; ...
		subq.w	#2,($FFFFEED8).w

return_315D9A:					  ; ...
		rts
; End of function Knuckles_GlideSpeedControl

; ---------------------------------------------------------------------------

ObjXX_MdRoll:					  ; ...
		tst.b	$39(a0)
		bne.s	loc_315DA6
		bsr.w	Knuckles_Jump

loc_315DA6:					  ; ...
		bsr.w	Knuckles_RollRepel
		bsr.w	Knuckles_RollSpeed
		bsr.w	Knuckles_LevelBoundaries
		jsr	ObjectMove		  ; AKA	SpeedToPos in Sonic 1
		bsr.w	AnglePos
		bsr.w	Knuckles_SlopeRepel
		rts
; ---------------------------------------------------------------------------

ObjXX_MdJump:					  ; ...
		bsr.w	Knuckles_JumpHeight
		bsr.w	Knuckles_ChgJumpDir
		bsr.w	Knuckles_LevelBoundaries
		jsr	ObjectMoveAndFall
		btst	#6,$22(a0)
		beq.s	loc_315DE2
		sub.w	#$28,$12(a0)

loc_315DE2:					  ; ...
		bsr.w	Knuckles_JumpAngle
		bsr.w	Knuckles_DoLevelCollision
		rts

; =============== S U B	R O U T	I N E =======================================


Knuckles_Move:					  ; ...
		move.w	($FFFFF760).w,d6
		move.w	($FFFFF762).w,d5
		move.w	($FFFFF764).w,d4
		tst.b	$2B(a0)
		bmi.w	ObjXX_Traction
		tst.w	$2E(a0)
		bne.w	ObjXX_ResetScreen
		btst	#2,($FFFFF602).w
		beq.s	ObjXX_NotLeft
		bsr.w	Knuckles_MoveLeft

ObjXX_NotLeft:					  ; ...
		btst	#3,($FFFFF602).w
		beq.s	ObjXX_NotRight
		bsr.w	Knuckles_MoveRight

ObjXX_NotRight:					  ; ...
		move.b	$26(a0),d0
		add.b	#$20,d0
		and.b	#$C0,d0
		bne.w	ObjXX_ResetScreen
		tst.w	$14(a0)
		bne.w	ObjXX_ResetScreen
		bclr	#5,$22(a0)
		move.b	#5,$1C(a0)
		btst	#3,$22(a0)
		beq.w	Knuckles_Balance
		moveq	#0,d0
		move.b	$3D(a0),d0
		lsl.w	#6,d0
		lea	($FFFFB000).w,a1
		lea	(a1,d0.w),a1
		tst.b	$22(a1)
		bmi.w	Knuckles_LookUp
		moveq	#0,d1
		move.b	$19(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#2,d2
		add.w	8(a0),d1
		sub.w	8(a1),d1
		cmp.w	#2,d1
		blt.s	Knuckles_BalanceOnObjLeft
		cmp.w	d2,d1
		bge.s	Knuckles_BalanceOnObjRight
		bra.w	Knuckles_LookUp
; ---------------------------------------------------------------------------

Knuckles_BalanceOnObjRight:			  ; ...
		btst	#0,$22(a0)
		bne.s	loc_315E9A
		move.b	#6,$1C(a0)
		bra.w	ObjXX_ResetScreen
; ---------------------------------------------------------------------------

loc_315E9A:					  ; ...
		bclr	#0,$22(a0)
		move.b	#0,$1E(a0)
		move.b	#4,$1B(a0)
		move.w	#$606,$1C(a0)
		bra.w	ObjXX_ResetScreen
; ---------------------------------------------------------------------------

Knuckles_BalanceOnObjLeft:			  ; ...
		btst	#0,$22(a0)
		beq.s	loc_315EC8
		move.b	#6,$1C(a0)
		bra.w	ObjXX_ResetScreen
; ---------------------------------------------------------------------------

loc_315EC8:					  ; ...
		bset	#0,$22(a0)
		move.b	#0,$1E(a0)
		move.b	#4,$1B(a0)
		move.w	#$606,$1C(a0)
		bra.w	ObjXX_ResetScreen
; ---------------------------------------------------------------------------

Knuckles_Balance:				  ; ...
		jsr	ChkFloorEdge
		cmp.w	#$C,d1
		blt.w	Knuckles_LookUp
		cmp.b	#3,$36(a0)
		bne.s	Knuckles_BalanceLeft
		btst	#0,$22(a0)
		bne.s	loc_315F0C
		move.b	#6,$1C(a0)
		bra.w	ObjXX_ResetScreen
; ---------------------------------------------------------------------------

loc_315F0C:					  ; ...
		bclr	#0,$22(a0)
		move.b	#0,$1E(a0)
		move.b	#4,$1B(a0)
		move.w	#$606,$1C(a0)
		bra.w	ObjXX_ResetScreen
; ---------------------------------------------------------------------------

Knuckles_BalanceLeft:				  ; ...
		cmp.b	#3,$37(a0)
		bne.s	Knuckles_LookUp
		btst	#0,$22(a0)
		beq.s	loc_315F42
		move.b	#6,$1C(a0)
		bra.w	ObjXX_ResetScreen
; ---------------------------------------------------------------------------

loc_315F42:					  ; ...
		bset	#0,$22(a0)
		move.b	#0,$1E(a0)
		move.b	#4,$1B(a0)
		move.w	#$606,$1C(a0)
		bra.w	ObjXX_ResetScreen
; ---------------------------------------------------------------------------

Knuckles_LookUp:				  ; ...
		btst	#0,($FFFFF602).w
		beq.s	Knuckles_Duck
		move.b	#7,$1C(a0)
		addq.w	#1,($FFFFF66C).w
		cmp.w	#$78,($FFFFF66C).w
		bcs.s	ObjXX_ResetScreen_Part2
		move.w	#$78,($FFFFF66C).w
		cmp.w	#$C8,($FFFFEED8).w
		beq.s	ObjXX_UpdateSpeedOnGround
		addq.w	#2,($FFFFEED8).w
		bra.s	ObjXX_UpdateSpeedOnGround
; ---------------------------------------------------------------------------

Knuckles_Duck:					  ; ...
		btst	#1,($FFFFF602).w
		beq.s	ObjXX_ResetScreen
		move.b	#8,$1C(a0)
		addq.w	#1,($FFFFF66C).w
		cmp.w	#$78,($FFFFF66C).w
		bcs.s	ObjXX_ResetScreen_Part2
		move.w	#$78,($FFFFF66C).w
		cmp.w	#8,($FFFFEED8).w
		beq.s	ObjXX_UpdateSpeedOnGround
		subq.w	#2,($FFFFEED8).w
		bra.s	ObjXX_UpdateSpeedOnGround
; ---------------------------------------------------------------------------

ObjXX_ResetScreen:				  ; ...
		move.w	#0,($FFFFF66C).w

ObjXX_ResetScreen_Part2:			  ; ...
		cmp.w	#$60,($FFFFEED8).w
		beq.s	ObjXX_UpdateSpeedOnGround
		bcc.s	loc_315FCE
		addq.w	#4,($FFFFEED8).w

loc_315FCE:					  ; ...
		subq.w	#2,($FFFFEED8).w

ObjXX_UpdateSpeedOnGround:			  ; ...
		tst.b	($FFFFFE19).w
		beq.s	loc_315FDC
		move.w	#$C,d5

loc_315FDC:					  ; ...
		move.b	($FFFFF602).w,d0
		and.b	#$C,d0
		bne.s	ObjXX_Traction
		move.w	$14(a0),d0
		beq.s	ObjXX_Traction
		bmi.s	ObjXX_SettleLeft
		sub.w	d5,d0
		bcc.s	loc_315FF6
		move.w	#0,d0

loc_315FF6:					  ; ...
		move.w	d0,$14(a0)
		bra.s	ObjXX_Traction
; ---------------------------------------------------------------------------

ObjXX_SettleLeft:				  ; ...
		add.w	d5,d0
		bcc.s	loc_316004
		move.w	#0,d0

loc_316004:					  ; ...
		move.w	d0,$14(a0)

ObjXX_Traction:					  ; ...
		move.b	$26(a0),d0
		jsr	CalcSine
		muls.w	$14(a0),d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	$14(a0),d0
		asr.l	#8,d0
		move.w	d0,$12(a0)

ObjXX_CheckWallsOnGround:			  ; ...
		move.b	$26(a0),d0
		add.b	#$40,d0
		bmi.s	return_3160A6
		move.b	#$40,d1
		tst.w	$14(a0)
		beq.s	return_3160A6
		bmi.s	loc_31603E
		neg.w	d1

loc_31603E:					  ; ...
		move.b	$26(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	CalcRoomInFront		  ; Also known as Sonic_WalkSpeed in Sonic 1
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	return_3160A6
		asl.w	#8,d1
		add.b	#$20,d0
		and.b	#$C0,d0
		beq.s	loc_3160A2
		cmp.b	#$40,d0
		beq.s	loc_316088
		cmp.b	#$80,d0
		beq.s	loc_316082
		add.w	d1,$10(a0)
		move.w	#0,$14(a0)
		btst	#0,$22(a0)
		bne.s	return_316080
		bset	#5,$22(a0)

return_316080:					  ; ...
		rts
; ---------------------------------------------------------------------------

loc_316082:					  ; ...
		sub.w	d1,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_316088:					  ; ...
		sub.w	d1,$10(a0)
		move.w	#0,$14(a0)
		btst	#0,$22(a0)
		beq.s	return_316080
		bset	#5,$22(a0)
		rts
; ---------------------------------------------------------------------------

loc_3160A2:					  ; ...
		add.w	d1,$12(a0)

return_3160A6:					  ; ...
		rts
; End of function Knuckles_Move


; =============== S U B	R O U T	I N E =======================================


Knuckles_MoveLeft:				  ; ...
		move.w	$14(a0),d0
		beq.s	loc_3160B0
		bpl.s	Knuckles_TurnLeft

loc_3160B0:					  ; ...
		bset	#0,$22(a0)
		bne.s	loc_3160C4
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)

loc_3160C4:					  ; ...
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_3160D6
		add.w	d5,d0
		cmp.w	d1,d0
		ble.s	loc_3160D6
		move.w	d1,d0

loc_3160D6:					  ; ...
		move.w	d0,$14(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

Knuckles_TurnLeft:				  ; ...
		sub.w	d4,d0
		bcc.s	loc_3160EA
		move.w	#-$80,d0

loc_3160EA:					  ; ...
		move.w	d0,$14(a0)
		move.b	$26(a0),d1
		add.b	#$20,d1
		and.b	#$C0,d1
		bne.s	return_31612C
		cmp.w	#$400,d0
		blt.s	return_31612C
		move.b	#$D,$1C(a0)
		bclr	#0,$22(a0)
		move.w	#$A4,d0
		jsr	PlaySound
		cmp.b	#$C,$28(a0)
		bcs.s	return_31612C
		move.b	#6,($FFFFD124).w
		move.b	#$15,($FFFFD11A).w

return_31612C:					  ; ...
		rts
; End of function Knuckles_MoveLeft


; =============== S U B	R O U T	I N E =======================================


Knuckles_MoveRight:				  ; ...
		move.w	$14(a0),d0
		bmi.s	Knuckles_TurnRight
		bclr	#0,$22(a0)
		beq.s	loc_316148
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)

loc_316148:					  ; ...
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_316156
		sub.w	d5,d0
		cmp.w	d6,d0
		bge.s	loc_316156
		move.w	d6,d0

loc_316156:					  ; ...
		move.w	d0,$14(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

Knuckles_TurnRight:				  ; ...
		add.w	d4,d0
		bcc.s	loc_31616A
		move.w	#$80,d0

loc_31616A:					  ; ...
		move.w	d0,$14(a0)
		move.b	$26(a0),d1
		add.b	#$20,d1
		and.b	#$C0,d1
		bne.s	return_3161AC
		cmp.w	#$FC00,d0
		bgt.s	return_3161AC
		move.b	#$D,$1C(a0)
		bset	#0,$22(a0)
		move.w	#$A4,d0
		jsr	PlaySound
		cmp.b	#$C,$28(a0)
		bcs.s	return_3161AC
		move.b	#6,($FFFFD124).w
		move.b	#$15,($FFFFD11A).w

return_3161AC:					  ; ...
		rts
; End of function Knuckles_MoveRight


; =============== S U B	R O U T	I N E =======================================


Knuckles_RollSpeed:				  ; ...
		move.w	($FFFFF760).w,d6
		asl.w	#1,d6
		move.w	($FFFFF762).w,d5
		asr.w	#1,d5
		move.w	#$20,d4
		tst.b	$2B(a0)
		bmi.w	ObjXX_Roll_ResetScreen
		tst.w	$2E(a0)
		bne.s	Knuckles_Apply_RollSpeed
		btst	#2,($FFFFF602).w
		beq.s	loc_3161D8
		bsr.w	Knuckles_RollLeft

loc_3161D8:					  ; ...
		btst	#3,($FFFFF602).w
		beq.s	Knuckles_Apply_RollSpeed
		bsr.w	Knuckles_RollRight

Knuckles_Apply_RollSpeed:			  ; ...
		move.w	$14(a0),d0
		beq.s	Knuckles_CheckRollStop
		bmi.s	Knuckles_ApplyRollSpeedLeft
		sub.w	d5,d0
		bcc.s	loc_3161F4
		move.w	#0,d0

loc_3161F4:					  ; ...
		move.w	d0,$14(a0)
		bra.s	Knuckles_CheckRollStop
; ---------------------------------------------------------------------------

Knuckles_ApplyRollSpeedLeft:			  ; ...
		add.w	d5,d0
		bcc.s	loc_316202
		move.w	#0,d0

loc_316202:					  ; ...
		move.w	d0,$14(a0)

Knuckles_CheckRollStop:				  ; ...
		tst.w	$14(a0)
		bne.s	ObjXX_Roll_ResetScreen
		tst.b	$39(a0)
		bne.s	Knuckles_KeepRolling
		bclr	#2,$22(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		move.b	#5,$1C(a0)
		subq.w	#5,$C(a0)
		bra.s	ObjXX_Roll_ResetScreen
; ---------------------------------------------------------------------------
; magically gives Knuckles an extra push if he's going to stop rolling where it's not allowed
; (such	as in an S-curve in HTZ	or a stopper chamber in	CNZ)


Knuckles_KeepRolling:				  ; ...
		move.w	#$400,$14(a0)
		btst	#0,$22(a0)
		beq.s	ObjXX_Roll_ResetScreen
		neg.w	$14(a0)

ObjXX_Roll_ResetScreen:				  ; ...
		cmp.w	#$60,($FFFFEED8).w
		beq.s	Knuckles_SetRollSpeeds
		bcc.s	loc_316250
		addq.w	#4,($FFFFEED8).w

loc_316250:					  ; ...
		subq.w	#2,($FFFFEED8).w

Knuckles_SetRollSpeeds:				  ; ...
		move.b	$26(a0),d0
		jsr	CalcSine
		muls.w	$14(a0),d0
		asr.l	#8,d0
		move.w	d0,$12(a0)
		muls.w	$14(a0),d1
		asr.l	#8,d1
		cmp.w	#$1000,d1
		ble.s	loc_316278
		move.w	#$1000,d1

loc_316278:					  ; ...
		cmp.w	#-$1000,d1
		bge.s	loc_316282
		move.w	#-$1000,d1

loc_316282:					  ; ...
		move.w	d1,$10(a0)
		bra.w	ObjXX_CheckWallsOnGround
; End of function Knuckles_RollSpeed


; =============== S U B	R O U T	I N E =======================================


Knuckles_RollLeft:				  ; ...
		move.w	$14(a0),d0
		beq.s	loc_316292
		bpl.s	Knuckles_BrakeRollingRight

loc_316292:					  ; ...
		bset	#0,$22(a0)
		move.b	#2,$1C(a0)
		rts
; ---------------------------------------------------------------------------

Knuckles_BrakeRollingRight:			  ; ...
		sub.w	d4,d0
		bcc.s	loc_3162A8
		move.w	#-$80,d0

loc_3162A8:					  ; ...
		move.w	d0,$14(a0)
		rts
; End of function Knuckles_RollLeft


; =============== S U B	R O U T	I N E =======================================


Knuckles_RollRight:				  ; ...
		move.w	$14(a0),d0
		bmi.s	Knuckles_BrakeRollingLeft
		bclr	#0,$22(a0)
		move.b	#2,$1C(a0)
		rts
; ---------------------------------------------------------------------------

Knuckles_BrakeRollingLeft:			  ; ...
		add.w	d4,d0
		bcc.s	loc_3162CA
		move.w	#$80,d0

loc_3162CA:					  ; ...
		move.w	d0,$14(a0)
		rts
; End of function Knuckles_RollRight

; ---------------------------------------------------------------------------
; Subroutine for moving	Knuckles left or right when he's in the air
; ---------------------------------------------------------------------------

; =============== S U B	R O U T	I N E =======================================


Knuckles_ChgJumpDir:				  ; ...
		move.w	($FFFFF760).w,d6
		move.w	($FFFFF762).w,d5
		asl.w	#1,d5
		btst	#4,$22(a0)
		bne.s	ObjXX_Jump_ResetScreen
		move.w	$10(a0),d0
		btst	#2,($FFFFF602).w
		beq.s	loc_31630E
		bset	#0,$22(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_31630E
		tst.w	($FFFFFFD0).w
		bne.w	loc_31630C
		add.w	d5,d0
		cmp.w	d1,d0
		ble.s	loc_31630E

loc_31630C:					  ; ...
		move.w	d1,d0

loc_31630E:					  ; ...
		btst	#3,($FFFFF602).w
		beq.s	loc_316332
		bclr	#0,$22(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_316332
		tst.w	($FFFFFFD0).w
		bne.w	loc_316330
		sub.w	d5,d0
		cmp.w	d6,d0
		bge.s	loc_316332

loc_316330:					  ; ...
		move.w	d6,d0

loc_316332:					  ; ...
		move.w	d0,$10(a0)

ObjXX_Jump_ResetScreen:				  ; ...
		cmp.w	#$60,($FFFFEED8).w
		beq.s	Knuckles_JumpPeakDecelerate
		bcc.s	loc_316344
		addq.w	#4,($FFFFEED8).w

loc_316344:					  ; ...
		subq.w	#2,($FFFFEED8).w

Knuckles_JumpPeakDecelerate:			  ; ...
		cmp.w	#-$400,$12(a0)
		bcs.s	return_316376
		move.w	$10(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	return_316376
		bmi.s	Knuckles_JumpPeakDecelerateLeft
		sub.w	d1,d0
		bcc.s	loc_316364
		move.w	#0,d0

loc_316364:					  ; ...
		move.w	d0,$10(a0)
		rts
; ---------------------------------------------------------------------------

Knuckles_JumpPeakDecelerateLeft:		  ; ...
		sub.w	d1,d0
		bcs.s	loc_316372
		move.w	#0,d0

loc_316372:					  ; ...
		move.w	d0,$10(a0)

return_316376:					  ; ...
		rts
; End of function Knuckles_ChgJumpDir


; =============== S U B	R O U T	I N E =======================================


Knuckles_LevelBoundaries:			  ; ...
		move.l	8(a0),d1
		move.w	$10(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	($FFFFEEC8).w,d0
		add.w	#$10,d0
		cmp.w	d1,d0
		bhi.s	Knuckles_Boundary_Sides
		move.w	($FFFFEECA).w,d0
		add.w	#$128,d0
		tst.b	($FFFFF7AA).w
		bne.s	loc_3163A6
		add.w	#$40,d0

loc_3163A6:					  ; ...
		cmp.w	d1,d0
		bls.s	Knuckles_Boundary_Sides

Knuckles_Boundary_CheckBottom:			  ; ...
		move.w	($FFFFEECE).w,d0
		add.w	#$E0,d0
		cmp.w	$C(a0),d0
		blt.s	Knuckles_Boundary_Bottom
		rts
; ---------------------------------------------------------------------------

Knuckles_Boundary_Bottom:			  ; ...
		jmp	KillCharacter
; ---------------------------------------------------------------------------

Knuckles_Boundary_Sides:			  ; ...
		move.w	d0,8(a0)
		move.w	#0,$A(a0)
		move.w	#0,$10(a0)
		move.w	#0,$14(a0)
		bra.s	Knuckles_Boundary_CheckBottom
; End of function Knuckles_LevelBoundaries


; =============== S U B	R O U T	I N E =======================================


Knuckles_Roll:					  ; ...
		tst.b	$2B(a0)
		bmi.s	ObjXX_NoRoll
		move.w	$14(a0),d0
		bpl.s	loc_3163E6
		neg.w	d0

loc_3163E6:					  ; ...
		cmp.w	#$80,d0
		bcs.s	ObjXX_NoRoll
		move.b	($FFFFF602).w,d0
		and.b	#$C,d0
		bne.s	ObjXX_NoRoll
		btst	#1,($FFFFF602).w
		bne.s	ObjXX_ChkRoll

ObjXX_NoRoll:					  ; ...
		rts
; ---------------------------------------------------------------------------

ObjXX_ChkRoll:					  ; ...
		btst	#2,$22(a0)
		beq.s	ObjXX_DoRoll
		rts
; ---------------------------------------------------------------------------

ObjXX_DoRoll:					  ; ...
		bset	#2,$22(a0)
		move.b	#$E,$16(a0)
		move.b	#7,$17(a0)
		move.b	#2,$1C(a0)
		addq.w	#5,$C(a0)
		move.w	#$BE,d0
		jsr	PlaySound
		tst.w	$14(a0)
		bne.s	return_31643C
		move.w	#$200,$14(a0)

return_31643C:					  ; ...
		rts
; End of function Knuckles_Roll


; =============== S U B	R O U T	I N E =======================================


Knuckles_Jump:					  ; ...
		move.b	($FFFFF603).w,d0
		and.b	#$70,d0
		beq.w	return_3164EC
		moveq	#0,d0
		move.b	$26(a0),d0
		add.b	#$80,d0
		bsr.w	CalcRoomOverHead
		cmp.w	#6,d1
		blt.w	return_3164EC
		move.w	#$600,d2
		btst	#6,$22(a0)
		beq.s	loc_316470
		move.w	#$300,d2

loc_316470:					  ; ...
		tst.w	($FFFFFFD0).w		  ; Check for demo mode	(note: in normal Sonic 2, this is the level select flag!)
		beq.s	loc_31647A
		add.w	#$80,d2			  ; Set	the jump height	to Sonic's height in Demo mode because Sonic Team were too lazy to record new demos for S2&K.

loc_31647A:					  ; ...
		moveq	#0,d0
		move.b	$26(a0),d0
		sub.b	#$40,d0
		jsr	CalcSine
		muls.w	d2,d1
		asr.l	#8,d1
		add.w	d1,$10(a0)
		muls.w	d2,d0
-:	dc.b $00,$06,$05,$03,$02,$04,$0C,$0D,$0E,$0F,$0A,$0B,$07,$08,$09,$01; 0	; ...
		dc.b $60,$66,$65,$63,$62,$64,$6C,$6D,$6E,$6F,$6A,$6B,$67,$68,$69,$61; 16
		dc.b $50,$56,$55,$53,$52,$54,$5C,$5D,$5E,$5F,$5A,$5B,$57,$58,$59,$51; 32
		dc.b $30,$36,$35,$33,$32,$34,$3C,$3D,$3E,$3F,$3A,$3B,$37,$38,$39,$31; 48
		dc.b $20,$26,$25,$23,$22,$24,$2C,$2D,$2E,$2F,$2A,$2B,$27,$28,$29,$21; 64
		dc.b $40,$46,$45,$43,$42,$44,$4C,$4D,$4E,$4F,$4A,$4B,$47,$48,$49,$41; 80
		dc.b $C0,$C6,$C5,$C3,$C2,$C4,$CC,$CD,$CE,$CF,$CA,$CB,$C7,$C8,$C9,$C1; 96
		dc.b $D0,$D6,$D5,$D3,$D2,$D4,$DC,$DD,$DE,$DF,$DA,$DB,$D7,$D8,$D9,$D1; 112
		dc.b $E0,$E6,$E5,$E3,$E2,$E4,$EC,$ED,$EE,$EF,$EA,$EB,$E7,$E8,$E9,$E1; 128
		dc.b $F0,$F6,$F5,$F3,$F2,$F4,$FC,$FD,$FE,$FF,$FA,$FB,$F7,$F8,$F9,$F1; 144
		dc.b $A0,$A6,$A5,$A3,$A2,$A4,$AC,$AD,$AE,$AF,$AA,$AB,$A7,$A8,$A9,$A1; 160
		dc.b $B0,$B6,$B5,$B3,$B2,$B4,$BC,$BD,$BE,$BF,$BA,$BB,$B7,$B8,$B9,$B1; 176
		dc.b $70,$76,$75,$73,$72,$74,$7C,$7D,$7E,$7F,$7A,$7B,$77,$78,$79,$71; 192
		dc.b $80,$86,$85,$83,$82,$84,$8C,$8D,$8E,$8F,$8A,$8B,$87,$88,$89,$81; 208
		dc.b $90,$96,$95,$93,$92,$94,$9C,$9D,$9E,$9F,$9A,$9B,$97,$98,$99,$91; 224
		dc.b $10,$16,$15,$13,$12,$14,$1C,$1D,$1E,$1F,$1A,$1B,$17,$18,$19,$11; 240
; ---------------------------------------------------------------------------
;
; Tails	dynamic	PLC routine. Used by Tails in the Tornado in Wing Fortress and Sky Chase, I believe...
;
; START	OF FUNCTION CHUNK FOR sub_333D66

LoadTailsDynPLC:				  ; ...
		cmp.b	($FFFFF7DE).w,d0
		beq.s	return_31768C
		move.b	d0,($FFFFF7DE).w
		lea	(S2_MapRUnc_Tails).l,a2	  ; S2_MapRUnc_Tails (TailsDynPLC)
		add.w	d0,d0
		add.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	return_31768C
		move.w	#$F400,d4

TPLC_ReadEntry:					  ; ...
		moveq	#0,d1
		move.w	(a2)+,d1
		move.w	d1,d3
		lsr.w	#8,d3
		and.w	#$F0,d3
		add.w	#$10,d3
		and.w	#$FFF,d1
		lsl.l	#5,d1
		add.l	#S2_ArtUnc_Tails,d1	  ; S2_ArtUnc_Tails
		move.w	d4,d2
		add.w	d3,d4
		add.w	d3,d4
		jsr	QueueDMATransfer
		dbf	d5,TPLC_ReadEntry

return_31768C:					  ; ...
		rts
; END OF FUNCTION CHUNK	FOR sub_333D66
; ---------------------------------------------------------------------------

Obj0A:						  ; ...
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_31769C(pc,d0.w),d1
		jmp	off_31769C(pc,d1.w)
; ---------------------------------------------------------------------------
off_31769C:	dc.w loc_3176AE-off_31769C	  ; 0 ;	...
		dc.w loc_317706-off_31769C	  ; 1
		dc.w loc_317712-off_31769C	  ; 2
		dc.w loc_317788-off_31769C	  ; 3
		dc.w loc_31779C-off_31769C	  ; 4
		dc.w loc_317974-off_31769C	  ; 5
		dc.w loc_3177A2-off_31769C	  ; 6
		dc.w loc_31777C-off_31769C	  ; 7
		dc.w loc_31779C-off_31769C	  ; 8
; ---------------------------------------------------------------------------

loc_3176AE:					  ; ...
		addq.b	#2,$24(a0)
		move.l	#Map_Obj24,4(a0)
		tst.b	$3F(a0)
		beq.s	loc_3176C8
		move.l	#Map_Obj24_0,4(a0)

loc_3176C8:					  ; ...
		move.w	#$855B,2(a0)
		move.b	#$84,1(a0)
		move.b	#$10,$19(a0)
		move.b	#1,$18(a0)
		move.b	$28(a0),d0
		bpl.s	loc_3176F6
		addq.b	#8,$24(a0)
		and.w	#$7F,d0
		move.b	d0,$33(a0)
		bra.w	loc_317974
; ---------------------------------------------------------------------------

loc_3176F6:					  ; ...
		move.b	d0,$1C(a0)
		move.w	8(a0),$30(a0)
		move.w	#-$88,$12(a0)

loc_317706:					  ; ...
		lea	(Ani_Obj0A).l,a1
		jsr	AnimateSprite

loc_317712:					  ; ...
		move.w	($FFFFF646).w,d0
		cmp.w	$C(a0),d0
		bcs.s	loc_317738
		move.b	#6,$24(a0)
		addq.b	#7,$1C(a0)
		cmp.b	#$D,$1C(a0)
		beq.s	loc_317788
		bcs.s	loc_317788
		move.b	#$D,$1C(a0)
		bra.s	loc_317788
; ---------------------------------------------------------------------------

loc_317738:					  ; ...
		tst.b	($FFFFF7C7).w
		beq.s	loc_317742
		addq.w	#4,$30(a0)

loc_317742:					  ; ...
		move.b	$26(a0),d0
		addq.b	#1,$26(a0)
		and.w	#$7F,d0
		lea	(Obj0A_WobbleData).l,a1
		move.b	(a1,d0.w),d0
		ext.w	d0
		add.w	$30(a0),d0
		move.w	d0,8(a0)
		bsr.s	sub_3177E2
		jsr	ObjectMove		  ; AKA	SpeedToPos in Sonic 1
		tst.b	1(a0)
		bpl.s	loc_317776
		jmp	DisplaySprite
; ---------------------------------------------------------------------------

loc_317776:					  ; ...
		jmp	DeleteObject
; ---------------------------------------------------------------------------

loc_31777C:					  ; ...
		move.l	$3C(a0),a2
		cmp.b	#$C,$28(a2)
		bhi.s	loc_31779C

loc_317788:					  ; ...
		bsr.s	sub_3177E2
		lea	(Ani_Obj0A).l,a1
		jsr	AnimateSprite
		jmp	DisplaySprite
; ---------------------------------------------------------------------------

loc_31779C:					  ; ...
		jmp	DeleteObject
; ---------------------------------------------------------------------------

loc_3177A2:					  ; ...
		move.l	$3C(a0),a2
		cmp.b	#$C,$28(a2)
		bhi.s	loc_3177DC
		subq.w	#1,$38(a0)
		bne.s	loc_3177C0
		move.b	#$E,$24(a0)
		addq.b	#7,$1C(a0)
		bra.s	loc_317788
; ---------------------------------------------------------------------------

loc_3177C0:					  ; ...
		lea	(Ani_Obj0A).l,a1
		jsr	AnimateSprite
		bsr.w	sub_31792E
		tst.b	1(a0)
		bpl.s	loc_3177DC
		jmp	DisplaySprite
; ---------------------------------------------------------------------------

loc_3177DC:					  ; ...
		jmp	DeleteObject

; =============== S U B	R O U T	I N E =======================================


sub_3177E2:					  ; ...
		tst.w	$38(a0)
		beq.s	return_31782C
		subq.w	#1,$38(a0)
		bne.s	return_31782C
		cmp.b	#7,$1C(a0)
		bcc.s	return_31782C
		move.w	#$F,$38(a0)
		clr.w	$12(a0)
		move.b	#$80,1(a0)
		move.w	8(a0),d0
		sub.w	($FFFFEE00).w,d0
		add.w	#$80,d0
		move.w	d0,8(a0)
		move.w	$C(a0),d0
		sub.w	($FFFFEE04).w,d0
		add.w	#$80,d0
		move.w	d0,$A(a0)
		move.b	#$C,$24(a0)

return_31782C:					  ; ...
		rts
; End of function sub_3177E2

; ---------------------------------------------------------------------------
Obj0A_WobbleData:dc.b	 0,   0,   0,	0,   0,	  0; 0 ; ...
		dc.b	1,   1,	  1,   1,   1,	 2; 6
		dc.b	2,   2,	  2,   2,   2,	 2; 12
		dc.b	3,   3,	  3,   3,   3,	 3; 18
		dc.b	3,   3,	  3,   3,   3,	 3; 24
		dc.b	3,   3,	  3,   3,   3,	 3; 30
		dc.b	3,   3,	  3,   3,   3,	 3; 36
		dc.b	3,   3,	  3,   3,   3,	 2; 42
		dc.b	2,   2,	  2,   2,   2,	 2; 48
		dc.b	1,   1,	  1,   1,   1,	 0; 54
		dc.b	0,   0,	  0,   0,   0,	-1; 60
		dc.b   -1,  -1,	 -1,  -1,  -2,	-2; 66
		dc.b   -2,  -2,	 -2,  -3,  -3,	-3; 72
		dc.b   -3,  -3,	 -3,  -3,  -4,	-4; 78
		dc.b   -4,  -4,	 -4,  -4,  -4,	-4; 84
		dc.b   -4,  -4,	 -4,  -4,  -4,	-4; 90
		dc.b   -4,  -4,	 -4,  -4,  -4,	-4; 96
		dc.b   -4,  -4,	 -4,  -4,  -4,	-4; 102
		dc.b   -4,  -4,	 -4,  -3,  -3,	-3; 108
		dc.b   -3,  -3,	 -3,  -3,  -2,	-2; 114
		dc.b   -2,  -2,	 -2,  -1,  -1,	-1; 120
		dc.b   -1,  -1,	  0,   0,   0,	 0; 126
		dc.b	0,   0,	  1,   1,   1,	 1; 132
		dc.b	1,   2,	  2,   2,   2,	 2; 138
		dc.b	2,   2,	  3,   3,   3,	 3; 144
		dc.b	3,   3,	  3,   3,   3,	 3; 150
		dc.b	3,   3,	  3,   3,   3,	 3; 156
		dc.b	3,   3,	  3,   3,   3,	 3; 162
		dc.b	3,   3,	  3,   3,   3,	 3; 168
		dc.b	3,   2,	  2,   2,   2,	 2; 174
		dc.b	2,   2,	  1,   1,   1,	 1; 180
		dc.b	1,   0,	  0,   0,   0,	 0; 186
		dc.b	0,  -1,	 -1,  -1,  -1,	-1; 192
		dc.b   -2,  -2,	 -2,  -2,  -2,	-3; 198
		dc.b   -3,  -3,	 -3,  -3,  -3,	-3; 204
		dc.b   -4,  -4,	 -4,  -4,  -4,	-4; 210
		dc.b   -4,  -4,	 -4,  -4,  -4,	-4; 216
		dc.b   -4,  -4,	 -4,  -4,  -4,	-4; 222
		dc.b   -4,  -4,	 -4,  -4,  -4,	-4; 228
		dc.b   -4,  -4,	 -4,  -4,  -4,	-3; 234
		dc.b   -3,  -3,	 -3,  -3,  -3,	-3; 240
		dc.b   -2,  -2,	 -2,  -2,  -2,	-1; 246
		dc.b   -1,  -1,	 -1,  -1	  ; 252

; =============== S U B	R O U T	I N E =======================================


sub_31792E:					  ; ...
		moveq	#0,d1
		move.b	$1A(a0),d1
		cmp.b	#8,d1
		bcs.s	return_317972
		cmp.b	#$E,d1
		bcc.s	return_317972
		cmp.b	$2E(a0),d1
		beq.s	return_317972
		move.b	d1,$2E(a0)
		subq.w	#8,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		lsl.w	#6,d1
		add.l	#S2_ArtUnc_Countdown,d1
		move.w	#$9380,d2
		tst.b	$3F(a0)
		beq.s	loc_317968
		move.w	#$9180,d2

loc_317968:					  ; ...
		move.w	#$60,d3
		jsr	QueueDMATransfer

return_317972:					  ; ...
		rts
; End of function sub_31792E

; ---------------------------------------------------------------------------

loc_317974:					  ; ...
		move.l	$3C(a0),a2
		tst.w	$2C(a0)
		bne.w	loc_317A76
		cmp.b	#6,$24(a2)
		bcc.w	return_317B8A
		btst	#6,$22(a2)
		beq.w	return_317B8A
		subq.w	#1,$38(a0)
		bpl.w	loc_317A9A
		move.w	#$3B,$38(a0)
		move.w	#1,$36(a0)
		jsr	RandomNumber
		and.w	#1,d0
		move.b	d0,$34(a0)
		moveq	#0,d0
		move.b	$28(a2),d0
		cmp.w	#$19,d0
		beq.s	loc_3179FA
		cmp.w	#$14,d0
		beq.s	loc_3179FA
		cmp.w	#$F,d0
		beq.s	loc_3179FA
		cmp.w	#$C,d0
		bhi.s	loc_317A0A
		bne.s	loc_3179E6
		tst.b	$3F(a0)
		bne.s	loc_3179E6
		move.w	#$9F,d0
		jsr	PlayMusic

loc_3179E6:					  ; ...
		subq.b	#1,$32(a0)
		bpl.s	loc_317A0A
		move.b	$33(a0),$32(a0)
		bset	#7,$36(a0)
		bra.s	loc_317A0A
; ---------------------------------------------------------------------------

loc_3179FA:					  ; ...
		tst.b	$3F(a0)
		bne.s	loc_317A0A
		move.w	#$C2,d0
		jsr	PlaySound

loc_317A0A:					  ; ...
		subq.b	#1,$28(a2)
		bcc.w	loc_317A98
		move.b	#$81,$2A(a2)
		move.w	#$B2,d0
		jsr	PlaySound
		move.b	#$A,$34(a0)
		move.w	#1,$36(a0)
		move.w	#$78,$2C(a0)
		move.l	a2,a1
		bsr.w	ResumeMusic
		move.l	a0,-(sp)
		move.l	a2,a0
		bsr.w	Knuckles_ResetOnFloor_Part2
		move.b	#$17,$1C(a0)
		bset	#1,$22(a0)
		bset	#7,2(a0)
		move.w	#0,$12(a0)
		move.w	#0,$10(a0)
		move.w	#0,$14(a0)
		move.l	(sp)+,a0
		cmp.w	#$B000,a2
		bne.s	return_317A74
		move.b	#1,($FFFFEEDC).w

return_317A74:					  ; ...
		rts
; ---------------------------------------------------------------------------

loc_317A76:					  ; ...
		subq.w	#1,$2C(a0)
		bne.s	loc_317A84
		move.b	#6,$24(a2)
		rts
; ---------------------------------------------------------------------------

loc_317A84:					  ; ...
		move.l	a0,-(sp)
		move.l	a2,a0
		jsr	ObjectMove		  ; AKA	SpeedToPos in Sonic 1
		add.w	#$10,$12(a0)
		move.l	(sp)+,a0
		bra.s	loc_317A9A
; ---------------------------------------------------------------------------

loc_317A98:					  ; ...
		bra.s	loc_317AAA
; ---------------------------------------------------------------------------

loc_317A9A:					  ; ...
		tst.w	$36(a0)
		beq.w	return_317B8A
		subq.w	#1,$3A(a0)
		bpl.w	return_317B8A

loc_317AAA:					  ; ...
		jsr	RandomNumber
		and.w	#$F,d0
		addq.w	#8,d0
		move.w	d0,$3A(a0)
		jsr	SingleObjLoad
		bne.w	return_317B8A
		move.b	0(a0),0(a1)
		move.w	8(a2),8(a1)
		moveq	#6,d0
		btst	#0,$22(a2)
		beq.s	loc_317AE2
		neg.w	d0
		move.b	#$40,$26(a1)

loc_317AE2:					  ; ...
		add.w	d0,8(a1)
		move.w	$C(a2),$C(a1)
		move.l	$3C(a0),$3C(a1)
		move.b	#6,$28(a1)
		tst.w	$2C(a0)
		beq.w	loc_317B34
		and.w	#7,$3A(a0)
		add.w	#0,$3A(a0)
		move.w	$C(a2),d0
		sub.w	#$C,d0
		move.w	d0,$C(a1)
		jsr	RandomNumber
		move.b	d0,$26(a1)
		move.w	($FFFFFE04).w,d0
		and.b	#3,d0
		bne.s	loc_317B80
		move.b	#$E,$28(a1)
		bra.s	loc_317B80
; ---------------------------------------------------------------------------

loc_317B34:					  ; ...
		btst	#7,$36(a0)
		beq.s	loc_317B80
		moveq	#0,d2
		move.b	$28(a2),d2
		cmp.b	#$C,d2
		bcc.s	loc_317B80
		lsr.w	#1,d2
		jsr	RandomNumber
		and.w	#3,d0
		bne.s	loc_317B68
		bset	#6,$36(a0)
		bne.s	loc_317B80
		move.b	d2,$28(a1)
		move.w	#$1C,$38(a1)

loc_317B68:					  ; ...
		tst.b	$34(a0)
		bne.s	loc_317B80
		bset	#6,$36(a0)
		bne.s	loc_317B80
		move.b	d2,$28(a1)
		move.w	#$1C,$38(a1)

loc_317B80:					  ; ...
		subq.b	#1,$34(a0)
		bpl.s	return_317B8A
		clr.w	$36(a0)

return_317B8A:					  ; ...
		rts

; =============== S U B	R O U T	I N E =======================================


ResumeMusic:					  ; ...
		cmp.b	#$C,$28(a1)
		bhi.s	loc_317BC6
		cmp.w	#$B000,a1
		bne.s	loc_317BC6
		move.w	($FFFFFF90).w,d0
		btst	#1,$2B(a1)
		beq.s	loc_317BAA
		move.w	#$97,d0

loc_317BAA:					  ; ...
		tst.b	($FFFFFE19).w
		beq.w	loc_317BB6
		move.w	#$96,d0

loc_317BB6:					  ; ...
		tst.b	($FFFFF7AA).w
		beq.s	loc_317BC0
		move.w	#$93,d0

loc_317BC0:					  ; ...
		jsr	PlayMusic

loc_317BC6:					  ; ...
		move.b	#$1E,$28(a1)
		rts
; End of function ResumeMusic

; ---------------------------------------------------------------------------
Ani_Obj0A:	dc.w byte_317BEC-Ani_Obj0A	  ; 0 ;	...
		dc.w byte_317BF5-Ani_Obj0A	  ; 1
		dc.w byte_317BFE-Ani_Obj0A	  ; 2
		dc.w byte_317C07-Ani_Obj0A	  ; 3
		dc.w byte_317C10-Ani_Obj0A	  ; 4
		dc.w byte_317C19-Ani_Obj0A	  ; 5
		dc.w byte_317C22-Ani_Obj0A	  ; 6
		dc.w byte_317C27-Ani_Obj0A	  ; 7
		dc.w byte_317C2F-Ani_Obj0A	  ; 8
		dc.w byte_317C37-Ani_Obj0A	  ; 9
		dc.w byte_317C3F-Ani_Obj0A	  ; 10
		dc.w byte_317C47-Ani_Obj0A	  ; 11
		dc.w byte_317C4F-Ani_Obj0A	  ; 12
		dc.w byte_317C57-Ani_Obj0A	  ; 13
		dc.w byte_317C59-Ani_Obj0A	  ; 14
byte_317BEC:	dc.b	5,   0,	  1,   2,   3,	 4,   8,   8,  -4; 0 ; ...
byte_317BF5:	dc.b	5,   0,	  1,   2,   3,	 4,   9,   9,  -4; 0 ; ...
byte_317BFE:	dc.b	5,   0,	  1,   2,   3,	 4,  $A,  $A,  -4; 0 ; ...
byte_317C07:	dc.b	5,   0,	  1,   2,   3,	 4,  $B,  $B,  -4; 0 ; ...
byte_317C10:	dc.b	5,   0,	  1,   2,   3,	 4,  $C,  $C,  -4; 0 ; ...
byte_317C19:	dc.b	5,   0,	  1,   2,   3,	 4,  $D,  $D,  -4; 0 ; ...
byte_317C22:	dc.b   $E,   0,	  1,   2,  -4	  ; 0 ;	...
byte_317C27:	dc.b	7, $10,	  8, $10,   8, $10,   8,  -4; 0	; ...
byte_317C2F:	dc.b	7, $10,	  9, $10,   9, $10,   9,  -4; 0	; ...
byte_317C37:	dc.b	7, $10,	 $A, $10,  $A, $10,  $A,  -4; 0	; ...
byte_317C3F:	dc.b	7, $10,	 $B, $10,  $B, $10,  $B,  -4; 0	; ...
byte_317C47:	dc.b	7, $10,	 $C, $10,  $C, $10,  $C,  -4; 0	; ...
byte_317C4F:	dc.b	7, $10,	 $D, $10,  $D, $10,  $D,  -4; 0	; ...
byte_317C57:	dc.b   $E,  -4			  ; 0 ;	...
byte_317C59:	dc.b   $E,   1,	  2,   3,   4,	-4,   0; 0 ; ...
; ---------------------------------------------------------------------------

Obj38:						  ; ...
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_317C6E(pc,d0.w),d1
		jmp	off_317C6E(pc,d1.w)
; ---------------------------------------------------------------------------
off_317C6E:	dc.w loc_317C72-off_317C6E,loc_317C9A-off_317C6E; 0 ; ...
; ---------------------------------------------------------------------------

loc_317C72:					  ; ...
		addq.b	#2,$24(a0)
		move.l	#Map_Obj38,4(a0)
		move.b	#4,1(a0)
		move.b	#1,$18(a0)
		move.b	#$18,$19(a0)
		move.w	#$4BE,2(a0)
		jsr	Adjust2PArtPointer

loc_317C9A:					  ; ...
		move.w	$3E(a0),a2
		btst	#1,$2B(a2)
		bne.s	return_317CE4
		btst	#0,$2B(a2)
		beq.s	loc_317CE6
		move.w	8(a2),8(a0)
		move.w	$C(a2),$C(a0)
		move.b	$22(a2),$22(a0)
		and.w	#$7FFF,2(a0)
		tst.w	2(a2)
		bpl.s	loc_317CD2
		or.w	#$8000,2(a0)

loc_317CD2:					  ; ...
		lea	(Ani_Obj38).l,a1
		jsr	AnimateSprite
		jmp	DisplaySprite
; ---------------------------------------------------------------------------

return_317CE4:					  ; ...
		rts
; ---------------------------------------------------------------------------

loc_317CE6:					  ; ...
		jmp	DeleteObject
; ---------------------------------------------------------------------------

; Object 35 - Invincibility Stars

Obj35:						  ; ...
		moveq	#0,d0
		move.b	$A(a0),d0
		move.w	off_317CFA(pc,d0.w),d1
		jmp	off_317CFA(pc,d1.w)
; ---------------------------------------------------------------------------
off_317CFA:	dc.w loc_317D12-off_317CFA	  ; 0 ;	...
		dc.w loc_317D7A-off_317CFA	  ; 1
		dc.w loc_317DEE-off_317CFA	  ; 2
		dc.l byte_317EFD
		dc.w $B
		dc.l byte_317F12
		dc.w $160D
		dc.l byte_317F2B
		dc.w $2C0D
; ---------------------------------------------------------------------------

loc_317D12:					  ; ...
		moveq	#0,d2
		lea	off_317CFA(pc),a2
		lea	(a0),a1
		moveq	#3,d1

loc_317D1C:					  ; ...
		move.b	0(a0),0(a1)
		move.b	#4,$A(a1)

loc_317D28:
		move.l	#Map_Obj35,4(a1)
		move.w	#$4DE,2(a1)
            	jsr	Adjust2PArtPointer
		move.b	#4,1(a1)
		bset	#6,1(a1)
		move.b	#$10,$E(a1)
		move.b	#2,$F(a1)
		move.w	$3E(a0),$3E(a1)
		move.b	d2,$36(a1)
		addq.w	#1,d2
		move.l	(a2)+,$30(a1)
		move.w	(a2)+,$34(a1)
		lea	$40(a1),a1
		dbf	d1,loc_317D1C
		move.b	#2,$A(a0)
		move.b	#4,$34(a0)

loc_317D7A:					  ; ...
		move.w	$3E(a0),a1
		btst	#1,$2B(a1)
		beq.w	DeleteObject
		move.w	8(a1),d0
		move.w	d0,8(a0)
		move.w	$C(a1),d1
		move.w	d1,$C(a0)
		lea	$10(a0),a2
		lea	byte_317EF0(pc),a3
		moveq	#0,d5

loc_317DA2:					  ; ...
		move.w	$38(a0),d2
		move.b	(a3,d2.w),d5
		bpl.s	loc_317DB2
		clr.w	$38(a0)
		bra.s	loc_317DA2
; ---------------------------------------------------------------------------

loc_317DB2:					  ; ...
		addq.w	#1,$38(a0)
		lea	word_317EB0(pc),a6
		move.b	$34(a0),d6
		jsr	routine_317E9A(pc)
		move.w	d2,(a2)+
		move.w	d3,(a2)+
		move.w	d5,(a2)+
		add.w	#$20,d6
		jsr	routine_317E9A(pc)
		move.w	d2,(a2)+
		move.w	d3,(a2)+
		move.w	d5,(a2)+
		moveq	#$12,d0
		btst	#0,$22(a1)
		beq.s	loc_317DE2
		neg.w	d0

loc_317DE2:					  ; ...
		add.b	d0,$34(a0)
		move.w	#$80,d0
		bra.w	loc_312DBC
; ---------------------------------------------------------------------------

loc_317DEE:					  ; ...
		move.w	$3E(a0),a1
		btst	#1,$2B(a1)
		beq.w	DeleteObject
		cmp.w	#2,($FFFFFF70).w
		beq.s	loc_317E12
		lea	($FFFFEED2).w,a5
		lea	($FFFFE500).w,a6
		tst.b	$3F(a0)
		beq.s	loc_317E1A

loc_317E12:					  ; ...
		lea	($FFFFEED6).w,a5
		lea	($FFFFE600).w,a6

loc_317E1A:					  ; ...
		move.b	$36(a0),d1
		lsl.b	#2,d1
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		move.w	(a5),d0
		sub.b	d1,d0
		lea	(a6,d0.w),a2
		move.w	(a2)+,d0
		move.w	(a2)+,d1
		move.w	d0,8(a0)
		move.w	d1,$C(a0)
		lea	$10(a0),a2
		move.l	$30(a0),a3

loc_317E42:					  ; ...
		move.w	$38(a0),d2
		move.b	(a3,d2.w),d5
		bpl.s	loc_317E52
		clr.w	$38(a0)
		bra.s	loc_317E42
; ---------------------------------------------------------------------------

loc_317E52:					  ; ...
		swap	d5
		add.b	$35(a0),d2
		move.b	(a3,d2.w),d5
		addq.w	#1,$38(a0)
		lea	word_317EB0(pc),a6
		move.b	$34(a0),d6
		jsr	routine_317E9A(pc)
		move.w	d2,(a2)+
		move.w	d3,(a2)+
		move.w	d5,(a2)+
		add.w	#$20,d6
		swap	d5
		jsr	routine_317E9A(pc)
		move.w	d2,(a2)+
		move.w	d3,(a2)+
		move.w	d5,(a2)+
		moveq	#2,d0
		btst	#0,$22(a1)
		beq.s	loc_317E8E
		neg.w	d0

loc_317E8E:					  ; ...
		add.b	d0,$34(a0)
		move.w	#$80,d0
		bra.w	loc_312DBC

; =============== S U B	R O U T	I N E =======================================


routine_317E9A:					  ; ...
		and.w	#$3E,d6
		move.b	(a6,d6.w),d2
		move.b	1(a6,d6.w),d3
		ext.w	d2
		ext.w	d3
		add.w	d0,d2
		add.w	d1,d3
		rts
; End of function routine_317E9A

; ---------------------------------------------------------------------------
word_317EB0:	dc.w   $F00,  $F03,  $E06,  $D08,  $B0B,  $80D,	 $60E; 0 ; ...
		dc.w   $30F,   $10, -$3F1, -$6F2, -$8F3, -$BF5,	-$DF8; 7
		dc.w  -$EFA, -$FFD,-$1000, -$F04, -$E07, -$D09,	-$B0C; 14
		dc.w  -$80E, -$60F, -$310,  -$10,  $3F0,  $6F1,	 $8F2; 21
		dc.w   $BF4,  $DF7,  $EF9,  $FFC  ; 28
byte_317EF0:	dc.b	8,   5,	  7,   6,   6,	 7,   5,   8,	6,   7;	0 ; ...
		dc.b	7,   6,	 -1		  ; 10
byte_317EFD:	dc.b	8,   7,	  6,   5,   4,	 3,   4,   5,	6,   7;	0 ; ...
		dc.b   -1,   3,	  4,   5,   6,	 7,   8,   7,	6,   5;	10
		dc.b	4			  ; 20
byte_317F12:	dc.b	8,   7,	  6,   5,   4,	 3,   2,   3,	4,   5;	0 ; ...
		dc.b	6,   7,	 -1,   2,   3,	 4,   5,   6,	7,   8;	10
		dc.b	7,   6,	  5,   4,   3	  ; 20
byte_317F2B:	dc.b	7,   6,	  5,   4,   3,	 2,   1,   2,	3,   4;	0 ; ...
		dc.b	5,   6,	 -1,   1,   2,	 3,   4,   5,	6,   7;	10
		dc.b	6,   5,	  4,   3,   2	  ; 20
Ani_Obj38:	dc.w byte_317F46-Ani_Obj38	  ; ...
byte_317F46:	dc.b	0,   5,	  0,   5,   1,	 5,   2,   5,	3,   5;	0 ; ...
		dc.b	4,  -1			  ; 10
Map_Obj38:	dc.w byte_317F5E-Map_Obj38	  ; 0 ;	...
		dc.w byte_317F78-Map_Obj38	  ; 1
		dc.w byte_317F92-Map_Obj38	  ; 2
		dc.w byte_317FAC-Map_Obj38	  ; 3
		dc.w byte_317FC6-Map_Obj38	  ; 4
		dc.w byte_317FE0-Map_Obj38	  ; 5
byte_317F5E:	dc.b	0,   4,-$10,   5,   0,	 0,  -1,-$10,-$10,   5;	0 ; ...
		dc.b	8,   0,	  0,   0,   0,	 5, $10,   0,  -1,-$10;	10
		dc.b	0,   5,	$18,   0,   0,	 0; 20
byte_317F78:	dc.b	0,   4,-$10,   5,   0,	 4,  -1,-$10,-$10,   5;	0 ; ...
		dc.b	8,   4,	  0,   0,   0,	 5, $10,   4,  -1,-$10;	10
		dc.b	0,   5,	$18,   4,   0,	 0; 20
byte_317F92:	dc.b	0,   4,-$10,   5,   0,	 8,  -1,-$10,-$10,   5;	0 ; ...
		dc.b	8,   8,	  0,   0,   0,	 5, $10,   8,  -1,-$10;	10
		dc.b	0,   5,	$18,   8,   0,	 0; 20
byte_317FAC:	dc.b	0,   4,-$10,   5,   0,	$C,  -1,-$10,-$10,   5;	0 ; ...
		dc.b	8,  $C,	  0,   0,   0,	 5, $10,  $C,  -1,-$10;	10
		dc.b	0,   5,	$18,  $C,   0,	 0; 20
byte_317FC6:	dc.b	0,   4,-$10,   5,   0, $10,  -1,-$10,-$10,   5;	0 ; ...
		dc.b	8, $10,	  0,   0,   0,	 5, $10, $10,  -1,-$10;	10
		dc.b	0,   5,	$18, $10,   0,	 0; 20
byte_317FE0:	dc.b	0,   4,-$20,  $B,   0, $14,  -1,-$18,-$20,  $B;	0 ; ...
		dc.b	8, $14,	  0,   0,   0,	$B, $10, $14,  -1,-$18;	10
		dc.b	0,  $B,	$18, $14,   0,	 0; 20
Map_Obj35:	dc.w byte_31800C-Map_Obj35	  ; 0 ;	...
		dc.w byte_31800E-Map_Obj35	  ; 1
		dc.w byte_318016-Map_Obj35	  ; 2
		dc.w byte_31801E-Map_Obj35	  ; 3
		dc.w byte_318026-Map_Obj35	  ; 4
		dc.w byte_31802E-Map_Obj35	  ; 5
		dc.w byte_318036-Map_Obj35	  ; 6
		dc.w byte_31803E-Map_Obj35	  ; 7
		dc.w byte_318046-Map_Obj35	  ; 8
byte_31800C:	dc.b	0,   0			  ; 0 ;	...
byte_31800E:	dc.b	0,   1,	 -8,   1,   0,	 0,  -1,  -4; 0	; ...
byte_318016:	dc.b	0,   1,	 -8,   1,   0,	 2,  -1,  -4; 0	; ...
byte_31801E:	dc.b	0,   1,	 -8,   1,   0,	 4,  -1,  -4; 0	; ...
byte_318026:	dc.b	0,   1,	 -8,   1,   0,	 6,  -1,  -4; 0	; ...
byte_31802E:	dc.b	0,   1,	 -8,   1,   0,	 8,  -1,  -4; 0	; ...
byte_318036:	dc.b	0,   1,	 -8,   5,   0,	$A,  -1,  -8; 0	; ...
byte_31803E:	dc.b	0,   1,	 -8,   5,   0,	$E,  -1,  -8; 0	; ...
byte_318046:	dc.b	0,   1,-$10,  $F,   0, $12,  -1,-$10; 0	; ...
; ---------------------------------------------------------------------------
; ----------------------------------------------------
; Obj08	- Water	Splash,	Spindash dust, Skidding	dust
; ----------------------------------------------------


Obj08:						  ; ...
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	Obj08_Index(pc,d0.w),d1
		jmp	Obj08_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Obj08_Index:	dc.w Obj08_Init-Obj08_Index	  ; 0 ;	...
		dc.w Obj08_Main-Obj08_Index	  ; 1
		dc.w Obj08_Delete-Obj08_Index	  ; 2
		dc.w Obj08_CheckSkid-Obj08_Index  ; 3
; ---------------------------------------------------------------------------

Obj08_Init:					  ; ...
		addq.b	#2,$24(a0)
		move.l	#Map_Obj08,4(a0)
		or.b	#4,1(a0)
		move.b	#1,$18(a0)
		move.b	#$10,$19(a0)
		move.w	#$49C,2(a0)
		move.w	#$B000,$3E(a0)
		move.w	#$9380,$3C(a0)
		cmp.w	#$D100,a0
		beq.s	loc_3180BA
		move.b	#1,$34(a0)
		cmp.w	#2,($FFFFFF70).w
		beq.s	loc_3180BA
		move.w	#$48C,2(a0)
		move.w	#$B040,$3E(a0)
		move.w	#$9180,$3C(a0)

loc_3180BA:					  ; ...
		bsr.w	Adjust2PArtPointer2_Useless

Obj08_Main:					  ; ...
		move.w	$3E(a0),a2
		moveq	#0,d0
		move.b	$1C(a0),d0
		add.w	d0,d0
		move.w	Obj08_DisplayModes(pc,d0.w),d1
		jmp	Obj08_DisplayModes(pc,d1.w)
; ---------------------------------------------------------------------------


Obj08_DisplayModes:dc.w	Obj08_Display-Obj08_DisplayModes; 0 ; ...
		dc.w Obj08_MdSplash-Obj08_DisplayModes;	1
		dc.w Obj08_MdSpindash-Obj08_DisplayModes; 2
		dc.w Obj08_MdSkidding-Obj08_DisplayModes; 3
; ---------------------------------------------------------------------------

Obj08_MdSplash:					  ; ...
		move.w	($FFFFF646).w,$C(a0)
		tst.b	$1D(a0)
		bne.s	Obj08_Display
		move.w	8(a2),8(a0)
		move.b	#0,$22(a0)
		and.w	#$7FFF,2(a0)
		bra.s	Obj08_Display
; ---------------------------------------------------------------------------

Obj08_MdSpindash:				  ; ...
		cmp.b	#$C,$28(a2)
		bcs.s	Obj08_ResetDisplayMode
		cmp.b	#4,$24(a2)
		bcc.s	Obj08_ResetDisplayMode
		tst.b	$39(a2)
		beq.s	Obj08_ResetDisplayMode
		move.w	8(a2),8(a0)
		move.w	$C(a2),$C(a0)
		move.b	$22(a2),$22(a0)
		and.b	#1,$22(a0)
		tst.b	$34(a0)
		beq.s	loc_318134
		sub.w	#4,$C(a0)

loc_318134:					  ; ...
		tst.b	$1D(a0)
		bne.s	Obj08_Display
		and.w	#$7FFF,2(a0)
		tst.w	2(a2)
		bpl.s	Obj08_Display
		or.w	#$8000,2(a0)
		bra.s	Obj08_Display
; ---------------------------------------------------------------------------

Obj08_MdSkidding:				  ; ...
		cmp.b	#$C,$28(a2)
		bcs.s	Obj08_ResetDisplayMode

Obj08_Display:					  ; ...
		lea	(Ani_Obj08).l,a1
		jsr	AnimateSprite
		bsr.w	Obj08_LoadDPLC
		jmp	DisplaySprite
; ---------------------------------------------------------------------------

Obj08_ResetDisplayMode:				  ; ...
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

Obj08_Delete:					  ; ...
		jmp	DeleteObject
; ---------------------------------------------------------------------------

Obj08_CheckSkid:				  ; ...
		move.w	$3E(a0),a2
		moveq	#$10,d1
		cmp.b	#$D,$1C(a2)
		beq.s	Obj08_SkidDust
		moveq	#6,d1
		cmp.b	#3,$21(a2)
		beq.s	Obj08_SkidDust
		move.b	#2,$24(a0)
		move.b	#0,$32(a0)
		rts
; ---------------------------------------------------------------------------

Obj08_SkidDust:					  ; ...
		subq.b	#1,$32(a0)
		bpl.s	loc_318216
		move.b	#3,$32(a0)
		bsr.w	SingleObjLoad
		bne.s	loc_318216
		move.b	0(a0),0(a1)
		move.w	8(a2),8(a1)
		move.w	$C(a2),$C(a1)
		tst.b	$34(a0)
		beq.s	loc_3181CC
		subq.w	#4,d1

loc_3181CC:					  ; ...
		add.w	d1,$C(a1)
		move.b	#0,$22(a1)
		move.b	#3,$1C(a1)
		addq.b	#2,$24(a1)
		move.l	4(a0),4(a1)
		move.b	1(a0),1(a1)
		move.b	#1,$18(a1)
		move.b	#4,$19(a1)
		move.w	2(a0),2(a1)
		move.w	$3E(a0),$3E(a1)
		and.w	#$7FFF,2(a1)
		tst.w	2(a2)
		bpl.s	loc_318216
		or.w	#$8000,2(a1)

loc_318216:					  ; ...
		bsr.s	Obj08_LoadDPLC
		rts

; =============== S U B	R O U T	I N E =======================================


Obj08_LoadDPLC:					  ; ...
		moveq	#0,d0
		move.b	$1A(a0),d0
		cmp.b	$30(a0),d0
		beq.s	return_31826C
		move.b	d0,$30(a0)
		lea	(DPLC_SplashDust).l,a2
		add.w	d0,d0
		add.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	return_31826C
		move.w	$3C(a0),d4

loc_318240:					  ; ...
		moveq	#0,d1
		move.w	(a2)+,d1
		move.w	d1,d3
		lsr.w	#8,d3
		and.w	#$F0,d3
		add.w	#$10,d3
		and.w	#$FFF,d1
		lsl.l	#5,d1
		add.l	#S2_ArtUnc_Splash,d1	  ; S2_ArtUnc_Splash
		move.w	d4,d2
		add.w	d3,d4
		add.w	d3,d4
		jsr	QueueDMATransfer
		dbf	d5,loc_318240

return_31826C:					  ; ...
		rts
; End of function Obj08_LoadDPLC

; ---------------------------------------------------------------------------
Ani_Obj08:	dc.w Obj08Ani_Null-Ani_Obj08	  ; 0 ;	...
		dc.w Obj08Ani_Splash-Ani_Obj08	  ; 1
		dc.w Obj08Ani_Spindash-Ani_Obj08  ; 2
		dc.w Obj08Ani_Skid-Ani_Obj08	  ; 3
Obj08Ani_Null:	dc.b $1F,  0,$FF		  ; 0 ;	...
Obj08Ani_Splash:dc.b   3,  1,  2,  3,  4,  5,  6,  7,  8,  9,$FD,  0; 0	; ...
Obj08Ani_Spindash:dc.b	 1, $A,	$B, $C,	$D, $E,	$F,$10,$FF; 0 ;	...
Obj08Ani_Skid:	dc.b   3,$11,$12,$13,$14,$FC	  ; 0 ;	...


Map_Obj08:	dc.w word_3182C0-Map_Obj08	  ; 0 ;	...
		dc.w byte_3182C2-Map_Obj08	  ; 1
		dc.w byte_3182CA-Map_Obj08	  ; 2
		dc.w byte_3182D2-Map_Obj08	  ; 3
		dc.w byte_3182DA-Map_Obj08	  ; 4
		dc.w byte_3182E2-Map_Obj08	  ; 5
		dc.w byte_3182EA-Map_Obj08	  ; 6
		dc.w byte_3182F2-Map_Obj08	  ; 7
		dc.w byte_3182FA-Map_Obj08	  ; 8
		dc.w byte_318302-Map_Obj08	  ; 9
		dc.w byte_31830A-Map_Obj08	  ; 10
		dc.w byte_318312-Map_Obj08	  ; 11
		dc.w byte_31831A-Map_Obj08	  ; 12
		dc.w byte_318322-Map_Obj08	  ; 13
		dc.w byte_318330-Map_Obj08	  ; 14
		dc.w byte_31833E-Map_Obj08	  ; 15
		dc.w byte_31834C-Map_Obj08	  ; 16
		dc.w byte_31835A-Map_Obj08	  ; 17
		dc.w byte_318362-Map_Obj08	  ; 18
		dc.w byte_31836A-Map_Obj08	  ; 19
		dc.w byte_318372-Map_Obj08	  ; 20
		dc.w word_3182C0-Map_Obj08	  ; 21
word_3182C0:	dc.w 0				  ; ...
byte_3182C2:	dc.b	0,   1,	-$E,  $D,   0,	 0,  -1,-$10; 0	; ...
byte_3182CA:	dc.b	0,   1,-$1E,  $F,   0,	 0,  -1,-$10; 0	; ...
byte_3182D2:	dc.b	0,   1,-$1E,  $F,   0,	 0,  -1,-$10; 0	; ...
byte_3182DA:	dc.b	0,   1,-$1E,  $F,   0,	 0,  -1,-$10; 0	; ...
byte_3182E2:	dc.b	0,   1,-$1E,  $F,   0,	 0,  -1,-$10; 0	; ...
byte_3182EA:	dc.b	0,   1,-$1E,  $F,   0,	 0,  -1,-$10; 0	; ...
byte_3182F2:	dc.b	0,   1,	-$E,  $D,   0,	 0,  -1,-$10; 0	; ...
byte_3182FA:	dc.b	0,   1,	-$E,  $D,   0,	 0,  -1,-$10; 0	; ...
byte_318302:	dc.b	0,   1,	-$E,  $D,   0,	 0,  -1,-$10; 0	; ...
byte_31830A:	dc.b	0,   1,	  4,  $D,   0,	 0,  -1,-$20; 0	; ...
byte_318312:	dc.b	0,   1,	  4,  $D,   0,	 0,  -1,-$20; 0	; ...
byte_31831A:	dc.b	0,   1,	  4,  $D,   0,	 0,  -1,-$20; 0	; ...
byte_318322:	dc.b	0,   2,	-$C,   1,   0,	 0,  -1,-$18,	4,  $D;	0 ; ...
		dc.b	0,   2,	 -1,-$20	  ; 10
byte_318330:	dc.b	0,   2,	-$C,   5,   0,	 0,  -1,-$18,	4,  $D;	0 ; ...
		dc.b	0,   4,	 -1,-$20	  ; 10
byte_31833E:	dc.b	0,   2,	-$C,   9,   0,	 0,  -1,-$20,	4,  $D;	0 ; ...
		dc.b	0,   6,	 -1,-$20	  ; 10
byte_31834C:	dc.b	0,   2,	-$C,   9,   0,	 0,  -1,-$20,	4,  $D;	0 ; ...
		dc.b	0,   6,	 -1,-$20	  ; 10
byte_31835A:	dc.b	0,   1,	 -8,   5,   0,	 0,  -1,  -8; 0	; ...
byte_318362:	dc.b	0,   1,	 -8,   5,   0,	 4,  -1,  -8; 0	; ...
byte_31836A:	dc.b	0,   1,	 -8,   5,   0,	 8,  -1,  -8; 0	; ...
byte_318372:	dc.b	0,   1,	 -8,   5,   0,	$C,  -1,  -8; 0	; ...


DPLC_SplashDust:dc.w byte_3183A6-DPLC_SplashDust  ; 0 ;	...
		dc.w byte_3183A8-DPLC_SplashDust  ; 1
		dc.w byte_3183AC-DPLC_SplashDust  ; 2
		dc.w byte_3183B0-DPLC_SplashDust  ; 3
		dc.w byte_3183B4-DPLC_SplashDust  ; 4
		dc.w byte_3183B8-DPLC_SplashDust  ; 5
		dc.w byte_3183BC-DPLC_SplashDust  ; 6
		dc.w byte_3183C0-DPLC_SplashDust  ; 7
		dc.w byte_3183C4-DPLC_SplashDust  ; 8
		dc.w byte_3183C8-DPLC_SplashDust  ; 9
		dc.w byte_3183CC-DPLC_SplashDust  ; 10
		dc.w byte_3183D0-DPLC_SplashDust  ; 11
		dc.w byte_3183D4-DPLC_SplashDust  ; 12
		dc.w byte_3183D8-DPLC_SplashDust  ; 13
		dc.w byte_3183DE-DPLC_SplashDust  ; 14
		dc.w byte_3183E4-DPLC_SplashDust  ; 15
		dc.w byte_3183EA-DPLC_SplashDust  ; 16
		dc.w byte_3183F0-DPLC_SplashDust  ; 17
		dc.w byte_3183F0-DPLC_SplashDust  ; 18
		dc.w byte_3183F0-DPLC_SplashDust  ; 19
		dc.w byte_3183F0-DPLC_SplashDust  ; 20
		dc.w byte_3183F2-DPLC_SplashDust  ; 21
byte_3183A6:	dc.b	0,   0			  ; 0 ;	...
byte_3183A8:	dc.b	0,   1,	$70,   0	  ; 0 ;	...
byte_3183AC:	dc.b	0,   1,-$10,   8	  ; 0 ;	...
byte_3183B0:	dc.b	0,   1,-$10, $18	  ; 0 ;	...
byte_3183B4:	dc.b	0,   1,-$10, $28	  ; 0 ;	...
byte_3183B8:	dc.b	0,   1,-$10, $38	  ; 0 ;	...
byte_3183BC:	dc.b	0,   1,-$10, $48	  ; 0 ;	...
byte_3183C0:	dc.b	0,   1,	$70, $58	  ; 0 ;	...
byte_3183C4:	dc.b	0,   1,	$70, $60	  ; 0 ;	...
byte_3183C8:	dc.b	0,   1,	$70, $68	  ; 0 ;	...
byte_3183CC:	dc.b	0,   1,	$70, $70	  ; 0 ;	...
byte_3183D0:	dc.b	0,   1,	$70, $78	  ; 0 ;	...
byte_3183D4:	dc.b	0,   1,	$70,-$80	  ; 0 ;	...
byte_3183D8:	dc.b	0,   2,	$10,-$78, $70,-$76; 0 ;	...
byte_3183DE:	dc.b	0,   2,	$30,-$6E, $70,-$6A; 0 ;	...
byte_3183E4:	dc.b	0,   2,	$50,-$62, $70,-$5C; 0 ;	...
byte_3183EA:	dc.b	0,   2,	$50,-$54, $70,-$4E; 0 ;	...
byte_3183F0:	dc.b	0,   0			  ; 0 ;	...
byte_3183F2:	dc.b	0,   1,-$10,-$46	  ; 0 ;	...
; ---------------------------------------------------------------------------
; ----------------------------------------------
; Object 7E - Super Knuckles' stars
; ----------------------------------------------

Obj7E:						  ; ...
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	Obj7E_States(pc,d0.w),d1
		jmp	Obj7E_States(pc,d1.w)
; ---------------------------------------------------------------------------
Obj7E_States:	dc.w Obj7E_Init-Obj7E_States,Obj7E_Main-Obj7E_States; 0	; ...
; ---------------------------------------------------------------------------

Obj7E_Init:					  ; ...
		addq.b	#2,$24(a0)
		move.l	#Map_Obj7E,4(a0)
		move.b	#4,1(a0)
		move.b	#1,$18(a0)
		move.b	#$18,$19(a0)
		move.w	#$5F2,2(a0)
		jsr	Adjust2PArtPointer
		btst	#7,($FFFFB002).w
		beq.s	Obj7E_Main
		bset	#7,2(a0)

Obj7E_Main:					  ; ...
		tst.b	($FFFFFE19).w
		beq.s	Obj7E_Delete
		tst.b	$30(a0)
		beq.s	loc_31848E
		subq.b	#1,$1E(a0)
		bpl.s	loc_318476
		move.b	#1,$1E(a0)
		addq.b	#1,$1A(a0)
		cmp.b	#6,$1A(a0)
		bcs.s	loc_318476
		move.b	#0,$1A(a0)
		move.b	#0,$30(a0)
		move.b	#1,$31(a0)
		rts
; ---------------------------------------------------------------------------

loc_318476:					  ; ...
		tst.b	$31(a0)
		bne.s	Obj7E_Display

loc_31847C:					  ; ...
		move.w	($FFFFB008).w,8(a0)
		move.w	($FFFFB00C).w,$C(a0)

Obj7E_Display:					  ; ...
		jmp	DisplaySprite
; ---------------------------------------------------------------------------

loc_31848E:					  ; ...
		tst.b	($FFFFB02A).w
		bne.s	loc_3184B0
		move.w	($FFFFB014).w,d0
		bpl.s	loc_31849C
		neg.w	d0

loc_31849C:					  ; ...
		cmp.w	#$800,d0
		bcs.s	loc_3184B0
		move.b	#0,$1A(a0)
		move.b	#1,$30(a0)
		bra.s	loc_31847C
; ---------------------------------------------------------------------------

loc_3184B0:					  ; ...
		move.b	#0,$30(a0)
		move.b	#0,$31(a0)
		rts
; ---------------------------------------------------------------------------

Obj7E_Delete:					  ; ...
		jmp	DeleteObject
; ---------------------------------------------------------------------------
Map_Obj7E:	dc.w byte_3184D0-Map_Obj7E	  ; 0 ;	...
		dc.w byte_3184EA-Map_Obj7E	  ; 1
		dc.w byte_318504-Map_Obj7E	  ; 2
		dc.w byte_3184EA-Map_Obj7E	  ; 3
		dc.w byte_3184D0-Map_Obj7E	  ; 4
		dc.w byte_31851E-Map_Obj7E	  ; 5
byte_3184D0:	dc.b	0,   4,	 -8,   0,   0,	 0,  -1,  -8,  -8,   0;	0 ; ...
		dc.b	8,   0,	  0,   0,   0,	 0, $10,   0,  -1,  -8;	10
		dc.b	0,   0,	$18,   0,   0,	 0; 20
byte_3184EA:	dc.b	0,   4,-$10,   5,   0,	 1,  -1,-$10,-$10,   5;	0 ; ...
		dc.b	8,   1,	  0,   0,   0,	 5, $10,   1,  -1,-$10;	10
		dc.b	0,   5,	$18,   1,   0,	 0; 20
byte_318504:	dc.b	0,   4,-$18,  $A,   0,	 5,  -1,-$18,-$18,  $A;	0 ; ...
		dc.b	8,   5,	  0,   0,   0,	$A, $10,   5,  -1,-$18;	10
		dc.b	0,  $A,	$18,   5,   0,	 0; 20
byte_31851E:	dc.b	0,   0			  ; 0 ;	...

; =============== S U B	R O U T	I N E =======================================


AnglePos:					  ; ...

; FUNCTION CHUNK AT 0031867E SIZE 00000204 BYTES

		move.l	#$FFFFD600,($FFFFF796).w
		cmp.b	#$C,$3E(a0)
		beq.s	loc_318538
		move.l	#$FFFFD900,($FFFFF796).w

loc_318538:					  ; ...
		move.b	$3E(a0),d5
		btst	#3,$22(a0)
		beq.s	loc_318550
		moveq	#0,d0
		move.b	d0,($FFFFF768).w
		move.b	d0,($FFFFF76A).w
		rts
; ---------------------------------------------------------------------------

loc_318550:					  ; ...
		moveq	#3,d0
		move.b	d0,($FFFFF768).w
		move.b	d0,($FFFFF76A).w
		move.b	$26(a0),d0
		add.b	#$20,d0
		bpl.s	loc_318572
		move.b	$26(a0),d0
		bpl.s	loc_31856C
		subq.b	#1,d0

loc_31856C:					  ; ...
		add.b	#$20,d0
		bra.s	loc_31857E
; ---------------------------------------------------------------------------

loc_318572:					  ; ...
		move.b	$26(a0),d0
		bpl.s	loc_31857A
		addq.b	#1,d0

loc_31857A:					  ; ...
		add.b	#$1F,d0

loc_31857E:					  ; ...
		and.b	#$C0,d0
		cmp.b	#$40,d0
		beq.w	loc_3187D4
		cmp.b	#$80,d0
		beq.w	loc_318726
		cmp.b	#$C0,d0
		beq.w	Player_WalkVertR
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF768).w,a4
		move.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$17(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d3
		lea	($FFFFF76A).w,a4
		move.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Player_Angle
		tst.w	d1
		beq.s	return_318608
		bpl.s	loc_31860A
		cmp.w	#-$E,d1
		blt.s	return_318608
		add.w	d1,$C(a0)

return_318608:					  ; ...
		rts
; ---------------------------------------------------------------------------

loc_31860A:					  ; ...
		move.b	$10(a0),d0
		bpl.s	loc_318612
		neg.b	d0

loc_318612:					  ; ...
		addq.b	#4,d0
		cmp.b	#$E,d0
		bcs.s	loc_31861E
		move.b	#$E,d0

loc_31861E:					  ; ...
		cmp.b	d0,d1
		bgt.s	loc_318628

loc_318622:					  ; ...
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_318628:					  ; ...
		tst.b	$38(a0)
		bne.s	loc_318622
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)
		rts
; End of function AnglePos

; Subroutine to	change the player's angle as he walks along the floor

; =============== S U B	R O U T	I N E =======================================


Player_Angle:					  ; ...
		move.b	($FFFFF76A).w,d2
		cmp.w	d0,d1
		ble.s	loc_318650
		move.b	($FFFFF768).w,d2
		move.w	d0,d1

loc_318650:					  ; ...
		btst	#0,d2
		bne.s	loc_31866C
		move.b	d2,d0
		sub.b	$26(a0),d0
		bpl.s	loc_318660
		neg.b	d0

loc_318660:					  ; ...
		cmp.b	#$20,d0
		bcc.s	loc_31866C
		move.b	d2,$26(a0)
		rts
; ---------------------------------------------------------------------------

loc_31866C:					  ; ...
		move.b	$26(a0),d2
		add.b	#$20,d2
		and.b	#$C0,d2
		move.b	d2,$26(a0)
		rts
; End of function Player_Angle

; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Subroutine allowing the player to walk up a vertical slope/wall to his right
; ---------------------------------------------------------------------------

; START	OF FUNCTION CHUNK FOR AnglePos

Player_WalkVertR:				  ; ...
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF768).w,a4
		move.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF76A).w,a4
		move.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall
		move.w	(sp)+,d0
		bsr.w	Player_Angle
		tst.w	d1
		beq.s	return_3186EC
		bpl.s	loc_3186EE
		cmp.w	#-$E,d1
		blt.s	return_3186EC
		add.w	d1,8(a0)

return_3186EC:					  ; ...
		rts
; ---------------------------------------------------------------------------
; =============== S U B	R O U T	I N E =======================================

; Doesn't exist in S2

sub_3192E6:					  ; ...
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eor.w	#$F,d2
		lea	($FFFFF768).w,a4
		move.w	#-$10,a3
		move.w	#$800,d6
		bsr.w	FindFloor
		move.b	#$80,d2

loc_319306:
		bra.w	loc_318FE8
; End of function sub_3192E6

; START	OF FUNCTION CHUNK FOR CheckRightWallDist

loc_318FE8:					  ; ...
		move.b	($FFFFF768).w,d3
		btst	#0,d3
		beq.s	return_318FF4
		move.b	d2,d3

return_318FF4:					  ; ...
		rts
; END OF FUNCTION CHUNK	FOR CheckRightWallDist

; =============== S U B	R O U T	I N E =======================================


sub_318FF6:					  ; ...
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d2
		lea	($FFFFF768).w,a4
		move.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor
		move.b	#0,d2
		bra.s	loc_318FE8
; End of function sub_318FF6

; ---------------------------------------------------------------------------
; This doesn't exist in S2...
; START	OF FUNCTION CHUNK FOR sub_315C22

loc_319208:					  ; ...
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF768).w,a4
		move.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall
		move.b	#$C0,d2
		bra.w	loc_318FE8
; END OF FUNCTION CHUNK	FOR sub_315C22

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_315C22

loc_3193D2:					  ; ...
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eor.w	#$F,d3
		lea	($FFFFF768).w,a4
		move.w	#$FFF0,a3
		move.w	#$400,d6
		bsr.w	FindWall
		move.b	#$40,d2
		bra.w	loc_318FE8
; END OF FUNCTION CHUNK	FOR sub_315C22