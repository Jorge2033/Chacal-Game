.text   
    .globl  main
    .globl  mostrar_tablero
    .globl  crear_tablero
    .globl  numero_aleatorio
    .globl  visualizar_tablero
    .globl  mostrar_progreso
    .globl  esperar_entrada

main:                       
    li      $v0,                4
    la      $a0,                titulo
    syscall 
    li      $v0,                4                                                                                   
    la      $a0,                mensaje                                                                             
    syscall                                                                                                         
    jal     esperar_entrada                                                                                          

    li      $v0,                4                                                                                   
    la      $a0,                nueva_linea                                                                             
    syscall                                                                                                         

    li      $v0,                4
    la      $a0,                mensaje_creacion_tablero
    syscall 
    jal     crear_tablero

    lw      $s1,                tesorosDescubiertos                                                                 
    lw      $s2,                estadoJuego                                                                           
    lw      $s3,                todosTesorosEncontrados                                                                 
    lw      $s4,                todosChacalesEncontrados                                                                   
    lw      $s5,                dineroGanado
    lw      $s6,                chacalesDescubiertos

bucle_juego:                 
    li      $v0,                4
    la      $a0,                mensaje_tablero
    syscall 
    jal     visualizar_tablero
    jal     mostrar_progreso
    li      $v0,                4
    la      $a0,                mensajeAleatorio
    syscall 
    jal     numero_aleatorio
    li      $v0,                1                                                                                   
    syscall 
    move    $t0,                $a0

    jal     actualizar_tablero                                                                                     

    li      $v0,                4
    la      $a0,                nueva_linea
    syscall 
    jal     visualizar_tablero

    li      $v0,                10                                                                                  
    syscall 

encontro_chacal:             
    li      $v0,                4
    la      $a0,                mensaje_chacal
    syscall 
encontro_tesoro:             
    li      $v0,                4
    la      $a0,                mensaje_tesoro
    syscall 
validar_descubrimiento:            
    la      $t1,                tablero                                                                             
    sll     $t3,                $t3,                        2                                                      
    add     $t4,                $t3,                        $t1                                                    

    jr      $ra                                                                                                     
actualizar_tablero:         
    la      $t1,                descubiertas                                                                        
    sll     $t0,                $t0,                        2                                                      
    add     $t0,                $t0,                        $t1                                                    
    lw      $t2,                0($t0)                                                                              

    bnez    $t2,                ya_descubierto                                                                 

    li      $t2,                1                                                                                   
    sw      $t2,                0($t0)                                                                              

    jr      $ra                                                                                                     

ya_descubierto:        
    li      $v0,                4
    la      $a0,                mensaje_casilla_descubierta
    syscall 

    jr      $ra                                                                                                     
esperar_entrada:             
    la      $a0,                mensaje_continuar
    syscall 
    li      $v0,                8
    la      $a0,                espacio
    li      $a1,                2
    syscall 
    li      $v0,                4
    la      $a0,                nueva_linea
    syscall 
    jr      $ra                                                                                                     
mostrar_progreso:              
    li      $v0,                4
    la      $a0,                mensaje_dinero
    syscall 
    li      $v0,                1
    move    $a0,                $s5
    syscall 
    li      $v0,                4
    la      $a0,                nueva_linea
    syscall 
    li      $v0,                4
    la      $a0,                mensaje_tesoros_encontrados
    syscall 
    li      $v0,                1
    move    $a0,                $s1
    syscall 
    li      $v0,                4
    la      $a0,                nueva_linea
    syscall 
    li      $v0,                4
    la      $a0,                mensaje_chacales_encontrados
    syscall 
    li      $v0,                1
    move    $a0,                $s6
    syscall 
    li      $v0,                4
    la      $a0,                nueva_linea
    syscall 
    jr      $ra
numero_aleatorio:           
    li      $a1,                12
    li      $v0,                42
    syscall 
    jr      $ra
crear_tablero:            
    li      $t0,                4                                                                                   
    addi    $sp,                $sp,                        -4                                                      
    sw      $ra,                0($sp)                                                                              

loop:                       
    beq     $t0,                $zero,                      exitLoop
    jal     numero_aleatorio                                                                                       
    move    $t1,                $a0

    sll     $t1,                $t1,                        2
    la      $t3,                tablero
    add     $t1,                $t1,                        $t3

    lw      $t2,                0($t1)

    beq     $t2,                $zero,                      continue
    sw      $zero,              0($t1)
    addi    $t0,                $t0,                        -1

continue:                   
    j       loop

exitLoop:                   

    lw      $ra,                0($sp)
    addi    $sp,                $sp,                        4

    jr      $ra

mostrar_tablero:                
    la      $t0,                tablero                                                                             
    li      $t2,                12                                                                                  

loop_mostrar_tablero:                 
    beqz    $t2,                fin_mostrar_tablero                                                                         
    lw      $t5,                0($t0)                                                                              
    beq     $t5,                0,                          imprimir0                                                  
    beq     $t5,                1,                          imprimir1                                                  

imprimir0:                     
    li      $v0,                4                                                                                   
    la      $a0,                mensaje0                                                                            
    syscall 
    j       siguiente_elemento

imprimir1:                     
    li      $v0,                4                                                                                   
    la      $a0,                mensaje1                                                                            
    syscall 
    j       siguiente_elemento

siguiente_elemento:               
    addi    $t0,                $t0,                        4                                                      
    addi    $t2,                $t2,                        -1                                                     
    j       loop_mostrar_tablero                                                                                          

fin_mostrar_tablero:                  
    li      $v0,                4                                                                                   
    la      $a0,                nueva_linea
    syscall 

    jr      $ra
visualizar_tablero:              
    la      $t0,                descubiertas                                                                        
    la      $t6,                tablero                                                                             
    li      $t2,                12                                                                                  

loop_visualizar_tablero:                
    beqz    $t2,                fin_visualizar_tablero                                                                         
    lw      $t5,                0($t0)                                                                              
    lw      $t7,                0($t6)                                                                              

    beq     $t5,                0,                          imprimir_casilla_oculta                                      
    la      $a0,                mensaje_x
    syscall 
    j       siguiente_casilla

imprimir_casilla_oculta:       
    li      $v0,                4
    la      $a0,                mensaje_casilla_oculta
    syscall 
    j       siguiente_casilla

siguiente_casilla:            
    addi    $t0,                $t0,                        4
    addi    $t6,                $t6,                        4
    addi    $t2,                $t2,                        -1
    j       loop_visualizar_tablero

fin_visualizar_tablero:       
    li      $v0,                4
    la      $a0,                nueva_linea
    syscall 

    jr      $ra
