from django.shortcuts import render
from rest_framework import viewsets
from .models import Memo,Recommendation
from .serializers import MemoSerializer, RecommendationSerializer

# Create your views here.
class MemoView(viewsets.ModelViewSet) :
    queryset = Memo.objects.all()
    serializer_class = MemoSerializer
class RecommendationView(viewsets.ModelViewSet) :
    queryset = Recommendation.objects.all()
    serializer_class = RecommendationSerializer