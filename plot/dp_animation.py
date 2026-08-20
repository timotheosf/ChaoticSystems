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

def set_axReady( ax ):
    ax.set_aspect('equal')
    ax.axis('off')
    linha, = ax.plot([], [], 'o-', lw=3, color='dodgerblue', markersize=8)
    rastro, = ax.plot([], [], '-', lw=1.5, color='red', alpha=0.6)
    return linha , rastro

def update(i):
    thisx = [0, x1[i], x2[i]]
    thisy = [0, y1[i], y2[i]]
    linha.set_data(thisx, thisy)
    historia_x.append(x2[i])
    historia_y.append(y2[i])
    if len(historia_x) > 100:
        historia_x.pop(0)
        historia_y.pop(0)
    rastro.set_data(historia_x, historia_y)
    
    return linha, rastro

read_from = 'program/data/trajec_unstable_1.dat'
save_in   = 'media/ani/trajec_unstable_1.webm'

time, x1, y1, x2, y2 = get_traj(read_from)

#plt.rcParams.update({
#    'figure.facecolor': '#1C1917'
#})
plt.rcParams.update({
    'figure.facecolor': '#FFFFFF'
})

fig = plt.figure(figsize=(6, 6))

fig.subplots_adjust(left=0, bottom=0, right=1, top=1, wspace=None, hspace=None)

ax = fig.add_subplot(111, autoscale_on=False, xlim=(-2.5, 2.5), ylim=(-2.5, 2.5))

linha, rastro = set_axReady(ax)

historia_x, historia_y = [], []

passo_frames = 50
frames_animacao = range(0, len(time), passo_frames)

ani = animation.FuncAnimation(fig, update, frames=frames_animacao, 
                              interval=0.007/3, blit=True)

writer = animation.FFMpegWriter(
    fps=60,
    codec='libvpx-vp9',
    extra_args=['-pix_fmt', 'yuva420p', '-loglevel', 'quiet']
)

ani.save(save_in, writer=writer, savefig_kwargs={'transparent': True, 'facecolor': 'none'})