from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name="home"), #calls the views.py here 
    path('image_gen/', views.make_pdf, name="make_pdf"),
    path('create_pdf/' , views.create_pdf, name="create_pdf"),
    path("store_ans/" , views.store_ans, name="store_ans"),
    path("submit_paper/", views.submit_paper, name="submit_paper"),
    path("submitPaper/", views.submitPaper, name="submitPaper"),
    path("pdf_generation/", views.createPDF, name="pdf_generation")
]