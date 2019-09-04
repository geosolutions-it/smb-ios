#!/usr/bin/python3

# RUN WITH PYTHON3. Plain PYTHON will croak.

# pip install Pillow
# python build_images.py

import sys
import os
import PIL
from PIL import Image


def generateIcon(file,image,width,height,scaledWidth,scaledHeight,targetPath):
	if not os.path.exists(targetPath):
		os.makedirs(targetPath)

	scaled = image.resize((scaledWidth,scaledHeight),PIL.Image.ANTIALIAS)

	fname = os.path.basename(file)

	targetName = "icon-{0}x{1}.png".format(scaledWidth,scaledHeight)

	targetFilePath = os.path.join(targetPath,targetName)

	print("Generating file {0}".format(targetFilePath))

	try:
		scaled.save(targetFilePath)
	except IOError as err:
		print("ERROR: Could not write target image: I/O error: {0}".format(err))
		return False
	except SystemError as err:
		print("ERROR: Could not write target image: System error: {0}".format(err))
		return False;
	except:
		print("ERROR: Could not write target image: Unexpected error:", sys.exc_info()[0])
		return False

	return True

def processImage(file):

	print("Processing image {0}".format(file))

	try:
		im = PIL.Image.open(file)
	except IOError as err:
		print("ERROR: I/O error({0}): {1}".format(err))
		return False
	except:
		raise
		return False
	
	width = im.size[0]
	height = im.size[1]

	print("Image is {0}x{1}".format(width,height))

	aSizes = [ 20, 29, 40, 58, 60, 70, 76, 80, 87, 116, 120, 152, 167, 174, 180, 512, 1024 ];

	for size in aSizes:
		if not generateIcon(file,im,width,height,size,size,"."):
			return False

	return True


def main():
	if not processImage("source.png"):
		print("ERROR: Could not process image")
		sys.exit(-1)

main()
