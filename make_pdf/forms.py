from django import forms
from .models import Submission

class uploadFiles(forms.ModelForm):
   class Meta:
     # 
      model = Submission
      fields = {'name','paper'}
