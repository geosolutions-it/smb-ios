#!/usr/bin/python3

# RUN WITH PYTHON3. Plain PYTHON will croak.

# pip install Pillow
# python build_images.py

import sys
import os
import glob;
import PIL
from PIL import Image

g_config = {
	"images": [
		{
			"file": "images/auth_page_logo_*.png",
			"dpi": 480
		},
		{
			"file": "images/record_*.png",
			"dpi": 480
		},
		{
			"file": "images/stats_all_vehicles.png",
			"dpi": 480
		},
		{
			"file": "images/section_icon_*.png",
			"dpi": 480
		},
		{
			"file": "images/large_gray_icon_*.png",
			"dpi": 480
		},
		{
			"file": "images/header_background.png",
			"dpi": 480
		},
		{
			"file": "images/goodgo_logo.png",
			"dpi": 480
		},
		{
			"file": "images/background_grey.png",
			"dpi": 160
		},
		{
			"file": "images/tracks_page_background.png",
			"dpi": 160
		},
		{
			"file": "images/geosolutions_logo.png",
			"dpi": 480
		},
		{
			"file": "images/icon_drawer_menu.png",
			"dpi": 480
		},
		{
			"file": "images/icon_right_menu.png",
			"dpi": 480
		},
		{
			"file": "images/drawer_icon_*.png",
			"dpi": 480
		},
		{
			"file": "images/gray_warning_*.png",
			"dpi": 480
		},
		{
			"file": "images/badge_*.png",
			"dpi": 480
		},
		{
			"file": "images/track_stats.png",
			"dpi": 320
		},
		{
			"file": "images/small_icon_*.png",
			"dpi": 480
		},
		{
			"file": "images/track_stats_*.png",
			"dpi": 480
		},
		{
			"file": "images/competition*.png",
			"dpi": 480
		},
		{
			"file": "images/bike_placeholder.png",
			"dpi": 480
		}
	],
	"targetPath": "SaveMyBike/SaveMyBike/Assets/Images/",
	"targets": [
		{ "dpi": 160, "suffix": "" },
		{ "dpi": 320, "suffix": "@2x" },
		{ "dpi": 480, "suffix": "@3x" }
	]
};

###############################################################################################


def getDensity(densityVal):
	if densityVal == "":
		return 160
	f = 0
	try:
		f = float(densityVal)
	except:
		pass
	if f > 0:
		return f

	if densityVal in g_targetDPI:
		return g_targetDPI[densityVal]

	return 160

def generateTarget(file,image,width,height,dpi,targetDpi,targetSuffix):

	if targetDpi != dpi:
		scale = targetDpi / dpi

		scaledWidth = int(width * scale)
		scaledHeight = int(height * scale)

		scaled = image.resize((scaledWidth,scaledHeight),PIL.Image.ANTIALIAS)
	else:
		scaledWidth = width
		scaledHeight = height
		scaled = image

	if not os.path.exists(g_config["targetPath"]):
		os.makedirs(g_config["targetPath"])

	fname = os.path.basename(file)
	(base, ext) = os.path.splitext(fname)
	
	fname = "{0}{1}{2}".format(base,targetSuffix,ext);

	targetFilePath = os.path.join(g_config["targetPath"],fname)

	print("Generating target {0}: {1}x{2} at {3} dpi as {4}".format(fname,scaledWidth,scaledHeight,targetDpi,targetFilePath))

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

def processImage(file,dpi):

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
	
	print("Image is {0}x{1} at {2} dpi".format(width,height,dpi))

	for target in g_config["targets"]:
		if not generateTarget(file,im,width,height,dpi,target["dpi"],target["suffix"]):
			return False

	return True


def main():
	print("Processing images...")
	images = g_config["images"]
	for img in images:
		if img["file"].find("*") >= 0:
			files = glob.glob(img["file"])
			for f in files:
				if not processImage(f,img["dpi"]):
					print("ERROR: Could not process image {0}".format(f))
					sys.exit(-1)
		else:
			if not processImage(img["file"],img["dpi"]):
				print("ERROR: Could not process image {0}".format(img["file"]))
				sys.exit(-1)

main()
