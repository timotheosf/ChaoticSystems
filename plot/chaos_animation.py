import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

def get_traj( filename ):
    dados = np.loadtxt(filename)
    time = dados[:, 0]
    theta1 = dados[:, 1]
    theta2 = dados[:, 2]
    L1, L2 = 1.0, 1.0
    x1 = L1 * np.sin(theta1)
    y1 = -L1 * np.cos(theta1)
    x2 = x1 + L2 * np.sin(theta2)
    y2 = y1 - L2 * np.cos(theta2)
    return time , x1 , y1 , x2 , y2

def set_axReady(ax):
    ax.set_aspect('equal')
    ax.axis('off')
    
    # Pêndulo 1 (Original) - Azul e Vermelho
    linha_a, = ax.plot([], [], 'o-', lw=3, color='springgreen', markersize=8, alpha=0.7)
    rastro_a, = ax.plot([], [], '-', lw=1.5, color='orange', alpha=0.6)
    
    # Pêndulo 2 (Perturbado) - Verde e Laranja
    linha_b, = ax.plot([], [], 'o-', lw=3, color='dodgerblue', markersize=8, alpha=0.7)
    rastro_b, = ax.plot([], [], '-', lw=1.5, color='crimson', alpha=0.6)
    
    return linha_a, rastro_a, linha_b, rastro_b

def update(i):
    # Atualiza Pêndulo 2
    thisx_b = [0, x1_b[i], x2_b[i]]
    thisy_b = [0, y1_b[i], y2_b[i]]
    linha_b.set_data(thisx_b, thisy_b)
    
    historia_x_b.append(x2_b[i])
    historia_y_b.append(y2_b[i])
    if len(historia_x_b) > 100:
        historia_x_b.pop(0)
        historia_y_b.pop(0)
    rastro_b.set_data(historia_x_b, historia_y_b)

    # Atualiza Pêndulo 1
    thisx_a = [0, x1_a[i], x2_a[i]]
    thisy_a = [0, y1_a[i], y2_a[i]]
    linha_a.set_data(thisx_a, thisy_a)
    
    historia_x_a.append(x2_a[i])
    historia_y_a.append(y2_a[i])
    if len(historia_x_a) > 100:
        historia_x_a.pop(0)
        historia_y_a.pop(0)
    rastro_a.set_data(historia_x_a, historia_y_a)
    
    # Retorna todos os elementos que mudaram (necessário para o blit=True)
    return linha_a, rastro_a, linha_b, rastro_b

# Arquivos de dados
file_base = 'program/data/trajec_unstable_1.dat'
file_pert = 'program/data/trajec_unstable_1_pert.dat'
save_in   = 'media/ani/trajec_chaos.webm'

# Lendo as duas trajetórias
time_a, x1_a, y1_a, x2_a, y2_a = get_traj(file_base)
time_b, x1_b, y1_b, x2_b, y2_b = get_traj(file_pert)

plt.rcParams.update({
    'figure.facecolor': '#FFFFFF' # '#1C1917'
})

fig = plt.figure(figsize=(6, 6))
fig.subplots_adjust(left=0, bottom=0, right=1, top=1, wspace=None, hspace=None)

ax = fig.add_subplot(111, autoscale_on=False, xlim=(-2.5, 2.5), ylim=(-2.5, 2.5))

# Inicializa as linhas no gráfico
linha_a, rastro_a, linha_b, rastro_b = set_axReady(ax)

# Duas listas de histórico separadas
historia_x_a, historia_y_a = [], []
historia_x_b, historia_y_b = [], []

passo_frames = 50
# Usa o tamanho do menor arquivo para evitar erro de índice caso tenham tamanhos diferentes
limite_frames = min(len(time_a), len(time_b))
frames_animacao = range(0, limite_frames, passo_frames)

ani = animation.FuncAnimation(fig, update, frames=frames_animacao, 
                              interval=0.007/3, blit=True)

writer = animation.FFMpegWriter(
    fps=60,
    codec='libvpx-vp9',
    extra_args=['-pix_fmt', 'yuva420p', '-loglevel', 'quiet']
)

ani.save(save_in, writer=writer, savefig_kwargs={'transparent': True, 'facecolor': 'none'} )