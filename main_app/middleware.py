from django.utils.deprecation import MiddlewareMixin
from django.urls import reverse
from django.shortcuts import redirect


class LoginCheckMiddleWare(MiddlewareMixin):
    def process_view(self, request, view_func, view_args, view_kwargs):
        modulename = view_func.__module__
        user = request.user # Who is the current user ?
        if user.is_authenticated:
            if user.user_type == '1': 
                if modulename == 'main_app.student_views':
                    return redirect(reverse('admin_home'))
            elif user.user_type == '2': #  Teacher :-/ ?
                if modulename == 'main_app.student_views' or modulename == 'main_app.chair_views':
                    return redirect(reverse('teacher_home'))
            elif user.user_type == '3': # ... or Student ?
                if modulename == 'main_app.chair_views' or modulename == 'main_app.teacher_views':
                    return redirect(reverse('student_home'))
            else: # None of the aforementioned ? Please take the user to login page
                return redirect(reverse('login_page'))
        else:
            if request.path == reverse('login_page') or modulename == 'django.contrib.auth.views' or request.path == reverse('user_login'): # If the path is login or has anything to do with authentication, pass
                pass
            else:
                return redirect(reverse('login_page'))
