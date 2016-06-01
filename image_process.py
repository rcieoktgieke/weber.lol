#!/usr/bin/env python
import sys
import os
import PIL
from PIL import Image

totalWidth = int(sys.argv[1])
imagesPerRow = int(sys.argv[2])

print("Width: " + str(totalWidth))
print("Images Per Row: " + str(imagesPerRow))

#for filename in os.listdir("./test images"):
	#print(filename)

index = 0
while (index + imagesPerRow <= len(os.listdir("./test images"))):
	minHeight = None
	for i in range(index, index + imagesPerRow):
		if (minHeight == None or Image.open("test images/" + os.listdir("./test images")[i]).size[1] < minHeight):
			minHeight = Image.open("test images/" + os.listdir("./test images")[i]).size[1] 
		#print(str(i) + ": " + str(Image.open("test images/" + os.listdir("./test images")[i]).size[1]))
	#print("MinHeight: " + str(minHeight))
	
	width = 0.0
	for i in range(index, index + imagesPerRow):
                width += Image.open("test images/" + os.listdir("./test images")[i]).size[0] * (float(minHeight)/Image.open("test images/" + os.listdir("./test images")[i]).size[1])
		#print(os.listdir("./test images")[i] + " " + str(width))
	#print("Width: " + str(width))
	widthRatio = totalWidth/width
	#print("Width Ratio: " + str(widthRatio))

	for i in range(index, index + imagesPerRow):
		filename = os.listdir("./test images")[i]
		print(filename)
		currentImage = Image.open("test images/" + filename)
		scaleRatio = widthRatio * minHeight/currentImage.size[1]
		currentImage.resize((int(currentImage.size[0] * scaleRatio), int(currentImage.size[1] * scaleRatio))).save("thumbs/thumb" + filename) 
	
	index = index + imagesPerRow

#Image.open("test images/" + filename).resize((totalWidth, totalHeight)).save("thumbs/thumb" + filename)
