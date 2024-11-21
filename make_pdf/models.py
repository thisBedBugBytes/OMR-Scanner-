import uuid
from django.db import models
import json
# Create your models here.

class Teacher(models.Model):
    teacher_id = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    teacher_name = models.CharField(max_length=255)

class Student(models.Model):
    student_id = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    student_name =  models.CharField(max_length=255)

class Course(models.Model):
    course_code = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    course_name = models.CharField(max_length=255)
    teacher = models.ForeignKey(Teacher, on_delete=models.CASCADE)


class Test(models.Model):
    test_id = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    title =  models.CharField(max_length=255)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    teacher = models.ForeignKey(Teacher, on_delete=models.CASCADE)

class Answers(models.Model):
    class AnswerChoice(models.IntegerChoices):
        A = 0
        B = 1
        C = 2
        D = 3
    answer_id = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    test = models.ForeignKey(Test, on_delete=models.CASCADE)
    page_number = models.IntegerField()
    question_number = models.IntegerField()
    correct_answer = models.IntegerField(choices=AnswerChoice.choices)

class Submission(models.Model):
    name = models.CharField(max_length=255)
    paper = models.ImageField(upload_to='test_paper')