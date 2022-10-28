from dataclasses import fields
from rest_framework import serializers
from .models import Memo, Recommendation

class MemoSerializer(serializers.ModelSerializer) :
    class Meta:
        model = Memo
        fields = ('id', 'memotitle', 'memodate')
class RecommendationSerializer(serializers.ModelSerializer) :
    class Meta:
        model = Recommendation
        fields = ('id', 'recommend')