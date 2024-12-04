# Generated by Django 5.1.3 on 2024-11-19 07:21

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main_app', '0002_alter_admin_id_alter_attendance_id_and_more'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='Staff',
            new_name='Teacher',
        ),
        migrations.RenameModel(
            old_name='Course',
            new_name='Department',
        ),
        migrations.RenameModel(
            old_name='Session',
            new_name='Examination',
        ),
        migrations.RenameModel(
            old_name='FeedbackStaff',
            new_name='FeedbackTeacher',
        ),
        migrations.RenameModel(
            old_name='NotificationStaff',
            new_name='NotificationTeacher',
        ),
        migrations.RenameField(
            model_name='attendance',
            old_name='session',
            new_name='examination',
        ),
        migrations.RenameField(
            model_name='feedbackteacher',
            old_name='staff',
            new_name='teacher',
        ),
        migrations.RenameField(
            model_name='notificationteacher',
            old_name='staff',
            new_name='teacher',
        ),
        migrations.RenameField(
            model_name='student',
            old_name='course',
            new_name='department',
        ),
        migrations.RenameField(
            model_name='student',
            old_name='session',
            new_name='examination',
        ),
        migrations.RenameField(
            model_name='subject',
            old_name='course',
            new_name='department',
        ),
        migrations.RenameField(
            model_name='subject',
            old_name='staff',
            new_name='teacher',
        ),
        migrations.RenameField(
            model_name='teacher',
            old_name='course',
            new_name='department',
        ),
        migrations.AlterField(
            model_name='customuser',
            name='user_type',
            field=models.CharField(choices=[(1, 'HOD'), (2, 'Teacher'), (3, 'Student')], default=1, max_length=1),
        ),
        
        migrations.CreateModel(
            name='LeaveReportTeacher',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.CharField(max_length=60)),
                ('message', models.TextField()),
                ('status', models.SmallIntegerField(default=0)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('teacher', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='main_app.teacher')),
            ],
        ),
        migrations.DeleteModel(
            name='LeaveReportStaff',
        ),
    ]