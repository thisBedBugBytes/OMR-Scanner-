# Generated by Django 5.1.3 on 2024-12-01 08:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main_app', '0010_remove_student_examinations_student_examination'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='student',
            name='examination',
        ),
        migrations.AddField(
            model_name='student',
            name='examination',
            field=models.ManyToManyField(related_name='students', to='main_app.examination'),
        ),
    ]