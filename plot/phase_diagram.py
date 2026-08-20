import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm

SizeOfFig   = (7,5.5)
StdFontSize = 12

def get_phaseDiagram( filename ):    
    data = np.loadtxt(filename)
    N = int(np.sqrt(len(data)))
    x_axis = data[:, 0].reshape(N, N)
    y_axis = data[:, 1].reshape(N, N)
    tflip = data[:, 2].reshape(N, N)
    lyapunov = data[:, 3].reshape(N, N)
    return x_axis , y_axis , tflip , lyapunov

def set_piAxes( ax ):
    ax.set_xlim([-np.pi, np.pi])
    ax.set_xticks(
        np.arange(-np.pi, np.pi + np.pi/2, step=np.pi/2),
        [r'-$\pi$', r'-$\pi$/2', '0', r'$\pi$/2', '$\pi$']
    )
    ax.set_ylim([-np.pi, np.pi])
    ax.set_yticks(
            np.arange(-np.pi, np.pi + np.pi/2, step=np.pi/2),
            [r'-$\pi$', r'-$\pi$/2', '0', r'$\pi$/2', '$\pi$']
        )

def set_momentAxes( ax ):
    ax.set_xlabel( r'$p_1$' , fontsize=StdFontSize )
    ax.set_ylabel( r'$p_2$' , fontsize=StdFontSize )

def set_positionAxes( ax ):
    ax.set_xlabel( r'$\theta_1$' , fontsize=StdFontSize )
    ax.set_ylabel( r'$\theta_2$' , fontsize=StdFontSize )

def plot_flip( x_axis , y_axis , tflip, ax , fig ):
    tflip_masked = np.ma.masked_where(tflip == 0.0, tflip)
    cmap_flip = cm.inferno.copy()
    cmap_flip.set_bad(color='black')
    mesh1 = ax.pcolormesh(x_axis, y_axis, tflip_masked, cmap=cmap_flip, shading='nearest', norm='log', rasterized=True )
    fig.colorbar(mesh1, ax=ax, label='Tempo de flip')

def plot_lya( x_axis , y_axis , lyapunov , ax , fig ):
    mesh2 = ax.pcolormesh(x_axis, y_axis, lyapunov, cmap='viridis', shading='nearest' , rasterized=True )
    fig.colorbar(mesh2, ax=ax, label='Lyapunov')

#> Config para site
plt.rcParams.update({
    'figure.facecolor': 'slategray',
    'axes.facecolor': 'slategray',
    'text.color': 'slategray',
    'axes.labelcolor': 'slategray',
    'xtick.color': 'slategray',
    'ytick.color': 'slategray',
    'grid.color': 'slategray'
})

file_momentum = 'program/data/dp_momentum_map.dat'
flipName = 'media/figs/phase_moment_flip.svg' 
lyaName = 'media/figs/phase_moment_lya.svg'

p1_grid, p2_grid , tflip_grid , lyapunov = get_phaseDiagram(file_momentum)

fig , ax = plt.subplots( 1 , figsize=SizeOfFig )
plot_lya( p1_grid, p2_grid , lyapunov , ax , fig )
set_piAxes( ax )
set_momentAxes( ax )
fig.tight_layout()
fig.savefig( lyaName, transparent=True, dpi=150 )

fig , ax = plt.subplots( 1 , figsize=SizeOfFig )
plot_flip( p1_grid, p2_grid , tflip_grid , ax , fig )
set_piAxes( ax )
set_momentAxes( ax )
fig.tight_layout()
fig.savefig( flipName, transparent=True, dpi=150 )

file_position = 'program/data/dp_position_map.dat'
flipName = 'media/figs/phase_position_flip.svg' 
lyaName = 'media/figs/phase_position_lya.svg'

q1_grid, q2_grid , tflip_grid , lyapunov = get_phaseDiagram(file_position)

fig , ax = plt.subplots( 1 , figsize=SizeOfFig )
plot_flip( q1_grid, q2_grid , tflip_grid , ax , fig )
set_piAxes( ax )
set_positionAxes( ax )
fig.tight_layout()
fig.savefig( flipName, transparent=True, dpi=150 )

fig , ax = plt.subplots( 1 , figsize=SizeOfFig )
plot_lya( p1_grid, p2_grid , lyapunov , ax , fig )
set_piAxes( ax )
fig.tight_layout()
fig.savefig( lyaName, transparent=True, dpi=150 )


#> Config para slide
plt.rcParams.update({
    'figure.facecolor': '#0b101b',
    'axes.facecolor': '#0b101b',
    'text.color': '#FFFFFF',
    'axes.labelcolor': '#FFFFFF',
    'xtick.color': '#FFFFFF',
    'ytick.color': '#FFFFFF',
    'grid.color': '#FFFFFF'
})