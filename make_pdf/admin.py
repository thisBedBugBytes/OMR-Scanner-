from django.contrib import admin
from .models import *
# Register your models here.
admin.site.register(Teacher)
admin.site.register(Student)
admin.site.register(Course)
admin.site.register(Test)
admin.site.register(Answers)
admin.site.register(Submission)