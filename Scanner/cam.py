import cv2
import imutils
import numpy as np
from scan import scanner

from four_p_tranform.transform import four_point_transform

cam = cv2.VideoCapture(0)
ret, frame = cam.read()
print(cv2.__version__)
cv2.namedWindow("Python ScreenShot app")

img_counter = 0
#bbox = cv2.selectROI("Select Object", frame, fromCenter=False, showCrosshair=True)
while True:
    ret, frame = cam.read()
    if not ret:
        print("There appears to be a problem")
        break
    image = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    image = cv2.GaussianBlur(image, (5, 5), 0)
    edged = cv2.Canny(image, 75, 200)
    cnts = cv2.findContours(edged.copy(), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
    cnts = imutils.grab_contours(cnts)
    cnts = sorted(cnts, key=cv2.contourArea, reverse=True)[:5]
    screenCnt = None
    asp_ratio = 0
    ratio = 200 / 287
    #print(cnts)
    #looping thru the contours
    if len(cnts) > 0:
        for c in cnts:
            area = cv2.contourArea(c)
            if area < 1000:
                continue
            print(area)
            #calculates the perimeter of the contour
            peri = cv2.arcLength(c, True)
            #approximates the peri to the closest geometric shape
            #approx is a single numpy array of vertices
            approx = cv2.approxPolyDP(c, 0.02 * peri, True)
            (x, y, w, h) = cv2.boundingRect(approx)
            asp_ratio = w / h
            print(asp_ratio)
            #if the contour has 4 points, that's it
            if len(approx) == 4:
                screenCnt = approx
                break

        print(hasattr(cv2, 'TrackerCSRT_create'))  # This will return True if TrackerCSRT is availabl
        (x, y, w, h) = cv2.boundingRect(screenCnt)
        tracking = True

        # For OpenCV 4.x or later
        #tracker = cv2.TrackerCSRT_create()

        #tracker.init(frame, (x, y, w, h))

        """  if tracking:
            success, bbox = tracker.update(frame)

            if success:
                (x, y, w, h) = [int(v) for v in bbox]
                cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 255), 3)
        else:
                 print("Failed!")

        """
        if abs(asp_ratio - 0.7827715355805244) <= 0.5:
            cv2.drawContours(frame, [screenCnt], -1, ( 0, 0, 255), 2)
            print("Contour detected")
            image = frame
            frame2 = scanner(image)

            img = "paper{}.jpg".format(img_counter)
            cv2.imwrite(img, frame2)
            img_counter += 1
            break
    dim = (196, 281)
    start = (45, 65)

    end = (start[0] + dim[0], start[1] + dim[1])

    green = (0, 255, 0)  # Green color for the rect

    #cv2.rectangle(frame, start, end, green, 3 )
    cv2.imshow("tester", frame)

    k = cv2.waitKey(1)
    if k%256 == 27:
        print("Esc clicked")
        break
    elif k%256 == 32:
        print("SP hit")
        frame2 = scanner(frame)
        img = "opencv_frame_{}.jpg".format(img_counter)
        cv2.imwrite(img, frame)
        img_counter += 1

cam.release()
cam.destroyAllWindows()