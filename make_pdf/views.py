import os
from django.http import JsonResponse
from django.shortcuts import redirect, render, HttpResponse
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
from rest_framework.response import Response
from firebase_admin import firestore

from rest_framework.decorators import api_view
from django.views.decorators.csrf import csrf_exempt

from .utils.pdf_gen import *
from .utils.score import *
from .forms  import uploadFiles
from main_app.models import *
import logging
import math

logger = logging.getLogger(__name__)

def home(request):
    return render(request, 'base.html')

# Create your views here.
def make_pdf(request):
    questions_num = request.session.get('question_num', 0)
    pdf_created = request.session.get('pdf_created', False)
    logger.info(pdf_created)
    """
    if request.method=="POST":
        
        logger.info(pdf_created)
        name = request.POST.get('file_name')
        que_no = int(request.POST.get('q_no'))

        #questions = que_no
        
        logger.info("Making the pdf")
        pdf = generate_pdf(que_no)

        pdf_created = True
        
        request.session['pdf_created'] = True
        request.session['question_num'] = que_no
        logger.info(str(pdf_created))
        
        logger.info("Sending the pdf")
        response = HttpResponse(pdf, content_type='application/pdf')
        response['Content-Disposition'] = f'attachment; filename={name}.pdf'
        return response
        """
    if request.method == "GET":
        request.session['pdf_created'] = False
        request.session['question_num'] = 0
        pdf_created = False  # 
        questions_num = 0
        ans = Answers.objects.all()
        print(ans)
        return render(request, 'pdf_gen.html', {'pdf_created': pdf_created, 'question_num': questions_num})


def create_pdf(request):
    
    
    if request.method == "POST":
        logger.info("Got the goods")
        file_name = request.POST.get('file_name')
        que_no = request.POST.get('q_no')
        course_id = request.POST.get('course_code')

        teacher_id = request.session.get('email')

        teacher_ref = firestore.client().collection('Teacher').where('email', '==', teacher_id).limit(1).get()
        if teacher_ref:
            teacher_doc = teacher_ref[0]
        #subject_ref = firestore.client().collection('Course').where('course_code', '==', course_id).limit(1).get()
        #if subject_ref:
         #   subject_doc = subject_ref[0]

        test_data = {
                'title': f"Test for {file_name}",
                'subject': "CSE299",
                'teacher_email': "birzara123w@gmail.com",
                'created_at': firestore.SERVER_TIMESTAMP
            }

        # Store the test in Firestore
        test_ref = firestore.client().collection('Test').document()
        test_ref.set(test_data)

        # Create an empty subcollection 'answers' for the test
        test_ref.collection('Answer')
        test_id = test_ref.id 
        # Save test_id in session
        request.session['test_id'] = test_id
        request.session.save()  # Force save the session

        logger.info("Making the pdf")
        pdf = generate_pdf(que_no)
        

        pdf_created = True 
        questions_num = que_no
        request.session.modified = True  # Ensure the session updates are save
        request.session['pdf_created'] = True
        request.session['question_num'] = que_no
        logger.info(str(pdf_created))

        logger.info("Sending the pdf")
        response = HttpResponse(content_type='application/pdf')
        if file_name:  # Ensure file_name is not empty or None
            sanitized_file_name = file_name.replace('"', '').replace("'", "")  # Sanitize input
            response['Content-Disposition'] = f'attachment; filename="{sanitized_file_name}.pdf"'
        else:
            response['Content-Disposition'] = 'attachment; filename="default_name.pdf"'  # Fallback

        # Use a custom header to signal the front-end for a redirect
        response['Redirect-After-Download'] = '/store_ans/'
        return response

   # return render(request, "pdf_gen.html")

def store_ans(request):
    logger.info(request.session.keys()) 
    question_num = int(request.session.get('question_num'))
    range_list = range(0, question_num)
    if request.method == "POST":
        db = firestore.client()
        question_num = int(request.session.get('question_num'))
        pdf_created = request.session.get('pdf_created')

        test_id = request.session['test_id']
        if not test_id:
            # If test_id is missing, return an error response
            return HttpResponse("Test ID not found", status=400)
      
              
        pages = 1 + math.ceil((question_num - 56) / 60) 
        answers = {}
        print(pages)
        q_start = 0
        q_end   = 56 if(question_num > 56) else question_num
        #"question_{{ q }}"
        for page in range(pages+1):
        # Calculate the range of questions for the current page
            if page == 0:
            
                q_start = 0
                q_end = 56  # Questions 0-27
            else:
               
                q_start = 56 + (page - 1) * 60
                q_end = q_start + 60   # Next 60 questions for the page
               
           
            q_end = min(q_end, question_num)

            # Collect answers for the current page and range
            for q in range(q_start, q_end):
                ans = request.POST.get(f'question_{q}')
                if ans is not None:
                    if page not in answers:
                        answers[page] = {}
                    #answers[page][q] = int(ans)  # Store the answer as an integer (0, 1, 2, 3)
                
                        answer_data = {
                    'Page': page,
                    'Answer': int(ans),  # Store the answer as an integer (0, 1, 2, 3)
                    'Teacher_id': request.session.get('teacher_email'),
                    'Course_code': request.session.get('course_code'),
                    'Date_log': firestore.SERVER_TIMESTAMP
                }

                # Create the Firestore document for each question on this page
                answer_doc_ref = db.collection('Test').document(test_id).collection('Answer').document(str(q))

                # Set the document data in Firestore
                answer_doc_ref.set({
                    'Answer_data': answer_data,
                    'Test_id': test_id
                })

                    
        print(answers)
        #my_instance = Answer_Sheet.objects.create(answer=answers)

        return render(request, "pdf_gen.html", {'pdf_created': pdf_created})
    else:
       
       
        return render(request, 'answers.html', {'range_list': range_list})

