# Change to the Code directory, as this is where the server files are located 
# And this is where we need to run the Django specific commands 
cd /code

# We need to start the SSH server so this continer can server a dual purpouse
/etc/init.d/ssh start

python manage.py makemigrations
python manage.py migrate 
python manage.py runserver 0.0.0.0:8000
