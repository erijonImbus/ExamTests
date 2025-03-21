FROM python:3.9-slim


WORKDIR C:\Users\erijon.IMBUS\Desktop\RBF-MATERIALS\Exam-Copy\ExamTests


RUN pip install --upgrade pip && \
    pip install robotframework selenium


COPY . C:\Users\erijon.IMBUS\Desktop\RBF-MATERIALS\Exam-Copy\ExamTests


ENTRYPOINT ["robot"]


CMD ["C:\Users\erijon.IMBUS\Desktop\RBF-MATERIALS\Exam-Copy\ExamTests"]