@csrf_exempt
def submit_paper(request):
    if request.method == "POST":
            images = request.FILES.getlist('images')
            logger.info('POST')
            ANSWERS = {
            0:{0:0, 1: 2, 2: 1, 3: 0, 4: 3, 5: 2, 6: 0, 7: 1, 8: 2, 9: 3, 10: 1, 11: 2, 12: 0,
            13: 3, 14: 1, 15: 2, 16: 0, 17: 3, 18: 1, 19: 2, 20: 0, 21: 3, 22: 1, 23: 2,
            24: 0, 25: 3, 26: 1, 27: 2, 28: 0, 29: 3, 30: 1, 31: 2, 32: 0, 33: 3, 34: 1,
            35: 2, 36: 0, 37: 3, 38: 1, 39: 2, 40: 0, 41: 2, 42: 0, 43: 3, 44: 1, 45: 2,
            46: 0, 47: 3, 48: 0, 49: 3, 50: 1, 51: 2, 52: 0, 53: 3, 54: 1, 55: 2}}
            """ 1:{56: 0, 57: 3, 58: 1, 59: 2, 60: 0, 61: 2, 62: 1, 63: 0, 64: 3, 65: 2, 66: 0, 67: 1,
            68: 2, 69: 3, 70: 1, 71: 2, 72: 0, 73: 3, 74: 1, 75: 2, 76: 0, 77: 3, 78: 1,
            79: 2, 80: 0, 81: 3, 82: 1, 83: 2, 84: 0, 85: 3, 86: 1, 87: 2, 88: 0, 89: 3,
            90: 1, 91: 2, 92: 0, 93: 3, 94: 1, 95: 2, 96: 0, 97: 3, 98: 1, 99: 2, 100: 0,
            101: 2, 102: 1, 103: 0, 104: 3, 105: 2, 106: 0, 107: 1, 108: 2, 109: 3, 110: 1,
            111: 2}}"""

    
            score = 0
            for image in images:
                temp_path = default_storage.save(f"test_paper/{image.name}", ContentFile(image.read()))
                full_path = os.path.join(default_storage.location, temp_path)
                marks = scorer(full_path)  
                score += marks  
                logger.info(marks)
            logger.info(score)
            return  JsonResponse({"score": score}, status=200)
           # uploaded_images = gallery.objects.all()

    return render(request, 'grade_submit.html')
 





#load html page for file upload
@api_view(['POST'])
@csrf_exempt
def submitPaper(request):
    if request.method == "POST":
            images = request.FILES.getlist('images')
            logger.info('POST')
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
            score = 0
            for image in images:
                temp_path = default_storage.save(f"test_paper/{image.name}", ContentFile(image.read()))
                full_path = os.path.join(default_storage.location, temp_path)
                marks = scorer2(full_path)  
                score += marks  
                logger.info(marks)
            logger.info(score)
            return  JsonResponse({"score": score}, status=200)
           # uploaded_images = gallery.objects.all()

    return render(request, 'grade_submit.html')
 

#process the uploaded images

@api_view(['POST'])
@csrf_exempt
def createPDF(request):
     

        #data = request.data  # Use `request.data` if you're using DRF
        # Or if you're manually decoding JSON:
       if request.method == "POST":
        logger.info("Got the goods")
        file_name = request.POST.get('file_name')
        que_no = request.POST.get('q_no')
        logger.info(que_no)
        if not file_name or not que_no:
            return Response({"error": "Missing parameters"}, status=400)


        #undo comment after teacher login is instantiated
        """
        
        teacher_id = request.session.get('teacher_id')
        course_id = request.session.get('course_id')

        teacher = Teacher.objects.get(teacher_id=teacher_id)
        course = Course.objects.get(course_code=course_id)

        test = Test.objects.create(
            title = f"Test for {course.course_name}",
            course = course,
            teacher = teacher
        )""" 
        if not file_name or not que_no:
            logger.error("Missing file_name or que_no")
            return Response({"error": "Missing parameters"}, status=400)


        logger.info("Making the pdf")
        pdf = generate_pdf(que_no)
        if not pdf:
            return Response("Failed to generate PDF", status=500)
        questions_num = que_no
        request.session.modified = True  # Ensure the session updates are save
        request.session['pdf_created'] = True
        request.session['question_num'] = que_no
        

        logger.info("Sending the pdf")
        response = HttpResponse(pdf, content_type='application/pdf')
        if file_name:  # Ensure file_name is not empty or None
            sanitized_file_name = file_name.replace('"', '').replace("'", "")  # Sanitize input
            response['Content-Disposition'] = f'attachment; filename="{sanitized_file_name}.pdf"'
        else:
            response['Content-Disposition'] = 'attachment; filename="default_name.pdf"'  # Fallback

        return response
       
       else:
           return Response("Pdf not received") 
        


 