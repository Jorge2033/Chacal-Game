.text
    .globl  main
    .globl  mostrarJuego
    .globl  crearTablero
    .globl  generarAleatorio
    .globl  visualizarTablero
    .globl  mostrarProgreso
    .globl  esperarEntrada

main:
    li      $v0,                4
    la      $a0,                tituloJuego
    syscall
    li      $v0,                4
    la      $a0,                mensajeBienvenida
    syscall
    jal     esperarEntrada

    li      $v0,                4
    la      $a0,                nuevaLinea
    syscall

    li      $v0,                4
    la      $a0,                mensajeCreacionTablero
    syscall
    jal     crearTablero

    lw      $s1,                tesorosDescubiertos
    lw      $s2,                estadoJuego
    lw      $s3,                todosTesorosEncontrados
    lw      $s4,                todosChacalesEncontrados
    lw      $s5,                dineroGanado
    lw      $s6,                chacalesDescubiertos

bucleJuego:
    li      $v0,                4
    la      $a0,                mensajeTablero
    syscall
    jal     visualizarTablero
    jal     mostrarProgreso
    li      $v0,                4
    la      $a0,                mensajeAleatorio
    syscall
    jal     generarAleatorio
    li      $v0,                1
    syscall
    move    $t0,                $a0

    jal     actualizarTablero

    li      $v0,                4
    la      $a0,                nuevaLinea
    syscall
    jal     visualizarTablero

    li      $v0,                10
    syscall

encontroChacal:
    li      $v0,                4
    la      $a0,                mensajeChacal
    syscall
encontroTesoro:
    li      $v0,                4
    la      $a0,                mensajeTesoro
    syscall
validarDescubrimiento:
    la      $t1,                tablero
    sll     $t3,                $t3,                2
    add     $t4,                $t3,                $t1

    jr      $ra
actualizarTablero:
    la      $t1,                descubiertas
    sll     $t0,                $t0,                2
    add     $t0,                $t0,                $t1
    lw      $t2,                0($t0)

    bnez    $t2,                yaDescubierto

    li      $t2,                1
    sw      $t2,                0($t0)

    jr      $ra

yaDescubierto:
    li      $v0,                4
    la      $a0,                mensajeCasillaDescubierta
    syscall

    jr      $ra
esperarEntrada:
    la      $a0,                mensajeContinuar
    syscall
    li      $v0,                8
    la      $a0,                espacio
    li      $a1,                2
    syscall
    li      $v0,                4
    la      $a0,                nuevaLinea
    syscall
    jr      $ra
mostrarProgreso:
    li      $v0,                4
    la      $a0,                mensajeDinero
    syscall
    li      $v0,                1
    move    $a0,                $s5
    syscall
    li      $v0,                4
    la      $a0,                nuevaLinea
    syscall
    li      $v0,                4
    la      $a0,                mensajeTesorosEncontrados
    syscall
    li      $v0,                1
    move    $a0,                $s1
    syscall
    li      $v0,                4
    la      $a0,                nuevaLinea
    syscall
    li      $v0,                4
    la      $a0,                mensajeChacalesEncontrados
    syscall
    li      $v0,                1
    move    $a0,                $s6
    syscall
    li      $v0,                4
    la      $a0,                nuevaLinea
    syscall
    jr      $ra
numeroAleatorio:
    li      $a1,                12
    li      $v0,                42
    syscall
    jr      $ra
crearTablero:
    li      $t0,                4
    addi    $sp,                $sp,                -4
    sw      $ra,                0($sp)

loopCreacionTablero:
    beq     $t0,                $zero,              exitLoopCreacionTablero
    jal     numeroAleatorio
    move    $t1,                $a0

    sll     $t1,                $t1,                2
    la      $t3,                tablero
    add     $t1,                $t1,                $t3

    lw      $t2,                0($t1)

    beq     $t2,                $zero,              continuarCreacionTablero
    sw      $zero,              0($t1)
    addi    $t0,                $t0,                -1

continuarCreacionTablero:
    j       loopCreacionTablero

exitLoopCreacionTablero:
    lw      $ra,                0($sp)
    addi    $sp,                $sp,                4

    jr      $ra

mostrarJuego:
    la      $t0,                tablero
    li      $t2,                12

loopMostrarTablero:
    beqz    $t2,                finMostrarTablero
    lw      $t5,                0($t0)
    beq     $t5,                0,                  imprimir0
    beq     $t5,                1,                  imprimir1

imprimir0:
    li      $v0,                4
    la      $a0,                mensaje0
    syscall
    j       siguienteElemento

imprimir1:
    li      $v0,                4
    la      $a0,                mensaje1
    syscall
    j       siguienteElemento

siguienteElemento:
    addi    $t0,                $t0,                4
    addi    $t2,                $t2,                -1
    j       loopMostrarTablero

finMostrarTablero:
    li      $v0,                4
    la      $a0,                nuevaLinea
    syscall

    jr      $ra

visualizarTablero:
    la      $t0,                descubiertas
    la      $t6,                tablero
    li      $t2,                12

loopVisualizarTablero:
    beqz    $t2,                finVisualizarTablero
    lw      $t5,                0($t0)
    lw      $t7,                0($t6)

    beq     $t5,                0,                  imprimirCasillaOculta
    la      $a0,                mensajeX
    syscall
    j       siguienteCasilla

imprimirCasillaOculta:
    li      $v0,                4
    la      $a0,                mensajeCasillaOculta
    syscall
    j       siguienteCasilla

siguienteCasilla:
    addi    $t0,                $t0,                4
    addi    $t6,                $t6,                4
    addi    $t2,                $t2,                -1
    j       loopVisualizarTablero

finVisualizarTablero:
    li      $v0,                4
    la      $a0,                nuevaLinea
    syscall

    jr      $ra
