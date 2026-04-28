import numpy as np
import matplotlib.pyplot as plt
from matplotlib.path import Path
from mpl_toolkits.mplot3d.art3d import Poly3DCollection


def geoToCart(u, v):
    x = np.cos(u) * np.cos(v)
    y = np.cos(u) * np.sin(v)
    z = np.sin(u)
    return np.column_stack((x, y, z))


def uvTosd(u, v, uk, vk):
    dv = vk - v
    s = np.arcsin(np.sin(u) * np.sin(uk) + np.cos(u) * np.cos(uk) * np.cos(dv))
    d = -np.arctan2(np.sin(dv) * np.cos(u),
                    np.cos(u) * np.sin(uk) * np.cos(dv) - np.sin(u) * np.cos(uk))
    return s, d


def gnom(R, s, d):
    rho = R * np.tan(np.pi / 2 - s)
    return rho * np.cos(d), rho * np.sin(d)


def boundary(R, uk, vk, ub, vb):
    ub = np.append(ub, ub[0])
    vb = np.append(vb, vb[0])
    s, d = uvTosd(ub, vb, uk, vk)
    X, Y = gnom(R, s, d)
    return X[:-1], Y[:-1]


def clipLine(x, y, polyX, polyY):
    poly = Path(np.column_stack((polyX, polyY)))
    inside = np.zeros(len(x), dtype=bool)

    valid = ~np.isnan(x) & ~np.isnan(y)
    if np.any(valid):
        pts = np.column_stack((x[valid], y[valid]))
        inside[valid] = poly.contains_points(pts)

    x = x.copy()
    y = y.copy()
    x[~inside] = np.nan
    y[~inside] = np.nan
    return x, y


def map2DTo3D(x, y, polyX, polyY, tri3D):
    x1, y1 = polyX[0], polyY[0]
    x2, y2 = polyX[1], polyY[1]
    x3, y3 = polyX[2], polyY[2]

    den = (y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3)

    l1 = ((y2 - y3) * (x - x3) + (x3 - x2) * (y - y3)) / den
    l2 = ((y3 - y1) * (x - x3) + (x1 - x3) * (y - y3)) / den
    l3 = 1 - l1 - l2

    return l1 * tri3D[0] + l2 * tri3D[1] + l3 * tri3D[2]


def loadContinent(name):
    data = np.loadtxt(name)
    return np.deg2rad(data[:, 0]), np.deg2rad(data[:, 1])


def setAxesEqual(ax):
    xlim = ax.get_xlim3d()
    ylim = ax.get_ylim3d()
    zlim = ax.get_zlim3d()

    xm = np.mean(xlim)
    ym = np.mean(ylim)
    zm = np.mean(zlim)

    r = 0.5 * max(xlim[1] - xlim[0], ylim[1] - ylim[0], zlim[1] - zlim[0])

    ax.set_xlim3d([xm - r, xm + r])
    ax.set_ylim3d([ym - r, ym + r])
    ax.set_zlim3d([zm - r, zm + r])


def drawFace(ax, face, V, conts):
    R = 1
    sMin = np.deg2rad(5)
    offset = 0.01

    polyX, polyY = boundary(R, face["uk"], face["vk"], face["ub"], face["vb"])
    tri3D = V[np.array(face["idx"]) - 1]

    n = np.cross(tri3D[1] - tri3D[0], tri3D[2] - tri3D[0])
    n = n / np.linalg.norm(n)

    if np.dot(n, tri3D.mean(axis=0)) < 0:
        n = -n

    for name in conts:
        u, v = loadContinent(name)
        s, d = uvTosd(u, v, face["uk"], face["vk"])

        x = np.full(len(s), np.nan)
        y = np.full(len(s), np.nan)

        valid = s > sMin
        if np.any(valid):
            x[valid], y[valid] = gnom(R, s[valid], d[valid])

        x, y = clipLine(x, y, polyX, polyY)

        cuts = np.where(np.isnan(x) | np.isnan(y))[0]
        start = 0

        for stop in np.append(cuts, len(x)):
            xs = x[start:stop]
            ys = y[start:stop]

            if len(xs) >= 2:
                P3 = np.array([map2DTo3D(xs[i], ys[i], polyX, polyY, tri3D) for i in range(len(xs))])
                P3 = P3 + offset * n
                ax.plot(P3[:, 0], P3[:, 1], P3[:, 2], color="black", linewidth=1.0)

            start = stop + 1


