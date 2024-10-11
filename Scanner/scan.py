import importlib
import sys
sys.path.append("..")  # Add the parent directory to the path

from four_p_tranform.transform import four_point_transform
from skimage.filters import threshold_local
import numpy as np
import argparse
import cv2
import imutils

#constructing the argparse obj
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required=True, help="path to the image to be scanned")
args = vars(ap.parse_args())

#Edge Detection
#load and compute image's old to new height ratio
#then clone it and resize it
image = cv2.imread(args["image"])
ratio = image.shape[0] / 500
orig = image.copy()
image = imutils.resize(image, height=500)

#greyscale
#a new copy of image in greyscale, edged, is made
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
gray = cv2.GaussianBlur(gray, (5, 5,), 0)
edged = cv2.Canny(gray, 75, 200)

print("STEP 1: Edhe Detection")
cv2.imshow("Image", image)
cv2.imshow("Edged", edged)
cv2.waitKey(0)
cv2.destroyAllWindows()


#Contour Detection
#Assume the paper has the largest rectangular contour in the image
#findContours returna a list of numoy arrays containing coordinates
cnts = cv2.findContours(edged.copy(), cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
cnts = imutils.grab_contours(cnts)
cnts = sorted(cnts, key=cv2.contourArea, reverse=True) [:5]

#print(cnts)
#looping thru the contours
for c in cnts:
    #calculates the perimeter of the contour
    peri = cv2.arcLength(c, True)
    #approximates the peri to the closest geometric shape
    #approx is a single numpy array of vertices
    approx = cv2.approxPolyDP(c, 0.02 * peri, True)

    #if the contour has 4 points, that's it
    if len(approx) == 4:
        screenCnt = approx
        break

#debugging statement
# Check if screenCnt is defined
if 'screenCnt' not in locals():
    print("No rectangular contour found.")
else:
    print("Found rectangular contour.")
    cv2.drawContours(image, [screenCnt], -1, (0, 255, 0), 2)


#show the contour
print("STEP 2: Find contours of paper")
cv2. drawContours(image, [screenCnt], -1, (0,255,0), 2)
cv2.imshow("Outline", image)
cv2.waitKey(0)
cv2.destroyAllWindows()

#applying the four_point_transform
warped = four_point_transform(orig, screenCnt.reshape(4,2) * ratio)

#converting warped to greyscale
warped = cv2.cvtColor(warped, cv2.COLOR_BGR2GRAY)
T = threshold_local(warped, 11, offset=10, method="gaussian")
warped = (warped > T).astype("uint8") * 255

# show the original and scanned images
print("STEP 3: Apply perspective transform")
cv2.imshow("Original", imutils.resize(orig, height = 650))
cv2.imshow("Scanned", imutils.resize(warped, height = 650))
cv2.waitKey(0)