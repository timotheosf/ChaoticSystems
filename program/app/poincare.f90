program poincareReturningMap
    use double_pendulum_mod
    use kinds_chaos
    use symplecf_mod
    implicit none
    ! Parâmetros da Simulação
    real(dp), parameter :: DT = 0.05_dp
    real(dp), parameter :: MAX_TIME = 20000.0_dp   ! Tempo BEM longo para encher o gráfico
    real(dp), parameter :: OMEGA_TAO = 10.0_dp
    integer,  parameter :: N_TRAJ = 20            ! Quantidade de trajetórias por energia

    ! 4 Níveis de Energia para explorar (Mínimo absoluto é E = -3.0)
    real(dp), parameter :: E_levels(*) = [-2.5_dp, -2.25_dp , -2._dp , -1.875_dp , -1.75_dp , -1.625_dp, -1.5_dp , -1.0_dp]
    
    type(system_t), target :: sys
    type(tao4_t)           :: integ
    
    integer  :: i, traj, step, max_steps, file_unit
    real(dp) :: E, p2_max, p1_init, p2_init
    real(dp), allocatable :: old_q(:), old_p(:), q_cross(:), p_cross(:)
    character(len=30) :: filename

    max_steps = int(MAX_TIME / DT)
    allocate(old_q(2), old_p(2), q_cross(2), p_cross(2))

    print *, "Iniciando geração das Seções de Poincaré por Nível de Energia..."

    ! Loop sobre os 4 Níveis de Energia
    do i = 1, size(E_levels)
        E = E_levels(i)
        
        ! O momento p2 máximo permitido pela energia E
        p2_max = sqrt(2.0_dp * (E + 3.0_dp))

        ! Abre o arquivo de saída para este nível de energia
        write(filename, '("data/poincare_E",I1,".dat")') i
        open(newunit=file_unit, file=filename, status='replace')
        write(file_unit, '("# Energy: ", F8.2)') E
        write(file_unit, '("# Traj_ID     q2_cross            p2_cross")')

        print *, "Processando Energia E =", E, " (Arquivo:", trim(filename), ")"

        ! Lança várias trajetórias no MESMO nível de energia
        do traj = 1, N_TRAJ
            ! Distribui p2_init uniformemente entre -p2_max e +p2_max
            p2_init = -p2_max + real(traj - 1, dp) * (2.0_dp * p2_max) / real(N_TRAJ - 1, dp)
            
            ! Calcula o p1_init correspondente para que a energia seja EXATAMENTE E
            p1_init = p2_init + sqrt(2.0_dp * (E + 3.0_dp) - p2_init**2)

            ! Inicializa na origem, mas com momento (velocidade) inicial
            call sys%new([0.0_dp, 0.0_dp], [p1_init, p2_init], d_qH , d_pH)
            call integ%init(sys, DT, OMEGA_TAO)

            ! Integra a órbita no tempo
            do step = 1, max_steps
                old_q = sys%q
                old_p = sys%p
                
                call integ%step()

                ! Cruza o plano q1=0 da esquerda para a direita (dot_q1 > 0)
                if (old_q(1) < 0.0_dp .and. sys%q(1) >= 0.0_dp) then
                    call sys%poincare_crossing(old_q, old_p, 1, 0.0_dp, q_cross, p_cross)
                    ! Salva o ID da trajetória e as coordenadas q2, p2 cruzadas
                    write(file_unit, '(I4, 2F20.8)') traj, q_cross(2), p_cross(2)
                end if
            end do
            
            call sys%kill()
        end do
        
        close(file_unit)
    end do

    print *, "Simulações concluídas com sucesso!"
    
end program poincareReturningMap