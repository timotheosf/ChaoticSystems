program SeeTrajectories
    use double_pendulum_mod
    use kinds_chaos
    use symplecf_mod
    implicit none
    real(dp), parameter :: PI = 3.14159265358979323846_dp
    !===================================================================
    ! PARÂMETROS DA SIMULAÇÃO
    !===================================================================
    !   Unstable 1: th1_0 = 0.5*PI , th2_0 = 0.75*PI , p1_0  = 0._dp , p2_0  = 0._dp
    !   Unstable 1: (pert): th1_0 = 0.5*PI+1.5d-5 , th2_0 = 0.75*PI , p1_0  = 0._dp , p2_0  = 0._dp
    !
    !
    !
    !
    real(dp), parameter :: th1_0 = 0.5*PI , th2_0 = 0.75*PI , p1_0  = 0._dp , p2_0  = 0._dp
    real(dp), parameter :: DT = 0.001_dp          ! Passo de tempo
    real(dp), parameter :: MAX_TIME = 200.0_dp   ! Tempo de integração por pixel
    real(dp), parameter :: OMEGA_TAO = 50.0_dp   ! Mola do integrador de Tao
    
    type(system_t), target :: sys
    type(tao4_t)           :: integ

    ! Variáveis de controle
    real(dp) :: current_time
    integer  :: i, j, step, max_steps, traj_unit
    real(dp), allocatable :: q_diff(:), p_diff(:)

    max_steps = int(MAX_TIME / DT)

    allocate(q_diff(2), p_diff(2))

    open(newunit=traj_unit, file='data/trajec_unstable_1.dat', status='replace')
    write(traj_unit, '(A)') '# t       th1       th2'

    print *, "Iniciando Trajetória Simulada do Pêndulo Duplo..."

    

    call sys%new([th1_0, th2_0], [p1_0, p2_0], d_qH , d_pH)
    call integ%init(sys, DT, OMEGA_TAO)

    current_time = 0.0_dp
    write(traj_unit, '(3F18.8)') current_time , sys%q(1) , sys%q(2)

    ! LOOP TEMPORAL
    do step = 1, max_steps

        call integ%step()
        current_time = current_time + DT

        ! Grava o pixel no mapa
        write(traj_unit, '(3F18.8)') current_time , sys%q(1) , sys%q(2)
    end do

    ! Desaloca sistemas
    call sys%kill()

    close(traj_unit)
    
end program SeeTrajectories