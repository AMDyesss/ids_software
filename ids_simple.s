main:
	addi	sp,sp,-432
	sw	ra,424(sp)
	sw	s0,416(sp)
	addi	s0,sp,432
	sw	zero,-20(s0)
	li	a5,7
	sw	a5,-32(s0)
.L9:
	call	fifo_ctrl
	mv	a5,a0
	beq	a5,zero,.L9
	sw	zero,-24(s0)
	call	fifo_read
	mv	a5,a0
	mv	a4,a5
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-416(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
	j	.L3
.L5:
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-416(a5)
	lw	a5,-32(s0)
	bne	a5,a4,.L4
	li	a5,1
	sw	a5,-20(s0)
.L4:
	call	fifo_read
	mv	a5,a0
	mv	a4,a5
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-416(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L3:
	call	fifo_ctrl
	mv	a5,a0
	beq	a5,zero,.L5
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-416(a5)
	lw	a5,-32(s0)
	bne	a5,a4,.L6
	li	a5,1
	sw	a5,-20(s0)
.L6:
	call	fifo_read
	mv	a5,a0
	mv	a4,a5
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-416(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	bne	a5,zero,.L9
	sw	zero,-28(s0)
	j	.L7
.L8:
	lw	a5,-28(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-416(a5)
	mv	a0,a5
	call	output_packet_fragment
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L7:
	lw	a4,-28(s0)
	lw	a5,-24(s0)
	blt	a4,a5,.L8
	j	.L9

