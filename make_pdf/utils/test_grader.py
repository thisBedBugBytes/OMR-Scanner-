import sys

from imutils import contours

sys.path.append("..")  # Add the parent directory to the path

from .scan import scanner
import numpy as np
import argparse
import imutils
import cv2
import logging
logger = logging.getLogger(__name__)


#scanned image

# Extract the color channels
def grader(image, ANSWERS, que_no):
    scanned = image.copy()
    print(ANSWERS)
    #scanned = cv2.convertScaleAbs(scanned, alpha=0.5, beta=0.0)
    #cv2.imshow("constrasted", scanned)
    #cv2.waitKey(0)
    copy = scanned.copy()
    scanned = cv2.cvtColor(scanned, cv2.COLOR_BGR2GRAY)

    # Load the imag
    # Apply CLAHE for better contrast in the image
    clahe = cv2.createCLAHE(clipLimit=0.05, tileGridSize=(8, 8))
    enhanced = clahe.apply(scanned)

    # Save or display the enhanced image

    denoised = cv2.fastNlMeansDenoising(enhanced, None, 20, 6, 7)

    #scanned = scanned[85:scanned.shape[0], 0:scanned.shape[1]//2]
   # copy = scanned.copy()
    #scanned = cv2.cvtColor(scanned, cv2.COLOR_BGR2GRAY)
    scanned = cv2.GaussianBlur(scanned, (1, 1), 0)

    #_, thresh = cv2.threshold(scanned, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)

    thresh = cv2.adaptiveThreshold(scanned, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY_INV,11, 4)
    #scanned = cv2.equalizeHist(scanned)
    #Contour detection from the binary image
    #read up on thresholding

    cv2.imshow("thresh", thresh)
    cv2.waitKey(0)


    # Define a 3x3 rectangular kernel
#    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (1, 1))

    # Apply morphological closing to reduce noise
 #   thresh2 = cv2.morphologyEx(thresh, cv2.MORPH_CLOSE, kernel)

  #  kernel = np.ones((5, 5), np.uint8)  # Define a kernel for morphological operations


    # Display the thresholded image after applying closing
    cv2.imshow("Closed Threshold", thresh)
    cv2.waitKey(0)


    cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    cnts = imutils.grab_contours(cnts)
    questionCnts = []
    threshold_value = 100
    circles = 0
    for c in cnts:
        (x, y, w, h) = cv2.boundingRect(c)
        asp_ratio = w / float(h)
        print("contour asp "+str(asp_ratio))

        if w >= 10 and h >= 10 and asp_ratio >= 0.8 and asp_ratio <= 2.1:
             questionCnts.append(c)
             circles += 1

    print(circles)
    copy2 = copy.copy()
    #print(f"Contours found: {len(contours_found)}")
    for q in questionCnts:
        cv2.drawContours(copy, [q], -1, (0, 0, 255), 1)

    cv2.imshow("contours", copy)
    cv2.waitKey(0)


    questionCnts = contours.sort_contours(questionCnts, method="top-to-bottom")[0]

    print("THis is the length of cnts: "+str(len(questionCnts)))
    correct = 0

    questions = len(questionCnts) / 4
    if(questions.is_integer() == False):
        print("Your document wasn't scanned properly. Please try again.")
        sys.exit()
    for (q, i) in enumerate(np.arange(0, len(questionCnts), 4)):
        cnts = contours.sort_contours(questionCnts[i:i+4])[0]
        bubbled = None

        for (j, c) in enumerate(cnts):
            # Create a mask for the current bubble
            mask = np.zeros(thresh.shape, dtype="uint8")
            cv2.drawContours(mask, [c], -1, 255, -1)
            marked = 0

            # Count the number of white pixels in the bubble
            mask = cv2.bitwise_and(thresh, thresh, mask=mask)
            total = cv2.sumElems(mask)[0]
            if q == 17:
                print(total)
            cv2.imshow("Masked", mask)
            cv2.waitKey(0)
            # Check if this bubble has the highest count of white pixels so far
            if bubbled is None or total > bubbled[0] and marked==0:
                bubbled = (total, j)  # Save the count and index of the bubbled answer
                marked = 1
        # After finding the bubbled answer, determine if it matches the correct answer
        color = (0, 0, 255)  # Default to red for incorrect
        print(f"Processing question {q} with answer key {ANSWERS.get(q)}")
        k = ANSWERS[q]  # Get the correct answer for this question
        if k == bubbled[1]:  # Check if selected answer matches the correct answer
            color = (0, 255, 0)  # Green for correct
            correct += 1  # Increment the correct count

        # Draw the contour of the correct/incorrect answer
        cv2.drawContours(copy2, [cnts[k]], -1, color, 2)
        print("Correct answer:", k, "Selected:", bubbled[1], "For question:", q)




    #cv2.putText(copy2, "{:.2f}%".format(score), (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 3)

    cv2.imshow("answers", copy2)
    cv2.waitKey(0)


    return correct

