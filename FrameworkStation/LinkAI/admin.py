import imp
from django.contrib import admin
from .models import Memo, Recommendation
# Register your models here.
admin.site.register(Memo)
admin.site.register(Recommendation)