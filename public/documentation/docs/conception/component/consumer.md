# Консьюмер

Сервис-потребитель данных из очереди.

Важно понимать, что это должен быть "тупой" сервис задача которого принять данные из очереди и используя web api сервиса конечного потребителя данных записать сами данные.

Нужно это для более гибкого скейлинга, чтобы была возможность отдельно скейлить api сервис и ссервисы консьюмеры