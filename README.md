# Pages_devops

Projekt Zaliczeniowy – Cykl Życia i Narzędzia DevOps
Link do repozytorium: https://github.com/michalmajda/devops-project
Cel projektu:
Celem projektu jest stworzenie, konteneryzacja oraz automatyzacja procesu CI/CD dla prostej
aplikacji webowej napisanej w Django. Projekt obejmuje zarządzanie kodem źródłowym w
repozytorium GitHub, tworzenie Pull Requestów (PR) oraz wdrożenie procesu Continuous
Integration (CI) za pomocą GitHub Actions.
Technologie użyte w projekcie:
 Język: Python
 Framework: Django
 Konteneryzacja: Docker
 Repozytorium Git: GitHub
 Automatyzacja CI/CD: GitHub Actions
Tworzenie aplikacji Django:
1. Utworzenie i aktywacja środowiska wirtualnego:
 Windows:
bash
Skopiuj kod
cd desktop\code
mkdir pages
cd pages
python -m venv .venv
.venv\Scripts\Activate.ps1
python -m pip install django~=4.0.0
django-admin startproject django_project .
python manage.py startapp pages
 macOS/Linux:
bash
Skopiuj kod
cd ~/desktop/code
mkdir pages
cd pages
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install django~=4.0.0
django-admin startproject django_project .
python3 manage.py startapp pages2. Konfiguracja aplikacji w settings.py:
Dodanie aplikacji pages do listy INSTALLED_APPS:
python
# django_project/settings.py
INSTALLED_APPS = [
'django.contrib.admin',
'django.contrib.auth',
'django.contrib.contenttypes',
'django.contrib.sessions',
'django.contrib.messages',
'django.contrib.staticfiles',
'pages.apps.PagesConfig', # Dodane
]
3. Uruchomienie migracji baz danych i serwera deweloperskiego:
bash
python manage.py migrate
python manage.py runserver
Aplikacja będzie dostępna pod adresem: http://127.0.0.1:8000/
Tworzenie repozytorium Git:
1. Inicjowanie repozytorium Git:
bash
git init
2. Dodawanie plików do repozytorium i pierwszy commit:
bash
git add .
git commit -m "Initial commit"
3. Utworzenie nowego repozytorium na GitHubie i dodanie zdalnego repozytorium:
bash
Skopiuj kod
git remote add origin https://github.com/michalmajda/devops-project.git
git push -u origin main
Tworzenie Pull Requestów (PR):
1. Tworzenie nowej gałęzi (branch):
bashgit checkout -b feature/new-page
2. Wprowadzanie zmian w kodzie (np. dodanie nowej strony):
3. Dodawanie i zatwierdzanie zmian:
bash
Skopiuj kod
git add .
git commit -m "Add new page feature"
4. Wypchnięcie gałęzi na GitHub:
bash
git push --set-upstream origin feature/new-page
5. Utworzenie Pull Request na GitHubie:
 Przejdź do swojego repozytorium na GitHubie.
 Kliknij na zakładkę "Pull requests".
 Kliknij przycisk "New pull request".
 Wybierz bazową gałąź main i porównawczą gałąź feature/new-page.
 Dodaj tytuł i opis PR, następnie kliknij "Create pull request".
Konteneryzacja aplikacji (Docker):
1. Utworzenie pliku Dockerfile:
bash
touch Dockerfile
2. Zawartość pliku Dockerfile:
dockerfile
FROM python:3.10-slim-bullseye
# Instalacja niezbędnych narzędzi kompilacyjnych
RUN apt-get update \
&& apt-get install -y --no-install-recommends build-essential gcc \
&& rm -rf /var/lib/apt/lists/*
WORKDIR /app
# Kopiowanie pliku requirements.txt i instalacja zależności
COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt
# Kopiowanie reszty aplikacji
COPY . /app# Uruchomienie aplikacji Django
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
3. Budowanie obrazu Docker:
bash
docker build -t my-django-app .
4. Uruchomienie kontenera Docker:
bash
docker run -p 8000:8000 my-django-app
Aplikacja będzie dostępna pod adresem: http://localhost:8000
Konfiguracja GitHub Actions (CI):
1. Utworzenie folderu i pliku konfiguracji CI:
bash
Skopiuj kod
mkdir -p .github/workflows
touch .github/workflows/ci.yml
name: CI/CD Pipeline
on:
push:
branches:
- main
pull_request:
branches:
- main
jobs:
build-and-push:
runs-on: ubuntu-latest
steps:
# Krok 1: Checkout kodu
- name: Checkout repository
uses: actions/checkout@v4
# Krok 2: Ustawienie Python
- name: Set up Python
uses: actions/setup-python@v4
with:
python-version: '3.10'
# Krok 3: Cache pip dependencies- name: Cache pip
uses: actions/cache@v3
with:
path: ~/.cache/pip
key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
restore-keys: |
${{ runner.os }}-pip-
# Krok 4: Instalacja zależności
- name: Install dependencies
run: |
python -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
# Krok 5: Uruchomienie testów
- name: Run tests
run: echo "Test"
# Możesz zastąpić powyższą linię rzeczywistymi testami
# Krok 6: Logowanie do DockerHub
- name: Log in to DockerHub
uses: docker/login-action@v2
with:
username: ${{ secrets.DOCKERHUB_USERNAME }}
password: ${{ secrets.DOCKERHUB_TOKEN }}
# Krok 7: Budowanie obrazu Docker
- name: Build Docker image
run: docker build -t my-django-app:${{ github.sha }} .
# Krok 8: Tagowanie obrazu Docker jako latest
- name: Tag Docker image
run: docker tag my-django-app:${{ github.sha }} my-django-app:latest
# Krok 9: Wypychanie obrazu Docker do DockerHub
- name: Push Docker image
run: |
docker push my-django-app:${{ github.sha }}
docker push my-django-app:latest
Dodanie pliku .gitignore:
touch .gitignore
Weryfikacja działania procesu CI:
1. Monitorowanie Workflow na GitHub Actions:
 Przejdź do swojego repozytorium na GitHubie.
 Kliknij na zakładkę "Actions". Znajdź najnowsze uruchomienie workflow oznaczone jako "CI/CD Pipeline".
 Kliknij na uruchomienie, aby zobaczyć szczegółowe logi poszczególnych kroków.
2.
Sprawdzenie obrazów Docker na DockerHub:
 Zaloguj się na swoje konto DockerHub.
 Przejdź do swojego repozytorium my-django-app.
 Sprawdź listę tagów, aby upewnić się, że nowe tagi (latest oraz unikalny SHA commit) są
widoczne.
 Stworzenie aplikacji Django i jej konfiguracja.
 Konteneryzacja aplikacji za pomocą Docker.
 Zarządzanie kodem źródłowym w repozytorium GitHub.
 Tworzenie Pull Requestów (PR) do gałęzi main.
 Konfiguracja GitHub Actions dla automatyzacji procesu CI/CD.
 Monitorowanie i weryfikacja działania procesów CI/CD.
 Dalsze optymalizacje i automatyzacje w celu zwiększenia efektywności procesu
DevOps.