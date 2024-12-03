import json

from django.contrib import messages
from django.core.files.storage import FileSystemStorage
from django.http import HttpResponse, JsonResponse
from django.shortcuts import (HttpResponseRedirect, get_object_or_404,redirect, render)
from django.urls import reverse
from django.views.decorators.csrf import csrf_exempt

from .forms import *
from .models import *


def teacher_home(request):
    teacher = get_object_or_404(Teacher, admin=request.user)
    total_students = Student.objects.filter(department=teacher.department).count()
    
    subjects = Subject.objects.filter(teacher=teacher)
    total_subject = subjects.count()
    
    total_attendance = attendance_list.count()
    attendance_list = []
    subject_list = []
    for subject in subjects:
        
        subject_list.append(subject.name)
        
    context = {
        'page_title': 'Teacher Panel - ' + str(teacher.admin.last_name) + ' (' + str(teacher.department) + ')',
        'total_students': total_students,
        'total_attendance': total_attendance,
        
        'total_subject': total_subject,
        'subject_list': subject_list,
        'attendance_list': attendance_list
    }
    return render(request, 'teacher_template/home_content.html', context)




@csrf_exempt
def get_students(request):
    subject_id = request.POST.get('subject')
    examination_id = request.POST.get('examination')
    try:
        subject = get_object_or_404(Subject, id=subject_id)
        examination = get_object_or_404(Examination, id=examination_id)
        students = Student.objects.filter(
            department_id=subject.department.id, examination=examination)
        student_data = []
        for student in students:
            data = {
                    "id": student.id,
                    "name": student.admin.last_name + " " + student.admin.first_name
                    }
            student_data.append(data)
        return JsonResponse(json.dumps(student_data), content_type='application/json', safe=False)
    except Exception as e:
        return e








def teacher_feedback(request):
    form = FeedbackTeacherForm(request.POST or None)
    teacher = get_object_or_404(Teacher, admin_id=request.user.id)
    context = {
        'form': form,
        'feedbacks': FeedbackTeacher.objects.filter(teacher=teacher),
        'page_title': 'Add Message'
    }
    if request.method == 'POST':
        if form.is_valid():
            try:
                obj = form.save(commit=False)
                obj.teacher = teacher
                obj.save()
                messages.success(request, "Message submitted for review")
                return redirect(reverse('teacher_feedback'))
            except Exception:
                messages.error(request, "Could not Submit!")
        else:
            messages.error(request, "Form has errors!")
    return render(request, "teacher_template/teacher_feedback.html", context)

@csrf_exempt
def feedback_message(request):
    if request.method != 'POST':
        feedbacks = Feedback.objects.all()
        context = {
            'feedbacks': feedbacks,
            'page_title': ' Messages'
        }
        return render(request, 'teacher_template/feedback.html', context)
    else:
        feedback_id = request.POST.get('id')
        try:
            feedback = get_object_or_404(Feedback, id=feedback_id)
            reply = request.POST.get('reply')
            feedback.reply = reply
            feedback.save()
            return HttpResponse(True)
        except Exception as e:
            return HttpResponse(False)

def teacher_view_profile(request):
    teacher = get_object_or_404(Teacher, admin=request.user)
    form = TeacherEditForm(request.POST or None, request.FILES or None,instance=teacher)
    context = {'form': form, 'page_title': 'View/Update Profile'}
    if request.method == 'POST':
        try:
            if form.is_valid():
                first_name = form.cleaned_data.get('first_name')
                last_name = form.cleaned_data.get('last_name')
                password = form.cleaned_data.get('password') or None
                address = form.cleaned_data.get('address')
                gender = form.cleaned_data.get('gender')
                passport = request.FILES.get('profile_pic') or None
                admin = teacher.admin
                if password != None:
                    admin.set_password(password)
                if passport != None:
                    fs = FileSystemStorage()
                    filename = fs.save(passport.name, passport)
                    passport_url = fs.url(filename)
                    admin.profile_pic = passport_url
                admin.first_name = first_name
                admin.last_name = last_name
                admin.address = address
                admin.gender = gender
                admin.save()
                teacher.save()
                messages.success(request, "Profile Updated!")
                return redirect(reverse('teacher_view_profile'))
            else:
                messages.error(request, "Invalid Data Provided")
                return render(request, "teacher_template/teacher_view_profile.html", context)
        except Exception as e:
            messages.error(
                request, "Error Occured While Updating Profile " + str(e))
            return render(request, "teacher_template/teacher_view_profile.html", context)

    return render(request, "teacher_template/teacher_view_profile.html", context)


@csrf_exempt
def teacher_fcmtoken(request):
    token = request.POST.get('token')
    try:
        teacher_user = get_object_or_404(CustomUser, id=request.user.id)
        teacher_user.fcm_token = token
        teacher_user.save()
        return HttpResponse("True")
    except Exception as e:
        return HttpResponse("False")


def teacher_view_notification(request):
    teacher = get_object_or_404(Teacher, admin=request.user)
    notifications = NotificationTeacher.objects.filter(teacher=teacher)
    context = {
        'notifications': notifications,
        'page_title': "View Notifications"
    }
    return render(request, "teacher_template/teacher_view_notification.html", context)

def teacher_add_result(request):
    teacher = get_object_or_404(Teacher, admin=request.user)
    subjects = Subject.objects.filter(teacher=teacher)
    examinations = Examination.objects.all()
    context = {
        'page_title': 'Result Upload',
        'subjects': subjects,
        'examinations': examinations,
    }

    if request.method == 'POST':
        try:
            student_id = request.POST.get('student_list')
            subject_id = request.POST.get('subject')
            marksheet_pic = request.FILES.get('marksheet_pic')  # Retrieve uploaded file
            exam = request.POST.get('exam')

            # Fetch the student and subject
            student = get_object_or_404(Student, id=student_id)
            subject = get_object_or_404(Subject, id=subject_id)

            # Fetch or create StudentResult
            result, created = StudentResult.objects.get_or_create(
                student=student,
                subject=subject,
                defaults={'exam': exam, 'marksheet_pic': marksheet_pic}
            )

            if not created:  # If the result already exists, update it
                result.exam = exam
                if marksheet_pic:  # Update the marksheet if a new one is provided
                    result.marksheet_pic = marksheet_pic
                result.save()
                messages.success(request, "Result updated successfully!")
            else:
                if marksheet_pic:  # Ensure the marksheet is saved on creation
                    result.marksheet_pic = marksheet_pic
                result.save()
                messages.success(request, "Result saved successfully!")
        except Exception as e:
            messages.warning(request, f"Error occurred while processing form: {str(e)}")

    return render(request, "teacher_template/teacher_add_result.html", context)



@csrf_exempt
def fetch_student_result(request):
    try:
        subject_id = request.POST.get('subject')
        student_id = request.POST.get('student')
        student = get_object_or_404(Student, id=student_id)
        subject = get_object_or_404(Subject, id=subject_id)
        result = StudentResult.objects.get(student=student, subject=subject)
        
        
                    
                    
        result_data = {
            'exam': result.exam,
            'marksheet_pic_url': result.marksheet_pic.url if result.marksheet_pic else None
            
            
            
        }
        return HttpResponse(json.dumps(result_data))
    except Exception as e:
        return HttpResponse('False')
