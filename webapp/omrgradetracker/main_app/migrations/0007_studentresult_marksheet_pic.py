# Generated by Django 5.1.3 on 2024-11-19 18:54

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main_app', '0006_rename_end_year_examination_exam_date_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='studentresult',
            name='marksheet_pic',
            field=models.ImageField(default=0, upload_to=''),
            preserve_default=False,
        ),
    ]