# DATA
conts = ["amer.txt", "anta.txt", "austr.txt", "eur.txt"]
u = np.arcsin(np.sqrt(3) / 3)

# Vertices
A = [0, 0]
B = [0, np.pi/2]
C = [0, np.pi]
D = [0, 3*np.pi/2]
E = [np.pi/2, 0]
F = [-np.pi/2, 0]

pts = np.array([A, B, C, D, E, F], dtype=float)
V = geoToCart(pts[:, 0], pts[:, 1])

# Cartographic points
I = [ u, np.deg2rad(45)]
J = [ u, np.deg2rad(135)]
K = [ u, np.deg2rad(225)]
L = [ u, np.deg2rad(315)]
M = [-u, np.deg2rad(45)]
N = [-u, np.deg2rad(135)]
O = [-u, np.deg2rad(225)]
P = [-u, np.deg2rad(315)]

# Faces
faces = [
    {"name": "I", "uk": I[0], "vk": I[1], "ub": np.array([A[0], B[0], E[0]]), "vb": np.array([A[1], B[1], E[1]]), "idx": [1, 2, 5]},
    {"name": "J", "uk": J[0], "vk": J[1], "ub": np.array([B[0], C[0], E[0]]), "vb": np.array([B[1], C[1], E[1]]), "idx": [2, 3, 5]},
    {"name": "K", "uk": K[0], "vk": K[1], "ub": np.array([C[0], D[0], E[0]]), "vb": np.array([C[1], D[1], E[1]]), "idx": [3, 4, 5]},
    {"name": "L", "uk": L[0], "vk": L[1], "ub": np.array([D[0], A[0], E[0]]), "vb": np.array([D[1], A[1], E[1]]), "idx": [4, 1, 5]},
    {"name": "M", "uk": M[0], "vk": M[1], "ub": np.array([B[0], A[0], F[0]]), "vb": np.array([B[1], A[1], F[1]]), "idx": [2, 1, 6]},
    {"name": "N", "uk": N[0], "vk": N[1], "ub": np.array([C[0], B[0], F[0]]), "vb": np.array([C[1], B[1], F[1]]), "idx": [3, 2, 6]},
    {"name": "O", "uk": O[0], "vk": O[1], "ub": np.array([D[0], C[0], F[0]]), "vb": np.array([D[1], C[1], F[1]]), "idx": [4, 3, 6]},
    {"name": "P", "uk": P[0], "vk": P[1], "ub": np.array([A[0], D[0], F[0]]), "vb": np.array([A[1], D[1], F[1]]), "idx": [1, 4, 6]},
]

# GRAF
fig = plt.figure(figsize=(10, 9))
ax = fig.add_subplot(111, projection="3d")

facePolys = [V[np.array(face["idx"]) - 1] for face in faces]

poly = Poly3DCollection(facePolys, alpha=0.65, edgecolors="black", linewidths=1.2)
ax.add_collection3d(poly)

ax.scatter(V[:, 0], V[:, 1], V[:, 2], s=20, color="gray")

labels = ["A", "B", "C", "D", "E", "F"]
for i in range(len(labels)):
    p = V[i] * 1.08
    ax.text(p[0], p[1], p[2], labels[i], fontsize=10, color="gray")

for face in faces:
    tri = V[np.array(face["idx"]) - 1]
    c = tri.mean(axis=0)
    ax.text(c[0], c[1], c[2], face["name"], fontsize=10, color="gray")

for face in faces:
    drawFace(ax, face, V, conts)

ax.set_title("3D osmisten s kontinenty")
ax.set_xlabel("X")
ax.set_ylabel("Y")
ax.set_zlabel("Z")

ax.view_init(elev=25, azim=45)
setAxesEqual(ax)
plt.tight_layout()
plt.show()