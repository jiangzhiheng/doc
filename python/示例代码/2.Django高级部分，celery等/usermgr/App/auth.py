from django.db.models import Q
from App.models import User
from django.contrib.auth.backends import ModelBackend

class MyBackend(ModelBackend):
    def authenticate(self, username=None, password=None):
        user = User.objects.filter(Q(username=username)|Q(phone=username)).first()
        if user:
            if user.check_password(password):
                return user
        return None