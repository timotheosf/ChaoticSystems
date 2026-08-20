module double_pendulum_mod
    use kinds_chaos
    implicit none

    private

    public :: d_qH , d_pH

contains

    pure function d_pH(q, p) result(dH)
        real(dp), intent(in) :: q(:), p(:)
        real(dp) :: dH(size(q))
        real(dp) :: c, M
        c = cos(q(1) - q(2))
        M = 2.0_dp - c**2
        dH(1) = (p(1) - p(2)*c) / M
        dH(2) = (2.0_dp*p(2) - p(1)*c) / M
    end function d_pH

    pure function d_qH(q, p) result(dH)
        real(dp), intent(in) :: q(:), p(:)
        real(dp) :: dH(size(q))
        real(dp) :: c, s, M, N, dT_dq1
        s = sin(q(1) - q(2))
        c = cos(q(1) - q(2))
        M = 2.0_dp - c**2
        N = p(1)**2 + 2.0_dp*p(2)**2 - 2.0_dp*p(1)*p(2)*c
        dT_dq1 = s * (p(1)*p(2)*M - N*c) / (M**2)
        dH(1) = dT_dq1 + 2.0_dp * sin(q(1))
        dH(2) = -dT_dq1 + sin(q(2))
    end function d_qH
    
end module double_pendulum_mod