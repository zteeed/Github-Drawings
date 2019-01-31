#!/usr/bin/python3
import cv2, os

def convert(IMAGE):
    im = cv2.imread(IMAGE)
    im[im<128] = True; im[im>128] = False
    return im

def write_pixel(pixel, tmp):
    if False in pixel:
        tmp.write('0\n')
    if True in pixel:
        tmp.write('1\n')

def main():
    IMAGE = "./images/space-invaders.png"
    TAB = convert(IMAGE)
    os.system('rm ./tmp.txt')
    tmp = open('./tmp.txt', 'w')
    for i in range(len(TAB[0])):
        for j in range(len(TAB)):
            pixel = TAB[j][i]
            write_pixel(pixel, tmp)
    tmp.close()

if __name__ == '__main__':
    main()
