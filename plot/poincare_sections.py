import numpy as np
import matplotlib.pyplot as plt
import os

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

SizeOfFig   = (7,5)
StdFontSize = 12

def get_phaseDiagram( filename ):    
    with open(filename, 'r') as f:
        header = f.readline()
        energy_val = float(header.split(':')[1].strip())
    
    # Carrega os dados (ignorando os comentários #)
        data = np.loadtxt(filename)
        if data.size > 0:
            if data.ndim == 1:
                data = data.reshape(1, -1)
    
        trajectories = data[:, 0].astype(int)
        position_cord = data[:, 1]
        momentum_cord = data[:, 2]
        return  energy_val , trajectories , position_cord , momentum_cord

def plot_trajectories( trajs , q2 , p2 , color_obj=None ):
    cmap = plt.get_cmap('tab20')
    unique_trajs = np.unique(trajs)
    for t in unique_trajs:
        idx = trajs == t
        # Pontos bem pequenos e ligeiramente transparentes
        if color_obj is None: 
            ax.scatter(q2[idx], p2[idx], s=1, alpha=0.7, color=cmap(t % 20) , rasterized=True)
        else:
            ax.scatter(q2[idx], p2[idx], s=1, alpha=0.7, color=color_obj , rasterized=True)

def plot_Poincare( filename , ax , slide=False):
    traj_energy , trajs , q2 , p2 = get_phaseDiagram( filename )

    plot_trajectories( trajs , q2 , p2 )
    ax.grid(alpha=0.5, linestyle=":")
    if slide:
        p2_max_phys = np.sqrt(2.0 * (traj_energy + 3.0))
        y_limit = p2_max_phys
        x_limit = np.pi
        ax.set_ylim([-y_limit, y_limit])
        ax.set_xlim([-y_limit*1.2, y_limit*1.2])
        ax.set_aspect('equal')
        ax.axis('off')
    else:
        p2_max_phys = np.sqrt(2.0 * (traj_energy + 3.0))
        y_limit = p2_max_phys * 1.1
        x_limit = np.pi
        ax.set_ylim([-y_limit, y_limit])
        ax.set_xlim([-x_limit, x_limit])
        ax.set_xticks(
            np.arange(-np.pi, np.pi + np.pi/2, step=np.pi/2),
            [r'-$\pi$', r'-$\pi$/2', '0', r'$\pi$/2', '$\pi$']
        )
        y_ticks = np.linspace(-y_limit,y_limit, 5)
        ax.set_yticks( 
            y_ticks,
            [f"{x:.2f}" for x in y_ticks]
        )
        ax.set_xlabel( r'$\theta_2$' , fontsize=StdFontSize )
        ax.set_ylabel( r'$p_2$' , fontsize=StdFontSize )
        ax.text( -np.pi*0.9 , y_limit*0.85 , rf"$E$={traj_energy:.3f}" , fontsize=StdFontSize )

for i in range(1,9):
    filename = f'program/data/poincare_E{i}.dat'
    savename = f'media/figs/poincare_section_E{i}.svg'
    fig, ax = plt.subplots(1 , figsize=SizeOfFig )
    plot_Poincare( filename , ax )
    fig.tight_layout()
    fig.savefig( savename, transparent=True )

filename = f'program/data/poincare_E{6}.dat'
savename = f'media/figs/poincare_img.svg'
fig, ax = plt.subplots(1 , figsize=(5,5) )
plot_Poincare( filename , ax , slide=True )
fig.tight_layout()
fig.savefig( savename, transparent=True )



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

fig, axs = plt.subplots( 4 , 2 , figsize=(2*SizeOfFig[0],4*SizeOfFig[1]) )
for i in range(1,9):
    ax = axs[(i-1)//2, (i-1)%2]
    filename = f'program/data/poincare_E{i}.dat'
    plot_Poincare( filename , ax )
savename = f'media/figs/poincare_sections.svg'
fig.tight_layout()
fig.savefig( savename, transparent=True )