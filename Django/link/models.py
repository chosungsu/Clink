from django.db import models

# Create your models here.
class User(models.Model):
    #nick, email, code
    nick = models.CharField(max_length=100)
    email = models.TextField()
    code = models.TextField()