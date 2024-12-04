"""student_management_system URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import path

from main_app.EditResultView import EditResultView

from . import chair_views, teacher_views, student_views, views

urlpatterns = [
    path("123", views.login_page, name='login_page'),
    path("firebase-messaging-sw.js", views.showFirebaseJS, name='showFirebaseJS'),
    path("doLogin/", views.doLogin, name='user_login'),
    path("logout_user/", views.logout_user, name='user_logout'),
    path("admin/home/", chair_views.admin_home, name='admin_home'),
    path("teacher/add", chair_views.add_teacher, name='add_teacher'),
    path("department/add", chair_views.add_department, name='add_department'),
    path("send_student_notification/", chair_views.send_student_notification,
         name='send_student_notification'),
    path("send_teacher_notification/", chair_views.send_teacher_notification,
         name='send_teacher_notification'),
    path("add_examination/", chair_views.add_examination, name='add_examination'),
    path("admin_notify_student", chair_views.admin_notify_student,
         name='admin_notify_student'),
    path("admin_notify_teacher", chair_views.admin_notify_teacher,
         name='admin_notify_teacher'),
    path("admin_view_profile", chair_views.admin_view_profile,
         name='admin_view_profile'),
    path("check_email_availability", chair_views.check_email_availability,
         name="check_email_availability"),
    path("examination/manage/", chair_views.manage_examination, name='manage_examination'),
    path("examination/edit/<int:examination_id>",
         chair_views.edit_examination, name='edit_examination'),
    path("student/view/feedback/", chair_views.student_feedback_message,
         name="student_feedback_message",),
    path("teacher/view/feedback/", chair_views.teacher_feedback_message,
         name="teacher_feedback_message",),
    path("student/view/leave/", chair_views.view_student_leave,
         name="view_student_leave",),
    path("teacher/view/leave/", chair_views.view_teacher_leave, name="view_teacher_leave",),

    path("student/add/", chair_views.add_student, name='add_student'),
    path("subject/add/", chair_views.add_subject, name='add_subject'),
    path("teacher/manage/", chair_views.manage_teacher, name='manage_teacher'),
    path("student/manage/", chair_views.manage_student, name='manage_student'),
    path("department/manage/", chair_views.manage_department, name='manage_department'),
    path("subject/manage/", chair_views.manage_subject, name='manage_subject'),
    path("teacher/edit/<int:teacher_id>", chair_views.edit_teacher, name='edit_teacher'),
    path("teacher/delete/<int:teacher_id>",
         chair_views.delete_teacher, name='delete_teacher'),

    path("department/delete/<int:department_id>",
         chair_views.delete_department, name='delete_department'),

    path("subject/delete/<int:subject_id>",
         chair_views.delete_subject, name='delete_subject'),

    path("examination/delete/<int:examination_id>",
         chair_views.delete_examination, name='delete_examination'),

    path("student/delete/<int:student_id>",
         chair_views.delete_student, name='delete_student'),
    path("student/edit/<int:student_id>",
         chair_views.edit_student, name='edit_student'),
    path("department/edit/<int:department_id>",
         chair_views.edit_department, name='edit_department'),
    path("subject/edit/<int:subject_id>",
         chair_views.edit_subject, name='edit_subject'),


    # teacher
    path("teacher/home/", teacher_views.teacher_home, name='teacher_home'),
    path("teacher/apply/leave/", teacher_views.teacher_apply_leave,
         name='teacher_apply_leave'),
    path("teacher/feedback/", teacher_views.teacher_feedback, name='teacher_feedback'),
    path("teacher/view/profile/", teacher_views.teacher_view_profile,
         name='teacher_view_profile'),
   
    path("teacher/get_students/", teacher_views.get_students, name='get_students'),
    
   
    path("teacher/fcmtoken/", teacher_views.teacher_fcmtoken, name='teacher_fcmtoken'),
    path("teacher/view/notification/", teacher_views.teacher_view_notification,
         name="teacher_view_notification"),
    path("teacher/result/add/", teacher_views.teacher_add_result, name='teacher_add_result'),
    path("teacher/result/edit/", EditResultView.as_view(),
         name='edit_student_result'),
    path('teacher/result/fetch/', teacher_views.fetch_student_result,
         name='fetch_student_result'),

  #   path("teacher/feedback2/", teacher_views.feedback_message, name='feedback'),


    # Student
    path("student/home/", student_views.student_home, name='student_home'),
   
    path("student/apply/leave/", student_views.student_apply_leave,
         name='student_apply_leave'),
    path("student/feedback/", student_views.student_feedback,
         name='student_feedback'),
    path("student/view/profile/", student_views.student_view_profile,
         name='student_view_profile'),
    path("student/fcmtoken/", student_views.student_fcmtoken,
         name='student_fcmtoken'),
    path("student/view/notification/", student_views.student_view_notification,
         name="student_view_notification"),
    path('student/view/result/', student_views.student_view_result,
         name='student_view_result'),

  #  path("student/feedback2/", student_views.feedback,
   #      name='student_feedback'),

]
