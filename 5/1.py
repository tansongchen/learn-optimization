from random import random

def find():
    found = False
    while not found:
        x1, x2, x3 = [1 + random(), 1 + random(), 1 + random()]
        xp1, xp2, xp3 = [1 + random(), 1 + random(), 1 + random()]
        f = x2**2 * x3**3 / x1
        fp = xp2**2 * xp3**3 / xp1
        xv1, xv2, xv3 = (x1 + xp1) / 2, (x2 + xp2) / 2, (x3 + xp3) / 2
        ff = xv2**2 * xv3**3 / xv1
        if f + fp < 2 * ff:
            print(x1, x2, x3, xp1, xp2, xp3)
            break

find()