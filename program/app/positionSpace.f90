program positionSpace
    use double_pendulum_mod
    use kinds_chaos
    use symplecf_mod
    implicit none

    !===================================================================
    ! PARÂMETROS DA SIMULAÇÃO
    !===================================================================
    real(dp), parameter :: PI = 3.14159265358979323846_dp
    integer,  parameter :: N_GRID = 500           ! Grid 50x50 de posições iniciais
    real(dp), parameter :: DT = 0.05_dp          ! Passo de tempo
    real(dp), parameter :: MAX_TIME = 2000.0_dp   ! Tempo de integração por pixel
    real(dp), parameter :: OMEGA_TAO = 10.0_dp   ! Mola do integrador de Tao
    
    ! Parâmetros para o Cálculo de Lyapunov (Método de Benettin)
    real(dp), parameter :: D0 = 1.0e-8_dp        ! Perturbação inicial
    integer,  parameter :: N_RENORM = 10         ! Passos entre renormalizações

    ! Objetos: 1 de referência e 1 perturbado
    type(system_t), target :: sys, sys_pert
    type(tao4_t)           :: integ, integ_pert

    ! Variáveis de controle
    integer  :: i, j, step, max_steps
    real(dp) :: th1_0, th2_0
    real(dp) :: dth, time2flip, current_time
        
    ! Variáveis para Lyapunov
    real(dp) :: dist_d, lyap_sum, MLE
    real(dp), allocatable :: q_diff(:), p_diff(:)
    
    integer  :: map_unit

    !===================================================================
    ! INICIALIZAÇÃO
    !===================================================================
    dth = (2.0_dp * PI) / real(N_GRID - 1, dp)
    max_steps = int(MAX_TIME / DT)

    allocate(q_diff(2), p_diff(2))

    open(newunit=map_unit, file='data/dp_map.dat', status='replace')
    write(map_unit, '(A)') '# th1_0       th2_0       t_flip      MLE_Lyapunov'

    print *, "Iniciando Varredura do Pêndulo Duplo..."
    print *, "Grid: ", N_GRID, "x", N_GRID, " | Max Time: ", MAX_TIME

    !===================================================================
    ! LOOP PRINCIPAL (Varredura [-PI, PI]^2)
    !===================================================================
    do i = 1, N_GRID
        th1_0 = -PI + real(i - 1, dp) * dth
        
        do j = 1, N_GRID
            th2_0 = -PI + real(j - 1, dp) * dth

            ! Condições iniciais (partindo do repouso: p1 = p2 = 0)
            ! 1. Inicializa o Sistema de Referência
            call sys%new([th1_0, th2_0], [0.0_dp, 0.0_dp], d_qH , d_pH)
            call integ%init(sys, DT, OMEGA_TAO)

            ! 2. Inicializa o Sistema Perturbado (distância D0 no q1)
            call sys_pert%new([th1_0 + D0, th2_0], [0.0_dp, 0.0_dp], d_qH , d_pH)
            call integ_pert%init(sys_pert, DT, OMEGA_TAO)

            time2flip = 0.0_dp
            lyap_sum  = 0.0_dp
            current_time = 0.0_dp

            ! LOOP TEMPORAL
            do step = 1, max_steps

                call integ%step()
                call integ_pert%step()
                current_time = current_time + DT

                ! ==========================================
                ! A. CHECAGEM DE FLIP
                ! ==========================================
                if (time2flip == 0.0_dp) then
                    ! Se qualquer um dos pêndulos der uma volta completa
                    if (abs(sys%q(1)) >= PI .or. abs(sys%q(2)) >= PI) then
                        time2flip = current_time
                    end if
                end if

                ! ==========================================
                ! C. CÁLCULO DE LYAPUNOV (A cada N_RENORM)
                ! ==========================================
                if (mod(step, N_RENORM) == 0) then
                    q_diff = sys_pert%q - sys%q
                    p_diff = sys_pert%p - sys%p
                    
                    ! Distância no espaço de fase (4D)
                    dist_d = sqrt(sum(q_diff**2) + sum(p_diff**2))
                    
                    ! Adiciona o alongamento na soma de Lyapunov
                    if (dist_d > 0.0_dp) then
                        lyap_sum = lyap_sum + log(dist_d / D0)
                        
                        ! Renormaliza o sistema perturbado para ficar a D0 de distância
                        sys_pert%q = sys%q + q_diff * (D0 / dist_d)
                        sys_pert%p = sys%p + p_diff * (D0 / dist_d)
                        
                        ! OBRIGATÓRIO NO TAO: Re-inicializar para sincronizar X e Y
                        call integ_pert%init(sys_pert, DT, OMEGA_TAO)
                    end if
                end if
            end do

            ! Calcula o Maximum Lyapunov Exponent (MLE)
            MLE = lyap_sum / current_time

            ! Grava o pixel no mapa
            write(map_unit, '(4F18.8)') th1_0, th2_0, time2flip, MLE

            ! Desaloca sistemas
            call sys%kill()
            call sys_pert%kill()
        end do
        
        write(map_unit, *) ! Quebra de linha para plotagem Gnuplot/Python
        if (mod(i, 5) == 0) print *, "Progresso: ", (i * 100) / N_GRID, "%"
    end do

    close(map_unit)
    
end program positionSpace