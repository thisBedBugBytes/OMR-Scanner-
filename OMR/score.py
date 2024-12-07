
import sys

sys.path.append("..")

from four_p_tranform.transform import four_point_transform
import argparse
import cv2
import imutils
from test_grader import grader
from Scanner.scan import scanner
import pandas as pd


def answer_keys():

    ans = {}
    df = pd.read_csv(r"D:\Python\PycharmProjects\OMR_PREP\pythonProject\OMR\answers.csv", header=None)

    df[0] = pd.to_numeric(df[0], errors='coerce').dropna().astype(int)
    df[1] = pd.to_numeric(df[1], errors='coerce').dropna().astype(int)
    df[2] = pd.to_numeric(df[2], errors='coerce').dropna().astype(int)

    print(df)
    for _, row in df.iterrows():
        page =  pd.to_numeric(row[0], errors='coerce')
        question =  pd.to_numeric(row[1], errors='coerce')
        answer =  pd.to_numeric(row[2], errors='coerce')
        print(page)

        # Ensure each question exists in the ans dictionary
        if question not in ans:
                ans[question] = {}

        # Add the answer-value pair for this question
        ans[page][question] = answer

    return ans

ANSWERS = {
    0:{0:0, 1: 2, 2: 1, 3: 0, 4: 3, 5: 2, 6: 0, 7: 1, 8: 2, 9: 3, 10: 1, 11: 2, 12: 0,
    13: 3, 14: 1, 15: 2, 16: 0, 17: 3, 18: 1, 19: 2, 20: 0, 21: 3, 22: 1, 23: 2,
    24: 0, 25: 3, 26: 1, 27: 2, 28: 0, 29: 3, 30: 1, 31: 2, 32: 0, 33: 3, 34: 1,
    35: 2, 36: 0, 37: 3, 38: 1, 39: 2, 40: 0, 41: 2, 42: 0, 43: 3, 44: 1, 45: 2,
    46: 0, 47: 3, 48: 0, 49: 3, 50: 1, 51: 2, 52: 0, 53: 3, 54: 1, 55: 2},
    1:{56: 0, 57: 3, 58: 1, 59: 2, 60: 0, 61: 2, 62: 1, 63: 0, 64: 3, 65: 2, 66: 0, 67: 1,
    68: 2, 69: 3, 70: 1, 71: 2, 72: 0, 73: 3, 74: 1, 75: 2, 76: 0, 77: 3, 78: 1,
    79: 2, 80: 0, 81: 3, 82: 1, 83: 2, 84: 0, 85: 3, 86: 1, 87: 2, 88: 0, 89: 3,
    90: 1, 91: 2, 92: 0, 93: 3, 94: 1, 95: 2, 96: 0, 97: 3, 98: 1, 99: 2, 100: 0,
    101: 2, 102: 1, 103: 0, 104: 3, 105: 2, 106: 0, 107: 1, 108: 2, 109: 3, 110: 1,
    111: 2}
    }
print(ANSWERS)



