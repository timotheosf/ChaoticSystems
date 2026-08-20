program momentumSpace
    use double_pendulum_mod
    use kinds_chaos
    use symplecf_mod
    implicit none

    !type(tao4_t)   :: integrator
    !type(system_t) :: sys

        !===================================================================
    ! PARÂMETROS DA SIMULAÇÃO
    !===================================================================
    real(dp), parameter :: PI = 3.14159265358979323846_dp
    integer,  parameter :: N_GRID = 500           ! Grid 100x100 de momentos
    real(dp), parameter :: DT = 0.05_dp           ! Passo um pouco menor por segurança
    real(dp), parameter :: MAX_TIME = 2000.0_dp    
    real(dp), parameter :: OMEGA_TAO = 20.0_dp    
    
    ! Parâmetros para Lyapunov
    real(dp), parameter :: D0 = 1.0e-8_dp
    integer,  parameter :: N_RENORM = 10

    type(system_t), target :: sys, sys_pert
    type(tao4_t)           :: integ, integ_pert

    integer  :: i, j, step, max_steps, map_unit
    real(dp) :: p1_0, p2_0, dp_grid
    real(dp) :: time2flip, current_time, dist_d, lyap_sum, MLE
    real(dp), allocatable :: q_diff(:), p_diff(:)

    max_steps = int(MAX_TIME / DT)
    dp_grid = (2.0_dp * PI) / real(N_GRID - 1, dp)

    allocate(q_diff(2), p_diff(2))

    open(newunit=map_unit, file='data/dp_momentum_map.dat', status='replace')
    write(map_unit, '(A)') '# p1_0          p2_0          t_flip        MLE_Lyapunov'

    print *, "Gerando Mapas Fractais no Espaço de Momentos [-PI, PI]..."
    print *, "Grid: ", N_GRID, "x", N_GRID

    !===================================================================
    ! LOOP PRINCIPAL (Varredura p1 e p2)
    !===================================================================
    do i = 1, N_GRID
        p1_0 = -PI + real(i - 1, dp) * dp_grid
        
        do j = 1, N_GRID
            p2_0 = -PI + real(j - 1, dp) * dp_grid

            ! Posição inicial FIXA (0,0), Momento inicial VARIÁVEL (p1_0, p2_0)
            call sys%new([0.0_dp, 0.0_dp], [p1_0, p2_0], d_qH , d_pH)
            call integ%init(sys, DT, OMEGA_TAO)

            ! Sistema perturbado (pequeno desvio no q1 para medir Lyapunov)
            call sys_pert%new([D0, 0.0_dp], [p1_0, p2_0], d_qH , d_pH)
            call integ_pert%init(sys_pert, DT, OMEGA_TAO)

            time2flip = 0.0_dp
            lyap_sum  = 0.0_dp
            current_time = 0.0_dp

            do step = 1, max_steps
                call integ%step()
                call integ_pert%step()
                current_time = current_time + DT

                ! Checa se flipou
                if (time2flip == 0.0_dp) then
                    if (abs(sys%q(1)) >= PI .or. abs(sys%q(2)) >= PI) then
                        time2flip = current_time
                    end if
                end if

                ! Lyapunov
                if (mod(step, N_RENORM) == 0) then
                    q_diff = sys_pert%q - sys%q
                    p_diff = sys_pert%p - sys%p
                    dist_d = sqrt(sum(q_diff**2) + sum(p_diff**2))
                    
                    if (dist_d > 0.0_dp) then
                        lyap_sum = lyap_sum + log(dist_d / D0)
                        
                        sys_pert%q = sys%q + q_diff * (D0 / dist_d)
                        sys_pert%p = sys%p + p_diff * (D0 / dist_d)
                        call integ_pert%init(sys_pert, DT, OMEGA_TAO)
                    end if
                end if
            end do

            MLE = lyap_sum / current_time
            write(map_unit, '(4F18.8)') p1_0, p2_0, time2flip, MLE

            call sys%kill()
            call sys_pert%kill()
        end do
        write(map_unit, *) 
        if (mod(i, 10) == 0) print *, "Progresso: ", (i * 100) / N_GRID, "%"
    end do

    close(map_unit)
    print *, "Pronto! Arquivo 'dp_momentum_map.dat' gerado."


    
end program momentumSpace