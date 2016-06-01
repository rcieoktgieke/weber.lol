#!/usr/bin/env python
import sys
import os
import PIL
from PIL import Image

pathToImages = sys.argv[1]
pathToThumbs = sys.argv[2]
totalWidth = int(sys.argv[3])
imagesPerRow = int(sys.argv[4])

print("Width: " + str(totalWidth))
print("Images Per Row: " + str(imagesPerRow))

filenames = os.listdir(pathToImages)

index = 0
while (index + imagesPerRow <= len(filenames)):
	minHeight = None
	for i in range(index, index + imagesPerRow):
		filename = filenames[i]
		currentImage = Image.open(pathToImages + "/" + filename)
		if (minHeight == None or currentImage.size[1] < minHeight):
			minHeight = currentImage.size[1]

	width = 0.0
	for i in range(index, index + imagesPerRow):
		filename = filenames[i]
		currentImage = Image.open(pathToImages + "/" + filename)
		width += currentImage.size[0] * (float(minHeight)/currentImage.size[1])

	widthRatio = totalWidth/width
	for i in range(index, index + imagesPerRow):
		filename = filenames[i]
		print(filename)
		currentImage = Image.open(pathToImages + "/" + filename)
		scaleRatio = widthRatio * minHeight/currentImage.size[1]
		currentImage.resize((int(currentImage.size[0] * scaleRatio), int(currentImage.size[1] * scaleRatio))).save(pathToThumbs + "/thumb" + str(i) + ".png", format="PNG", optimize=True)
	
	index = index + imagesPerRow
