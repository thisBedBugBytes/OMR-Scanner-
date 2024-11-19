import uuid
from django.db import models
import json
# Create your models here.

class Answer_Sheet(models.Model):
  
    #user = models.ForeignKey(User, on_delete=models.CASCADE) = 
    answer = models.JSONField(default=None)
    """
   ans_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
   pages = models.IntegerField(default=1)
   question = models.IntegerField(default=0)
   answer = models.IntegerField(default=0)
   sheet = models.FileField()
   """
def __str__(self):
        return f"Answers for {self.user.username}"