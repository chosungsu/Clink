from django.urls import path, include
from .views import UserAPI
urlpatterns = [
    path('user/', UserAPI)
]
