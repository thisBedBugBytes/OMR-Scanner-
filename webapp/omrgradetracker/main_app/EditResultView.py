from django.shortcuts import get_object_or_404, render, redirect
from django.views import View
from django.contrib import messages
from .models import Subject, Teacher, Student, StudentResult
from .forms import EditResultForm
from django.urls import reverse


class EditResultView(View):
    def get(self, request, *args, **kwargs):
        resultForm = EditResultForm()
        teacher = get_object_or_404(Teacher, admin=request.user)
        resultForm.fields['subject'].queryset = Subject.objects.filter(teacher=teacher)
        context = {
            'form': resultForm,
            'page_title': "Update Student's Result"
        }
        return render(request, "teacher_template/edit_student_result.html", context)

    def post(self, request, *args, **kwargs):
        form = EditResultForm(request.POST)
        context = {'form': form, 'page_title': "Update Student's Result"}
        if form.is_valid():
            try:
                student = form.cleaned_data.get('student')
                subject = form.cleaned_data.get('subject')
                exam = form.cleaned_data.get('exam')
                marksheet_pic = form.cleaned_data.get('marksheet_pic')
                # Validating
                result = StudentResult.objects.get(student=student, subject=subject)
                result.exam = exam
                
                result.save()
                messages.success(request, "Result Updated")
                return redirect(reverse('edit_student_result'))
            except Exception as e:
                messages.warning(request, "Result Could Not Be Updated")
      #  else:
       #     messages.warning(request, "Result Could Not Be Updated")
        return render(request, "teacher_template/edit_student_result.html", context)