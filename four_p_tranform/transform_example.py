from transform import four_point_transform
import numpy as np
import argparse
import cv2

#creates an object for parsing from the command line
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", help = "path to the image file")
ap.add_argument("-c", "--coords", help = "comma seperated list of source points")
args = vars(ap.parse_args())

# load the image and grab the source coordinates (i.e. the list of
# of (x, y) points)
image = cv2.imread(args["image"])
pts = np.array(eval(args["coords"]), dtype="float32")  #eval converts the string input of coords into a Python array

# apply the four point tranform to obtain a "birds eye view" of
# the image
warped = four_point_transform(image, pts)


#show original and warped image
cv2.imshow("Original", image)
cv2.imshow("Warped", warped)
cv2.waitKey(0)
cv2.destroyAllWindows()