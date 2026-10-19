from django.db import connection
from django.http import JsonResponse

def health_check(request):
    try:
        connection.ensure_connection()
        db_ok = True
    except Exception:
        db_ok = False

    status = 200 if db_ok else 503
    return JsonResponse(
        {
            "status": "ok" if db_ok else "unhealthy",
            "database": "connected" if db_ok else "error",
        },
        status=status,
    )