def grader2(image, ANSWERS, que_no):
    scanned = image.copy()
    print(ANSWERS)
    #scanned = cv2.convertScaleAbs(scanned, alpha=0.5, beta=0.0)
    cv2.imshow("constrasted", scanned)
    cv2.waitKey(0)
    copy = scanned.copy()
    scanned = cv2.cvtColor(scanned, cv2.COLOR_BGR2GRAY)

    # Load the imag
    # Apply CLAHE for better contrast in the image
    clahe = cv2.createCLAHE(clipLimit=0.05, tileGridSize=(8, 8))
    enhanced = clahe.apply(scanned)

    # Save or display the enhanced image

    denoised = cv2.fastNlMeansDenoising(enhanced, None, 20, 6, 7)

    #scanned = scanned[85:scanned.shape[0], 0:scanned.shape[1]//2]
   # copy = scanned.copy()
    #scanned = cv2.cvtColor(scanned, cv2.COLOR_BGR2GRAY)
    scanned = cv2.GaussianBlur(scanned, (1, 1), 0)

    #_, thresh = cv2.threshold(scanned, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)

    thresh = cv2.adaptiveThreshold(scanned, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY_INV,11, 4)
    #scanned = cv2.equalizeHist(scanned)
    #Contour detection from the binary image
    #read up on thresholding

    #cv2.imshow("thresh", thresh)
    #cv2.waitKey(0)


    # Define a 3x3 rectangular kernel
#    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (1, 1))

    # Apply morphological closing to reduce noise
 #   thresh2 = cv2.morphologyEx(thresh, cv2.MORPH_CLOSE, kernel)

  #  kernel = np.ones((5, 5), np.uint8)  # Define a kernel for morphological operations


    # Display the thresholded image after applying closing
    #cv2.imshow("Closed Threshold", thresh)
    #cv2.waitKey(0)


    cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    cnts = imutils.grab_contours(cnts)
    questionCnts = []
    threshold_value = 100
    circles = 0
    for c in cnts:
        (x, y, w, h) = cv2.boundingRect(c)
        asp_ratio = w / float(h)
        print("contour asp "+str(asp_ratio))

        if w >= 10 and h >= 10 and asp_ratio >= 0.8 and asp_ratio <= 2.1:
             questionCnts.append(c)
             circles += 1

    print(circles)
    copy2 = copy.copy()
    #print(f"Contours found: {len(contours_found)}")
    for q in questionCnts:
        cv2.drawContours(copy, [q], -1, (0, 0, 255), 1)

    #cv2.imshow("contours", copy)
    #cv2.waitKey(0)


    questionCnts = contours.sort_contours(questionCnts, method="top-to-bottom")[0]

    print("THis is the length of cnts: "+str(len(questionCnts)))
    correct = 0

    questions = len(questionCnts) / 4
    logger.info(questions)
    if(questions.is_integer() == False):
        print("Your document wasn't scanned properly. Please try again.")
        sys.exit()
    for (q, i) in enumerate(np.arange(0, len(questionCnts), 4)):
        cnts = contours.sort_contours(questionCnts[i:i+4])[0]
        bubbled = None

        for (j, c) in enumerate(cnts):
           
            mask = np.zeros(thresh.shape, dtype="uint8")
            cv2.drawContours(mask, [c], -1, 255, -1)
            marked = 0

            # Counting the number of white pixels in the bubble
            mask = cv2.bitwise_and(thresh, thresh, mask=mask)
            total = cv2.sumElems(mask)[0]
            if q == 17:
                print(total)
            cv2.imshow("Masked", mask)
            cv2.waitKey(0)
            # Check if this bubble has the highest count of white pixels so far
            if bubbled is None or total > bubbled[0] and marked==0:
                bubbled = (total, j)  # Save the count and index of the bubbled answer
                marked = 1
        # After finding the bubbled answer, determine if it matches the correct answer
        color = (0, 0, 255)  # Default to red for incorrect
        print(f"Processing question {q} with answer key {ANSWERS.get(q)}")
        k = ANSWERS[q]  # Get the correct answer for this question
        if k == bubbled[1]:  # Check if selected answer matches the correct answer
            color = (0, 255, 0)  # Green for correct
            correct += 1  # Increment the correct count

        # Draw the contour of the correct/incorrect answer
        cv2.drawContours(copy2, [cnts[k]], -1, color, 2)
        print("Correct answer:", k, "Selected:", bubbled[1], "For question:", q)




    #cv2.putText(copy2, "{:.2f}%".format(score), (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 3)

    cv2.imshow("answers", copy2)
    cv2.waitKey(0)


    return correct

