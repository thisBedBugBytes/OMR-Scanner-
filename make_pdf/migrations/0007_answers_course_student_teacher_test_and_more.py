# Generated by Django 5.1.2 on 2024-11-21 10:35

import django.db.models.deletion
import uuid
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("make_pdf", "0006_submission_name_alter_submission_id"),
    ]

    operations = [
        migrations.CreateModel(
            name="Answers",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "answer_id",
                    models.UUIDField(default=uuid.uuid4, editable=False, unique=True),
                ),
                ("page_number", models.IntegerField()),
                ("question_number", models.IntegerField()),
                (
                    "correct_answer",
                    models.IntegerField(
                        choices=[(0, "A"), (1, "B"), (2, "C"), (3, "D")]
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Course",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "course_code",
                    models.UUIDField(default=uuid.uuid4, editable=False, unique=True),
                ),
                ("course_name", models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name="Student",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "student_id",
                    models.UUIDField(default=uuid.uuid4, editable=False, unique=True),
                ),
                ("student_name", models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name="Teacher",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "teacher_id",
                    models.UUIDField(default=uuid.uuid4, editable=False, unique=True),
                ),
                ("teacher_name", models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name="Test",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "test_id",
                    models.UUIDField(default=uuid.uuid4, editable=False, unique=True),
                ),
                ("title", models.CharField(max_length=255)),
            ],
        ),
        migrations.DeleteModel(
            name="Answer_Sheet",
        ),
        migrations.AlterField(
            model_name="submission",
            name="name",
            field=models.CharField(max_length=255),
        ),
        migrations.AddField(
            model_name="course",
            name="teacher",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="make_pdf.teacher"
            ),
        ),
        migrations.AddField(
            model_name="test",
            name="course",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="make_pdf.course"
            ),
        ),
        migrations.AddField(
            model_name="test",
            name="teacher",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="make_pdf.teacher"
            ),
        ),
        migrations.AddField(
            model_name="answers",
            name="test",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="make_pdf.test"
            ),
        ),
    ]