def preprocess(img):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray, (5,5), 0)
    edged = cv2.Canny(gray, 30, 65)


    cnts = cv2.findContours(edged.copy(), cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
    cnts = imutils.grab_contours(cnts)
    print(len(cnts))
    cnts = sorted(cnts, key=cv2.contourArea, reverse=True)[:1]

    CNTs = None

    for c in cnts:
        peri = cv2.approxPolyDP(c, 0.02 * cv2.arcLength(c, True), True)
        if len(peri) == 4:
            CNTs = peri
            break

    # Ensure we found a valid contour with exactly 4 points
    if CNTs is None:
        print("No suitable contour with 4 points found.")
        sys.exit(1)  # or handle it as needed

    #cv2.drawContours(s1, [peri], -1, (255, 0, 255), 2)
    sc = four_point_transform(img, CNTs.reshape(4,2))
    cv2.imshow("Edged", sc)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
    return sc


ap = argparse.ArgumentParser()
ap.add_argument("-i", "--images", nargs='+', required=True, help="The path to the image")
args = vars(ap.parse_args())

input_img = args["images"]
processed_img = []

for (j, img) in enumerate(input_img):
    image = cv2.imread(img)
    if image is None:
        print("Couldn't read image")
        break
    image = scanner(image)
    img1 = image[25:image.shape[0], 0:image.shape[1] // 2+5]
    img2 = image[25:image.shape[0], image.shape[1] // 2:image.shape[1]]
    processed_img.append(preprocess(img1))
    processed_img.append(preprocess(img2))


score = []
for (j, p) in enumerate(processed_img):
   # Assuming ans_df is already loaded as a dictionary with (page, question) as the key tuple
    pg = j // 2
    lower_bound = 0
    upper_bound = 28


    if j == 0:
            # Extract next 28 question-answer pairs from page 1 (index 0), i.e., questions 28-55
            ans = {k: v for k, v in ANSWERS[pg].items() if 0 <= k < 28}
            ans_no = 28
            last_q = max(ans.keys()) + 1
            lower_bound = 28
            upper_bound = 56
            print("The last question printed is {}".format(last_q))
    elif j == 1:
            # Extract next 28 question-answer pairs from page 1 (index 0), i.e., questions 28-55
            print(last_q)
            ans = {k%last_q: v for k, v in ANSWERS[pg].items() if 28 <= k < 56}
            ans_no = 28
            last_q = max(ans.keys()) + 2
            lower_bound = 28
            upper_bound = 56


    else:
    #figure out the necessary value of last_q
        if j % 2 == 0:
            ans = {k%last_q: v for k, v in ANSWERS[pg].items() if 0 <= k%last_q < 28}
            ans_no = 28
            last_q = max(ans.keys()) +1

        else:
            # Second 30 questions of page j (indexed j)
            ans = {k%last_q: v for k, v in ANSWERS[pg].items() if  0 <= k%last_q < 28}
            ans_no = 28
            last_q = max(ans.keys()) +1
        """

        ans = {k%last_q: v for k, v in ANSWERS[pg].items() if  0 <= k%last_q < 30}
        ans_no = 30
        last_q = max(ans.keys()) + 1
        lower_bound = 0
        upper_bound = 30
            """





    #ans_no = upper_bound - lower_bound
    marks = grader(p, ans, ans_no)
    print(marks)
    score.append(marks)

result = np.sum(score) / len(ANSWERS.items()) * 100
print(result)

# q_no = len(ANSWERS)
# half_q_no = q_no // 2

# ans_1 = {k: v for k, v in ANSWERS.items() if k < half_q_no}
# ans_2 = {(k%half_q_no): v for k, v in ANSWERS.items() if k >= half_q_no }

# image = cv2.imread(args["image"])
# scanned = scanner(image)
# scanner_1 = scanned[25:scanned.shape[0], 0:scanned.shape[1] // 2+5]
# scanner_2 = scanned[25:scanned.shape[0], scanned.shape[1] // 2:scanned.shape[1]]

# cv2.imshow("Scanner1", scanner_1)
# s1 = scanner_1.copy()
# scanner_1 = preprocess(scanner_1)
# scanner_2 = preprocess(scanner_2)

# score1 = grader(scanner_1, ans_1, half_q_no - 1)
# score2 = grader(scanner_2, ans_2, half_q_no - 1)

# score = score1[0] + score2[0]
# total = score1[1] + score2[1]
# print(str(score / total * 100)+"%")


# """
# 0: 2, 1: 1, 2: 0, 3: 3, 4: 2,
# 5: 0, 6: 1, 7: 2, 8: 3, 9: 1,
# 10: 2, 11: 0, 12: 3, 13: 1, 14: 2,
# 15: 0, 16: 3, 17: 1, 18: 2, 19: 0,
# 20: 3, 21: 1, 22: 2, 23: 0, 24: 3,
# 25: 1, 26: 2, 27: 0, 28: 3, 29: 1,
# 30

"""  # Filter the DataFrame for the specified page number
    page_data = ANSWERS[ANSWERS['P'] == page_number]
        # Select questions in the desired range (30 <= Q < 60)
    if j >= 1:
        ans['Q'] = ans['Q'] % last_q
    ans = page_data[((page_data['Q'] >= lower_bound) & (page_data['Q'] < upper_bound)) ]
    print(ans)
    last_q = ans['Q'].max()


"""