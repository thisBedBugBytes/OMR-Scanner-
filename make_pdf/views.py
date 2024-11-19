from django.shortcuts import redirect, render, HttpResponse
from .utils.pdf_gen import generate_pdf
from .models import *
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
        ans = Answer_Sheet.objects.all()
        print(ans)
        return render(request, 'pdf_gen.html', {'pdf_created': pdf_created, 'question_num': questions_num})


def create_pdf(request):
    
    
    if request.method == "POST":
        logger.info("Got the goods")
        name = request.POST.get('file_name')
        que_no = request.POST.get('q_no')
        
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
        response['Content-Disposition'] = 'attachment; filename="{name}.pdf"'

        # Use a custom header to signal the front-end for a redirect
        response['Redirect-After-Download'] = '/store_ans/'
        return response

   # return render(request, "pdf_gen.html")

def store_ans(request):
    question_num = int(request.session.get('question_num'))
    range_list = range(0, question_num)
    if request.method == "POST":

        question_num = int(request.session.get('question_num'))
        pdf_created = request.session.get('pdf_created')

        pages = 1 + math.ceil((question_num - 56) / 60) 
        answers = {}
        print(pages)
        q_start = 0
        q_end   = 56 if(question_num > 56) else question_num
        #"question_{{ q }}"
        for page in range(pages+1):
        # Calculate the range of questions for the current page
            if page == 0:
                # For page 0, the range is 0-27 (28 questions)
                q_start = 0
                q_end = 56  # Questions 0-27
            else:
                # For pages 1 and onwards, the range increases by 60 questions per page
                q_start = 56 + (page - 1) * 60
                q_end = q_start + 60   # Next 60 questions for the page
               
            # Ensure that the range does not exceed the total number of questions
            q_end = min(q_end, question_num)

            # Collect answers for the current page and range
            for q in range(q_start, q_end):
                ans = request.POST.get(f'question_{q}')
                if ans is not None:
                    if page not in answers:
                        answers[page] = {}
                    answers[page][q] = int(ans)  # Store the answer as an integer (0, 1, 2, 3)

        print(answers)
        #my_instance = Answer_Sheet.objects.create(answer=answers)

        return render(request, "pdf_gen.html", {'pdf_created': pdf_created})
    else:
       
       
        return render(request, 'answers.html', {'range_list': range_list})


        